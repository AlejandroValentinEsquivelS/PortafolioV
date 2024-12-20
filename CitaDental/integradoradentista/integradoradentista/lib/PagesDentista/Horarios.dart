import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart'; // Importa intl para el formateo de fecha y hora

class Horarios extends StatefulWidget {
  final String idUsuario;

  const Horarios({Key? key, required this.idUsuario}) : super(key: key);

  @override
  _HorariosState createState() => _HorariosState();
}

class _HorariosState extends State<Horarios> {
  Map<String, Map<String, dynamic>> horarios = {
    'Lunes': {'activo': false, 'inicio': null, 'fin': null},
    'Martes': {'activo': false, 'inicio': null, 'fin': null},
    'Miércoles': {'activo': false, 'inicio': null, 'fin': null},
    'Jueves': {'activo': false, 'inicio': null, 'fin': null},
    'Viernes': {'activo': false, 'inicio': null, 'fin': null},
    'Sábado': {'activo': false, 'inicio': null, 'fin': null},
    'Domingo': {'activo': false, 'inicio': null, 'fin': null},
  };

  final TimeOfDay horaMinimaInicio = TimeOfDay(hour: 10, minute: 0);
  final TimeOfDay horaMaximaFin = TimeOfDay(hour: 18, minute: 0);

  Future<void> _seleccionarHora(String dia, String tipo) async {
    final TimeOfDay? tiempoSeleccionado = await showTimePicker(
      context: context,
      initialTime: tipo == 'inicio' ? horaMinimaInicio : horaMaximaFin,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              dialBackgroundColor: Colors.blue[50], // Light blue for dial background
              dialTextColor: Color(0xFF2467ae), // Blue color for dial text
              hourMinuteColor: MaterialStateColor.resolveWith((states) =>
              states.contains(MaterialState.selected) ? Color(0xFF2467ae) : Colors.white), // Blue for selected hour/minute
              hourMinuteTextColor: MaterialStateColor.resolveWith((states) =>
              states.contains(MaterialState.selected) ? Colors.white : Color(0xFF2467ae)), // White text when selected, blue otherwise
              dayPeriodTextColor: Color(0xFF2467ae), // Blue for AM/PM text
              entryModeIconColor: Color(0xFF2467ae), // Blue icon color
              helpTextStyle: TextStyle(
                color: Color(0xFF2467ae),
                fontWeight: FontWeight.bold,
              ), // Blue and bold for help text
            ),
            textTheme: TextTheme(
              titleLarge: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold), // Bold blue for header text
              labelLarge: TextStyle(color: Colors.blue), // Blue for buttons
            ),
            colorScheme: ColorScheme.light(
              primary: Colors.blue, // Blue for main color
              onPrimary: Colors.white, // White text on primary
              onSurface: Colors.blue, // Blue for dialog text
            ),
          ),
          child: child!,
        );
      },
    );
    if (tiempoSeleccionado != null) {
      // Ensure the selected time adheres to minimum and maximum time constraints.
      if (tipo == 'inicio' && (tiempoSeleccionado.hour < horaMinimaInicio.hour ||
          (tiempoSeleccionado.hour == horaMinimaInicio.hour && tiempoSeleccionado.minute < horaMinimaInicio.minute))) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('La hora de inicio debe ser después de las ${horaMinimaInicio.format(context)}')),
        );
        return;
      }

      if (tipo == 'fin' && (tiempoSeleccionado.hour > horaMaximaFin.hour ||
          (tiempoSeleccionado.hour == horaMaximaFin.hour && tiempoSeleccionado.minute > horaMaximaFin.minute))) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('La hora de fin debe ser antes de las ${horaMaximaFin.format(context)}')),
        );
        return;
      }

      setState(() {
        horarios[dia]?[tipo] = tiempoSeleccionado;
      });
    }
  }

  Future<void> _guardarHorario() async {
    String? idDentista = FirebaseAuth.instance.currentUser?.uid;
    if (idDentista == null) {
      _mostrarSnackBar('Error: Usuario no autenticado');
      return;
    }

    try {
      DatabaseReference ref = FirebaseDatabase.instance.ref('horariosDoctores/$idDentista');
      horarios.forEach((dia, detalle) async {
        if (detalle['activo'] == true && detalle['inicio'] != null && detalle['fin'] != null) {
          TimeOfDay inicio = detalle['inicio'] as TimeOfDay; // Ensure correct type
          TimeOfDay fin = detalle['fin'] as TimeOfDay;       // Ensure correct type

          DateTime startTime = DateTime(2023, 1, 1, inicio.hour, inicio.minute);
          DateTime endTime = DateTime(2023, 1, 1, fin.hour, fin.minute);

          int intervalIndex = 1;
          while (startTime.isBefore(endTime)) {
            DateTime nextInterval = startTime.add(Duration(hours: 1));
            String intervalo = 'intervalo${intervalIndex.toString().padLeft(2, '0')}';

            await ref.child('horarios/$dia/$intervalo').set({
              'horario': '${_formatHora(startTime)}-${_formatHora(nextInterval)}',
              'estado': 'disponible',
              'inicio': DateFormat('HH:mm').format(startTime), // Guarda la fecha y hora de inicio
              'fin': DateFormat('HH:mm').format(nextInterval),  // Guarda la fecha y hora de fin
            });

            startTime = nextInterval;
            intervalIndex++;
          }
        }
      });

      _mostrarSnackBar('Horario guardado exitosamente con intervalos');
    } catch (e) {
      _mostrarSnackBar('Error al guardar el horario: $e');
    }
  }

  String _formatHora(DateTime time) {
    return DateFormat('HH:mm').format(time);
  }

  void _mostrarSnackBar(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mensaje)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Horario'),
        backgroundColor: Color(0xFF2467ae),
        foregroundColor: Colors.white,
        centerTitle: true,

      ),
      body: ListView(
        children: horarios.keys.map((dia) {
          return Column(
            children: [
              SwitchListTile(
                title: Text(dia, style: TextStyle(fontWeight: FontWeight.bold)),
                value: horarios[dia]?['activo'] ?? false,
                activeColor: Color(0xFF2467ae),
                onChanged: (bool valor) {
                  setState(() {
                    horarios[dia]?['activo'] = valor;
                    if (!valor) {
                      horarios[dia]?['inicio'] = null;
                      horarios[dia]?['fin'] = null;
                    }
                  });
                },
              ),
              if (horarios[dia]?['activo'] == true) ...[
                ListTile(
                  title: Text('Hora de entrada'),
                  trailing: Text(
                    horarios[dia]?['inicio']?.format(context) ?? 'Seleccionar',
                    style: TextStyle(color: Color(0xFF2467ae)),
                  ),
                  onTap: () => _seleccionarHora(dia, 'inicio'),
                ),
                ListTile(
                  title: Text('Hora de salida'),
                  trailing: Text(
                    horarios[dia]?['fin']?.format(context) ?? 'Seleccionar',
                    style: TextStyle(color: Color(0xFF2467ae)),
                  ),
                  onTap: () => _seleccionarHora(dia, 'fin'),
                ),
              ],
              Divider(),
            ],
          );
        }).toList(),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: _guardarHorario,
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF2467ae), // Color de fondo
            foregroundColor: Colors.white, // Color del texto
            padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
          ),
          child: const Text(
            'Guardar horario',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
