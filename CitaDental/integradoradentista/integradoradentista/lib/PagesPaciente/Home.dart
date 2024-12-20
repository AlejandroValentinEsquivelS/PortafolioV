import 'Citas.dart';
import '../Pages/Login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:integradoradentista/PagesPaciente/Cita.dart';
import 'package:integradoradentista/Models/PacienteResponse2.dart';
import 'package:integradoradentista/Pages/PoliticasPrivacidad.dart';
import 'package:integradoradentista/PagesPaciente/PacienteDetalles.dart';

class Home extends StatefulWidget {
  final String idUsuario;

  const Home({Key? key, required this.idUsuario}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Pacienteresponse2? paciente;
  bool isClicked1 = false;
  int _selectedIndex = 0;
  String nombrePaciente = '';
  int citasCount = 0;
  final DatabaseReference databaseRef = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    super.initState();
    fnObtenerPaciente();
    fnContarCitasHoy(); // Para el resumen diario de citas
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navegación según la pestaña seleccionada
    switch (index) {
      case 0:
      // Mantener la página actual
        break;
      case 1:
        Navigator.push(context, MaterialPageRoute(builder: (context) => Citas(idUsuario: widget.idUsuario)));
        break;
      case 2:
        Navigator.push(context, MaterialPageRoute(builder: (context) => Pacientedetalles(idUsuario: widget.idUsuario)));
        break;
      case 3:
        FirebaseAuth.instance.signOut().then((_) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
        });
        break;
    }
  }

  Future<void> fnObtenerPaciente() async {
    try {
      final pacienteSnapshot = await databaseRef.child('pacientes/${widget.idUsuario}').once();
      if (pacienteSnapshot.snapshot.exists) {
        final pacienteData = Map<String, dynamic>.from(pacienteSnapshot.snapshot.value as Map);
        pacienteData['id'] = pacienteSnapshot.snapshot.key;

        paciente = Pacienteresponse2.fromJson(pacienteData);

        setState(() {
          nombrePaciente = paciente!.nombre;
        });
      } else {
        throw Exception('Paciente no encontrado');
      }
    } catch (error) {
      print('Error obteniendo paciente: $error');
    }
  }

  Future<void> fnContarCitasHoy() async {
    // Implementación para contar citas del día
    try {
      // Aquí agregarías la lógica para contar las citas programadas para hoy
      setState(() {
        citasCount = 0; // Ejemplo de conteo de citas, sustituir con el real
      });
    } catch (error) {
      print('Error obteniendo el conteo de citas: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 100, left: 30, right: 30, bottom: 10),
              child: Text(
                'Bienvenido(a) ${paciente?.nombre ?? 'Cargando...'}',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                    color: Color(0xFF2467ae)
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Image.asset(
                'assets/Img/ClinicControlIcono.png',
                height: 250,
                width: 250,
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  isClicked1 = !isClicked1;
                });
                Future.delayed(const Duration(milliseconds: 300), () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Cita(idPaciente: widget.idUsuario),
                    ),
                  );
                });
              },
              child: Card(
                color: Colors.white,
                margin: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                child: ListTile(
                  leading: const Icon(Icons.app_registration_sharp,color: Color(0xFF2467ae)),
                  title: const Text(
                    'Agendar cita',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  subtitle: const Text('Clic aquí para agendar una nueva cita', style: const TextStyle(fontSize: 16),),

                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Cita(idPaciente: widget.idUsuario))
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
              child: Card(
                color: Colors.white,
                child: ListTile(
                  leading: const Icon(Icons.calendar_today, color: Color(0xFF2467ae)),
                  title: const Text(
                    'Resumen diario de citas',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Tienes $citasCount citas programadas para hoy',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
            Card(
              color: Colors.white,
              margin: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
              child: const ListTile(
                leading: Icon(Icons.announcement, color: Colors.redAccent),
                title: Text(
                  'Noticias y Actualizaciones',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                subtitle: Text('Nuevos servicios disponibles este mes', style: const TextStyle(fontSize: 16),),
              ),
            ),
            Card(
              color: Colors.white,
              margin: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
              child: ListTile(
                leading: const Icon(Icons.info, color: Colors.yellow),
                title: const Text(
                  'Políticas de privacidad',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                subtitle: const Text('Información legal de ClinicControl', style: const TextStyle(fontSize: 16),),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PoliticasPrivacidad()),
                  );
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Versión 1.0',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Citas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_sharp),
            label: 'Perfil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            label: 'Cerrar Sesión',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}