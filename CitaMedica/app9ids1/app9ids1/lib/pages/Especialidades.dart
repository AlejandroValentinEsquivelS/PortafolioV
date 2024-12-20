
import 'dart:convert';

import 'package:app9ids1/pages/Especialidad.dart';
import 'package:flutter/material.dart';
import 'package:app9ids1/Models/EspecialidadResponse.dart';
import 'package:http/http.dart' as http;

import '../Utils/Ambiente.dart';

class Especialidades extends StatefulWidget {
  const Especialidades({super.key});

  @override
  State<Especialidades> createState() => _EspecialidadesState();
}

class _EspecialidadesState extends State<Especialidades> {
  List<Especialidadresponse> especialidades = [];

  Widget _listViewEspecialidades() {
    return ListView.builder(
      itemCount: especialidades.length,
      itemBuilder: (context, index) {
        var especialidad = especialidades[index];
        return ListTile(
          title: Text(especialidad.id.toString()),
          subtitle: Text(especialidad.nombre),
        );
      },
    );
  }

  void fnObtenerEspecialidades() async {
    var response = await http.get(
      Uri.parse('${Ambiente.urlServer}/api/especialidades'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      },
    );
    Iterable mapEspecialidades = jsonDecode(response.body);
    especialidades = List<Especialidadresponse>.from(
      mapEspecialidades.map((model) => Especialidadresponse.fromJson(model)),
    );
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fnObtenerEspecialidades();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Especialidades',
          style: TextStyle(fontSize: 24)),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (value) {
              // Acciones a realizar cuando se selecciona una opción
            },
            itemBuilder: (BuildContext context) {
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
      body: _listViewEspecialidades(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const Especialidad(),
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
