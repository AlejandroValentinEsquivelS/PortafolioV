import 'dart:convert';
import 'package:app9ids1/pages/Paciente.dart';
import 'package:flutter/material.dart';
import 'package:app9ids1/Models/PacienteResponse.dart';
import 'package:http/http.dart' as http;

import '../Utils/Ambiente.dart';

class Pacientes extends StatefulWidget {
  const Pacientes({super.key});

  @override
  State<Pacientes> createState() => _PacientesState();
}

class _PacientesState extends State<Pacientes> {
  List<Pacienteresponse> pacientes = [];

  Widget _listViewPacientes() {
    return ListView.builder(
      itemCount: pacientes.length,
      itemBuilder: (context, index) {
        var paciente = pacientes[index];
        return ListTile(
          onTap: (){Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Paciente(idPaciente: paciente.id,)
            ),
          );},
          title: Text(paciente.id.toString()),
          subtitle: Text(paciente.nombre),
        );
      },
    );
  }

  void fnObtenerPacientes() async {
    var response = await http.get(
      Uri.parse('${Ambiente.urlServer}/api/pacientes'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      },
    );
    Iterable mapPacientes = jsonDecode(response.body);
    pacientes = List<Pacienteresponse>.from(
      mapPacientes.map((model) => Pacienteresponse.fromJson(model)),
    );
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fnObtenerPacientes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pacientes',
            style: TextStyle(fontSize: 24)),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (value) {
              // Acciones a realizar cuando se selecciona una opción
            },
            itemBuilder: (BuildContext context) {
              fnObtenerPacientes();
              return {'Actualizar Lista'}.map((String item) {
                return PopupMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList();
            },
          ),
        ],
        backgroundColor: Color(0xFF00866E), // Color de fondo del AppBar
        foregroundColor: Colors.white,
        centerTitle: true, // Para centrar el título
      ),
      body: _listViewPacientes(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const Paciente(idPaciente: 0,),
            ),
          );
        },
        backgroundColor: Color(0xFF00866E), // Color de fondo del botón
        foregroundColor: Colors.white, // Color del icono del botón
        child: Icon(Icons.add),
      ),
    );
  }
}
