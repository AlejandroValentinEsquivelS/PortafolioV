import 'package:integradoradentista/PagesDentista/DentistaDetalles.dart';

import '../Pages/Login.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:integradoradentista/PagesDentista/Citas.dart';
import 'package:integradoradentista/Pages/PoliticasPrivacidad.dart';
import 'package:integradoradentista/PagesDentista/VistaCalendario.dart';
import 'package:integradoradentista/PagesDentista/NavigationBarDentista.dart';

class HomeDentista extends StatefulWidget {
  final String idUsuario;

  const HomeDentista({Key? key, required this.idUsuario}) : super(key: key);

  @override
  _HomeDentistaState createState() => _HomeDentistaState();
}

class _HomeDentistaState extends State<HomeDentista> {
  Map<String, dynamic>? dentista;
  bool isClicked1 = false;
  int _selectedIndex = 0;
  int citasCount = 0;// Contador de citas para el día actual


  @override
  void initState() {
    super.initState();
    fnObtenerDentista();
    obtenerResumenDiario(); // Llama al resumen diario
  }

  Future<void> fnObtenerDentista() async {
    try {
      DatabaseReference ref = FirebaseDatabase.instance.ref('dentistas/${widget.idUsuario}');
      DatabaseEvent event = await ref.once();

      if (event.snapshot.exists) {
        dentista = Map<String, dynamic>.from(event.snapshot.value as Map);
        setState(() {});
      } else {
        throw Exception('Dentista no encontrado');
      }
    } catch (error) {
      print('Error obteniendo dentista: $error');
    }
  }


  Future<void> fnObtenerDentistan() async {
    try {
      DatabaseReference ref = FirebaseDatabase.instance.ref('dentistas/${widget.idUsuario}');
      DatabaseEvent event = await ref.once();
      if (event.snapshot.exists) {
        dentista = Map<String, dynamic>.from(event.snapshot.value as Map);
        setState(() {}); // Para actualizar la UI con los datos obtenidos
      } else {
        throw Exception('Dentista no encontrado');
      }
    } catch (error) {
      print('Error obteniendo dentista: $error');
    }
  }



  Future<void> obtenerResumenDiario() async {
    try {
      final DatabaseReference citasRef = FirebaseDatabase.instance.ref('citas');
      final DatabaseEvent event = await citasRef.once();

      if (event.snapshot.exists) {
        final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
        int count = 0;

        final citas = Map<String, dynamic>.from(event.snapshot.value as Map);
        citas.forEach((key, value) {
          if (value is Map && value['fecha'] is String) {
            final fecha = value['fecha'] as String;
            if (fecha.substring(0, 10) == today) {
              count++;
            }
          }
        });

        setState(() {
          citasCount = count;
        });
      } else {
        print('No hay citas programadas');
      }
    } catch (error) {
      print('Error al obtener citas: $error');
    }
  }

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return; // Evita recargar la misma página
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        break;
      case 1:
        Navigator.push(context, MaterialPageRoute(builder: (context) => Citas(idDentista: widget.idUsuario)));
        break;
      case 2:
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.push(
            context,
              MaterialPageRoute(builder: (context) => VistaHorarios(idUsuario: widget.idUsuario)));
        });
        break;
      case 3:
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Dentistadetalles(idUsuario: widget.idUsuario)));
        });
        break;

      case 4:
        FirebaseAuth.instance.signOut().then((_) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(top:100, left:30, right:30, bottom: 10),
                child:

                Text(
                  '¡Bienvenido(a) ${dentista != null && dentista!['nombre'] != null ? '${dentista!['nombre']}!' : ''}',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2467ae),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 5),
                child: Image.asset(
                  'assets/Img/ClinicControlIcono.png', // Ruta de la imagen
                  height: 300,
                  width: 300,
                ),
              ),
              // Resumen Diario de Citas
              Padding(
                padding: EdgeInsets.only(top:10, left:30, right:30, bottom: 10),
                child: Card(
                  color: Colors.white,
                  child: ListTile(
                    leading: Icon(Icons.calendar_today, color: Color(0xFF2467ae)),
                    title: Text(
                      'Resumen diario de citas',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Tienes 0 citas programadas para hoy.',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
              // Indicador de ocupación
              Card(
                color: Colors.white,
                margin: EdgeInsets.only(top:10, left:30, right:30, bottom: 10),
                child: ListTile(
                  leading: Icon(Icons.people, color: Colors.orange),
                  title: Text('Disponibilidad',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  subtitle: Text('80% ocupado', style: TextStyle(fontSize: 16)),
                ),
              ),
              // Noticias y actualizaciones
              Card(
                color: Colors.white,
                margin: EdgeInsets.only(top:10, left:30, right:30, bottom: 10),
                child: ListTile(
                  leading: Icon(Icons.announcement, color: Colors.redAccent),
                  title: Text('Noticias y Actualizaciones',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  subtitle: Text('Nuevos servicios disponibles este mes.', style: TextStyle(fontSize: 16)),
                ),
              ),
              Card(
                color: Colors.white,
                margin: EdgeInsets.only(top: 10, left: 30, right: 30, bottom: 10),
                child: ListTile(
                  leading: Icon(Icons.info, color: Colors.yellow),
                  title: Text(
                    'Políticas de privacidad',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('Información legal de ClinicControl', style: TextStyle(fontSize: 16)),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PoliticasPrivacidad()),
                    );
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Versión 1.0',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
      // Barra de navegación inferior
      bottomNavigationBar: NavigationBarDentista(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
        idUsuario: widget.idUsuario,
      ),
    );
  }
}
