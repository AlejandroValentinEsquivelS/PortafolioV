import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wearapp/Models/ConsultorioResponse.dart';
import 'package:wearapp/Models/DoctorResponse.dart';
import 'package:wearapp/Utils/Ambiente.dart';
import '../Models/CitaResponse.dart';

class CitaDetailPage extends StatefulWidget {
  final int idcita;

  const CitaDetailPage({Key? key, required this.idcita}) : super(key: key);

  @override
  State<CitaDetailPage> createState() => _CitaDetailPageState();
}

class _CitaDetailPageState extends State<CitaDetailPage> {
  String estado = '';
  String nombreDoctor = '';
  String edificio = '';
  int numero = 0;
  int nivel = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    obtenerCitaDetalle();
  }

  Future<void> obtenerCitaDetalle() async {
    try {
      final response = await http.get(
        Uri.parse('${Ambiente.urlServer}/api/citas/obtener/${widget.idcita}'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final cita = Citaresponse.fromJson(data);
        await obtenerDoctor(cita.id_doc);
        await obtenerConsultorio(cita.id_consultorio);
        setState(() {
          estado = cita.estado;
          isLoading = false;
        });
      } else {
        throw Exception('Error al obtener el detalle de la cita: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error: $e');
    }
  }

  Future<void> obtenerDoctor(int iddoc) async {
    try {
      final response = await http.get(
        Uri.parse('${Ambiente.urlServer}/api/doctores/obtener/$iddoc'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final doctor = Doctorresponse.fromJson(data);
        setState(() {
          nombreDoctor = doctor.nombre;
        });
      } else {
        throw Exception('Error al obtener el doctor: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> obtenerConsultorio(int idcon) async {
    try {
      final response = await http.get(
        Uri.parse('${Ambiente.urlServer}/api/consultorios/obtener/$idcon'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final consultorio = Consultorioresponse.fromJson(data);
        setState(() {
          edificio = consultorio.edificio;
          numero = consultorio.numero;
          nivel = consultorio.nivel;
        });
      } else {
        throw Exception('Error al obtener el consultorio: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Detalle de Cita",
          style: TextStyle(
            fontSize: 14,
            color: Colors.blueAccent,
            height: 1.2,
            wordSpacing: 1,
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Estado de la cita: $estado',
              style: const TextStyle(fontSize: 12, color: Colors.brown),
            ),
            const SizedBox(height: 8),
            Text(
              'Doctor: $nombreDoctor',
              style: const TextStyle(fontSize: 12, color: Colors.brown),
            ),
            const SizedBox(height: 8),

            Text(
              'Su cita es en el edificio: $edificio Consultorio No: $numero Nivel: $nivel',
              style: const TextStyle(fontSize: 12, color: Colors.brown),
            ),
          ],
        ),
      ),
    );
  }
}
