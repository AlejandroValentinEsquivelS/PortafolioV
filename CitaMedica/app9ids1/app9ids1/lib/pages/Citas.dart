import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:app9ids1/Models/PacienteResponse2.dart';
import 'package:app9ids1/Models/Citaresponse2.dart'; // Importa Citaresponse2 en lugar de Citaresponse
import 'package:app9ids1/Models/EspecialidadResponse2.dart';
import 'package:app9ids1/Utils/Ambiente.dart';

import 'CitaDetailPage.dart';
import 'Login.dart';

class Citas extends StatefulWidget {
  final int idUsuario;

  const Citas({Key? key, required this.idUsuario}) : super(key: key);

  @override
  _CitasState createState() => _CitasState();
}

class _CitasState extends State<Citas> {
  Pacienteresponse2? paciente;
  List<Citaresponse2> citas = []; // Utiliza Citaresponse2 en lugar de Citaresponse
  List<EspecialidadResponse2> especialidades = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fnObtenerPaciente();
  }

  Future<void> fnObtenerPaciente() async {
    try {
      var response = await http.get(
        Uri.parse('${Ambiente.urlServer}/api/paciente/${widget.idUsuario}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> pacienteJson = jsonDecode(response.body);
        paciente = Pacienteresponse2.fromJson(pacienteJson);
        await fnObtenerCitas(paciente!.id);
        await fnObtenerEspecialidades();
        setState(() {});
      } else {
        throw Exception('Error al obtener los datos del paciente: ${response.statusCode}');
      }
    } catch (error) {
      print('Error obteniendo paciente: $error');
    }
  }

  Future<void> fnObtenerCitas(int idPaciente) async {
    try {
      final response = await http.get(
        Uri.parse('${Ambiente.urlServer}/api/citas/paciente/$idPaciente'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          citas = data.map((json) => Citaresponse2.fromJson(json)).toList(); // Utiliza Citaresponse2.fromJson en lugar de Citaresponse.fromJson
          isLoading = false;
        });
      } else {
        throw Exception('Error al obtener las citas: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error: $e');
    }
  }

  Future<void> fnObtenerEspecialidades() async {
    try {
      final response = await http.get(
        Uri.parse('${Ambiente.urlServer}/api/especialidades'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          especialidades = data.map((json) => EspecialidadResponse2.fromJson(json)).toList();
        });
      } else {
        throw Exception('Error al obtener las especialidades: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  String obtenerNombreEspecialidad(int idEspecialidad) {
    final especialidad =
    especialidades.firstWhere((e) => e.id == idEspecialidad, orElse: () => EspecialidadResponse2(id: 0, nombre: 'Desconocido'));
    return especialidad.nombre;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Citas",
          style: TextStyle(fontSize: 24),
        ),
        backgroundColor: Color(0xFF00866E),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 16),
            Text(
              'Bienvenido ${paciente?.nombre ?? 'Cargando...'}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              '${paciente?.correo ?? 'Cargando...'}',
              style: TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Text(
              'Tus Citas',
              style: TextStyle(
                fontSize: 18,
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            isLoading
                ? Center(child: CircularProgressIndicator())
                : citas.isEmpty
                ? Center(child: Text('No tienes citas'))
                : Expanded(
              child: ListView.builder(
                itemCount: citas.length,
                itemBuilder: (context, index) {
                  final cita = citas[index];
                  final especialidadNombre = obtenerNombreEspecialidad(cita.idEspecialidad);
                  return Card(
                    elevation: 2,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(
                        'Especialidad: $especialidadNombre',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'Fecha y Hora: ${cita.fechaHora}',
                        style: TextStyle(fontSize: 14),
                      ),
                      onTap: () {

                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
