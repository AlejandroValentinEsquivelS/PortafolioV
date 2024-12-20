import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/quickalert.dart';
import 'package:app9ids1/Models/PacienteResponse2.dart';
import 'package:app9ids1/pages/Citas.dart';
import '../Utils/Ambiente.dart';
import 'Cita.dart';
import 'Login.dart';

class Home extends StatefulWidget {
  final int idUsuario;

  const Home({Key? key, required this.idUsuario}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Pacienteresponse2? paciente;
  bool isClicked1 = false;
  bool isClicked2 = false;

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
        setState(() {});
      } else {
        throw Exception('Error al obtener los datos del paciente: ${response.statusCode}');
      }
    } catch (error) {
      print('Error obteniendo paciente: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Inicio",
          style: TextStyle(fontSize: 24),
        ),
        backgroundColor: Color(0xFF00866E),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xFF00866E),
              ),
              child: Column(
                children: [
                  const Expanded(
                    child: Image(
                      image: AssetImage('assets/images/bot-conversacional.png'),
                    ),
                  ),
                  Text(
                    'Bienvenido ${paciente?.nombre ?? 'Cargando...'}',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    ' ${paciente?.correo ?? 'Cargando...'}',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person_pin_rounded),
              title: const Text('Citas'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Citas(idUsuario: widget.idUsuario),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.login),
              title: const Text('Cerrar Sesión'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Login(),
                  ),
                );
                // Implementar cierre de sesión
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  isClicked1 = !isClicked1;
                });
                Future.delayed(Duration(milliseconds: 300), () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Cita(idPaciente: widget.idUsuario),
                    ),
                  );
                });
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                padding: EdgeInsets.all(isClicked1 ? 16 : 8),
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(
                      'https://cdn-icons-png.freepik.com/512/4319/4319308.png',
                      width: 70,
                      height: 70,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Agendar cita',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
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

