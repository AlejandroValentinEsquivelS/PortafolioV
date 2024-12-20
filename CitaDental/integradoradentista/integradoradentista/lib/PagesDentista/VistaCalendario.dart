import 'package:integradoradentista/PagesDentista/DentistaDetalles.dart';

import 'Citas.dart';
import '../Pages/Login.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:integradoradentista/PagesDentista/Horarios.dart';
import 'package:integradoradentista/PagesDentista/HomeDentista.dart';
import 'package:integradoradentista/PagesDentista/NavigationBarDentista.dart';

class VistaHorarios extends StatefulWidget {
  final String idUsuario;

  const VistaHorarios({Key? key, required this.idUsuario}) : super(key: key);

  @override
  _VistaHorariosState createState() => _VistaHorariosState();
}

class _VistaHorariosState extends State<VistaHorarios> {
  Map<DateTime, List<Map<String, String>>> horarios = {};
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  bool isClicked1 = false;
  int _selectedIndex = 2;

  @override
  void initState() {
    super.initState();
    _cargarHorarios();
  }

  Future<void> _cargarHorarios() async {
    String? idDentista = FirebaseAuth.instance.currentUser?.uid;
    if (idDentista == null) return;

    DatabaseReference ref = FirebaseDatabase.instance.ref('horariosDoctores/$idDentista/horarios');
    DatabaseEvent event = await ref.once();

    if (event.snapshot.exists) {
      Map<String, dynamic> horariosData = Map<String, dynamic>.from(event.snapshot.value as Map);

      Map<DateTime, List<Map<String, String>>> tempHorarios = {};

      horariosData.forEach((dia, detalles) {
        DateTime date = _convertirADate(dia);

        // Itera sobre cada intervalo del día
        detalles.forEach((intervalo, info) {
          if (info['inicio'] != null && info['fin'] != null) {
            if (tempHorarios[date] == null) {
              tempHorarios[date] = [];
            }
            tempHorarios[date]!.add({
              'inicio': info['inicio'],
              'fin': info['fin'],
            });
          }
        });
      });

      setState(() {
        horarios = tempHorarios;
      });
    } else {
      print("No se encontraron datos en la base de datos.");
    }
  }

  DateTime _convertirADate(String dia) {
    switch (dia) {
      case 'Lunes':
        return DateTime.now().subtract(Duration(days: DateTime
            .now()
            .weekday - 1));
      case 'Martes':
        return DateTime.now().subtract(Duration(days: DateTime
            .now()
            .weekday - 2));
      case 'Miércoles':
        return DateTime.now().subtract(Duration(days: DateTime
            .now()
            .weekday - 3));
      case 'Jueves':
        return DateTime.now().subtract(Duration(days: DateTime
            .now()
            .weekday - 4));
      case 'Viernes':
        return DateTime.now().subtract(Duration(days: DateTime
            .now()
            .weekday - 5));
      case 'Sábado':
        return DateTime.now().subtract(Duration(days: DateTime
            .now()
            .weekday - 6));
      case 'Domingo':
        return DateTime.now().subtract(Duration(days: DateTime
            .now()
            .weekday - 7));
      default:
        return DateTime.now();
    }
  }

  List<Map<String, String>> _getEventosDelDia(DateTime date) {
    return horarios[date] ?? [];
  }

  String _formatDate(DateTime date) {
    return DateFormat('EEEE', 'es_ES').format(date);
  }

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return; // Evita recargar la misma página
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => HomeDentista(idUsuario: widget.idUsuario)));
        break;
      case 1:
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => Citas(idDentista: widget.idUsuario)));
        break;
      case 2:
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>
                  VistaHorarios(idUsuario: widget.idUsuario)));
        });
        break;
      case 3:
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>
                  Dentistadetalles(idUsuario: widget.idUsuario)));
        });
        break;

      case 4:
        FirebaseAuth.instance.signOut().then((_) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Login()));
        });
        break;
    }
  }
  @override
  Widget build(BuildContext context) {
    List<Widget> _buildTarjetasPorDia() {
      List<Widget> widgets = [];
      final diasOrdenados = horarios.keys.toList()..sort();

      diasOrdenados.forEach((dia) {
        final intervals = horarios[dia];
        if (intervals != null && intervals.isNotEmpty) {
          widgets.add(
            Card(
              margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              color: Colors.grey.shade100,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      _formatDate(dia), // Display day in readable format
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2467ae),
                      ),
                    ),
                    Divider(thickness: 1.0),
                    ...intervals.map((interval) => Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.access_time,
                          color: Color(0xFF2467ae),
                        ),
                        const SizedBox(width: 8.0),
                        Text(
                          'Horario: ${interval['inicio']} - ${interval['fin']}',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ],
                    )).toList(),
                  ],
                ),
              ),
            ),
          );
        }
      });

      return widgets;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Horario de Trabajo'),
        backgroundColor: Color(0xFF2467ae),
        foregroundColor: Colors.white,
        centerTitle: true,
        automaticallyImplyLeading: false, // Elimina la flecha de retroceso
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: _buildTarjetasPorDia(), // Muestra las tarjetas por día
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0), // Despega el contenedor de los lados
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8.0), // Espacio entre el título y el contenedor
                Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3), // Sombra opcional
                      ),
                    ],
                  ),
                  child: TableCalendar(
                    locale: 'es_ES',
                    focusedDay: _focusedDay,
                    firstDay: DateTime(2020),
                    lastDay: DateTime(2100),
                    calendarFormat: _calendarFormat,
                    onFormatChanged: (format) {
                      setState(() {
                        _calendarFormat = format;
                      });
                    },
                    selectedDayPredicate: (day) {
                      return isSameDay(_selectedDay, day);
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });
                    },
                    eventLoader: _getEventosDelDia,
                    calendarStyle: CalendarStyle(
                      todayDecoration: BoxDecoration(
                        color: Color(0xFF2467ae),
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: BoxDecoration(
                        color: Color(0xFF2467ae),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8.0),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Horarios(idUsuario: 'idUsuario'),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF2467ae),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
              ),
              child: const Center(
                child: Text(
                  'Actualizar horario',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBarDentista(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
        idUsuario: widget.idUsuario,
      ),
    );
  }
}