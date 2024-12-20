import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class CitaDetalles extends StatefulWidget {
  final String idCita;

  const CitaDetalles(this.idCita, {Key? key}) : super(key: key);

  @override
  State<CitaDetalles> createState() => _CitaDetallesState();
}

class _CitaDetallesState extends State<CitaDetalles> {
  final DatabaseReference databaseRef = FirebaseDatabase.instance.ref();
  Map<String, dynamic>? cita;
  String? nombreDentista;
  String? nombrePaciente;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('es', null).then((_) => _obtenerDetallesCita());
  }

  Future<void> _obtenerDetallesCita() async {
    try {
      final snapshot = await databaseRef.child('citas/${widget.idCita}').once();
      if (snapshot.snapshot.exists) {
        cita = Map<String, dynamic>.from(snapshot.snapshot.value as Map);

        // Obtener los nombres del dentista y paciente
        nombreDentista = await obtenerNombreDentista(cita!['idDentista']);
        nombrePaciente = await obtenerNombrePaciente(cita!['idPaciente']);

        setState(() {
          isLoading = false;
        });
      } else {
        throw Exception('Cita no encontrada');
      }
    } catch (e) {
      print('Error al obtener los detalles de la cita: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<String> obtenerNombreDentista(String idDentista) async {
    try {
      final dentistaSnapshot = await databaseRef.child('dentistas/$idDentista').once();
      if (dentistaSnapshot.snapshot.exists) {
        final dentistaData = dentistaSnapshot.snapshot.value as Map<dynamic, dynamic>;
        return dentistaData['nombre'] ?? 'Dentista desconocido';
      } else {
        return 'Dentista no encontrado';
      }
    } catch (e) {
      print('Error obteniendo dentista: $e');
      return 'Error al obtener nombre';
    }
  }

  Future<String> obtenerNombrePaciente(String idPaciente) async {
    try {
      final pacienteSnapshot =
      await databaseRef.child('pacientes/$idPaciente').once();

      if (pacienteSnapshot.snapshot.exists) {
        final pacienteData =
        pacienteSnapshot.snapshot.value as Map<dynamic, dynamic>;
        return pacienteData['nombre'] as String? ?? 'Nombre desconocido';
      } else {
        return 'Paciente no encontrado';
      }
    } catch (e) {
      print('Error obteniendo paciente: $e');
      return 'Error al obtener nombre del paciente';
    }
  }

  String formatFecha(String fecha) {
    try {
      DateTime dateTime = DateTime.parse(fecha);
      return DateFormat('d \'de\' MMMM \'de\' yyyy', 'es').format(dateTime);
    } catch (e) {
      print('Error formateando la fecha: $e');
      return 'Formato de fecha inválido';
    }
  }

  String formatHora(String fecha) {
    try {
      DateTime dateTime = DateTime.parse(fecha);
      return DateFormat('hh:mm a', 'es').format(dateTime);
    } catch (e) {
      print('Error formateando la hora: $e');
      return 'Formato de hora inválido';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles de la cita'),
        backgroundColor: Color(0xFF2467ae),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : cita == null
          ? const Center(child: Text('No se encontraron detalles de la cita.'))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              color: Color(0xFFE3F2FD),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.person, color: Color(0xFF2467ae)),
                        const SizedBox(width: 8),
                        Text(
                          'Dentista: ${nombreDentista ?? 'Sin asignar'}',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.person_add, color: Color(0xFF2467ae)),
                        const SizedBox(width: 8),
                        Text(
                          'Paciente: ${nombrePaciente ?? 'Desconocido'}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.calendar_today, color: Color(0xFF2467ae)),
                        const SizedBox(width: 8),
                        Text(
                          'Fecha: ${formatFecha(cita!['fecha'] ?? '')}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.access_time, color: Color(0xFF2467ae)),
                        const SizedBox(width: 8),
                        Text(
                          'Hora: ${formatHora(cita!['fecha'] ?? '')}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.info, color: Color(0xFF2467ae)),
                        const SizedBox(width: 8),
                        Text(
                          'Estado: ${cita!['estado'] ?? 'Sin estado'}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
