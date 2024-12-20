import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/quickalert.dart';

import '../Models/LoginResponse.dart';
import '../Utils/Ambiente.dart';
import 'Cita.dart';
import 'Home.dart';
import 'Paciente.dart'; // Asegúrate de importar Paciente si se utiliza aquí

class Login extends StatefulWidget {
  const Login({Key? key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController txtUser = TextEditingController();
  TextEditingController txtPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Iniciar Sesión",
          style: TextStyle(fontSize: 24),
        ),
        backgroundColor: Color(0xFF00866E),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 40),
            Image.network(
              'https://cdn-icons-png.flaticon.com/512/3985/3985429.png',
              width: 250,
              height: 250,
            ),
            SizedBox(height: 1),
            Padding(
              padding: EdgeInsets.fromLTRB(40, 0, 40, 20),
              child: TextField(
                controller: txtUser,
                decoration: InputDecoration(
                    labelText: 'Correo electrónico',
                    labelStyle: TextStyle(
                      fontSize: 14,
                    ),
                    prefixIcon: Icon(Icons.alternate_email, color: Color(0xFF00866E))
                ),
              ),
            ),
            SizedBox(height: 1),
            Padding(
              padding: EdgeInsets.fromLTRB(40, 0, 40, 40),
              child: TextField(
                controller: txtPassword,
                decoration: InputDecoration(
                    labelText: 'Constraseña',
                    labelStyle: TextStyle(
                      fontSize: 14,
                    ),
                    prefixIcon: Icon(Icons.lock, color: Color(0xFF00866E))
                ),
                obscureText: true,
              ),
            ),
            TextButton(
              onPressed: () async {
                final response = await http.post(
                  Uri.parse('${Ambiente.urlServer}/api/login'),
                  body: jsonEncode(<String, dynamic>{
                    'email': txtUser.text,
                    'password': txtPassword.text
                  }),
                  headers: <String, String>{
                    'Content-Type': 'application/json; charset=UTF-8'
                  },
                );

                if (response.statusCode == 200) {
                  Map<String, dynamic> responseJson = jsonDecode(response.body);
                  final loginResponse = Loginresponse.fromJson(responseJson);

                  if (loginResponse.acceso == "Ok") {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Home(idUsuario: loginResponse.idUsuario ?? 0),
                      ),
                    );
                  } else {
                    QuickAlert.show(
                      context: context,
                      type: QuickAlertType.error,
                      title: 'Oops..',
                      text: loginResponse.error,
                    );
                  }
                } else {
                  QuickAlert.show(
                    context: context,
                    type: QuickAlertType.error,
                    title: 'Error de conexión',
                    text: 'No se pudo conectar al servidor.',
                  );
                }
              },
              style: TextButton.styleFrom(
                backgroundColor: Color(0xFF00866E),
                foregroundColor: Colors.white,
              ),
              child: Text('Aceptar'),
            ),
            SizedBox(height: 20), // Espacio entre los botones
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Paciente(idPaciente: 0),
                  ),
                );
              },
              style: TextButton.styleFrom(
                backgroundColor: Color(0xFF00866E),
                foregroundColor: Colors.white,
              ),
              child: Text('Registrar paciente'),
            ),
          ],
        ),
      ),
    );
  }
}

