import 'package:flutter/material.dart';
import 'package:integradoradentista/PagesPaciente/Paciente.dart';
import 'package:integradoradentista/PagesPaciente/Home.dart';
import 'package:integradoradentista/PagesDentista/HomeDentista.dart'; // Asegúrate de importar la página HomeDentista
import 'package:quickalert/quickalert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart'; // Importa Realtime Database

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController txtUser = TextEditingController();
  TextEditingController txtPassword = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  void showWelcomeAlert(BuildContext context) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      title: '¡Bienvenido(a)!',
      text: 'Gracias por iniciar sesión',
      confirmBtnText: 'Aceptar',
    );
  }

  Future<void> _loginUser() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: txtUser.text.trim(),
        password: txtPassword.text.trim(),
      );

      String userId = userCredential.user!.uid;

      DatabaseReference pacientesRef = _database.ref('pacientes/$userId');
      DatabaseEvent pacientesEvent = await pacientesRef.once();

      if (pacientesEvent.snapshot.exists) {
        showWelcomeAlert(context);

        await Future.delayed(Duration(seconds: 2));

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Home(idUsuario: userId),
          ),
        );
      } else {
        DatabaseReference dentistasRef = _database.ref('dentistas/$userId');
        DatabaseEvent dentistasEvent = await dentistasRef.once();

        if (dentistasEvent.snapshot.exists) {
          showWelcomeAlert(context);

          await Future.delayed(Duration(seconds: 2));

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeDentista(idUsuario: userId),
            ),
          );
        } else {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            title: 'Error',
            text: 'Usuario no encontrado.',
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Error',
        text: e.message ?? 'Error desconocido.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Imagen
          Positioned(
            top: 150,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/Img/ClinicControlIcono.png', // Ruta de la imagen
              height: 350,
              width: 350,
            ),
          ),
          SizedBox(height: 200),
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 450),
                  Text(
                    "Inicio de sesión",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: txtUser,
                    decoration: InputDecoration(
                        labelText: 'Correo electrónico',
                        labelStyle: TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: Colors.grey.withOpacity(0.2),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide.none,
                        ),

                        prefixIcon: Icon(Icons.alternate_email, color: Color(0xFF949699))
                    ),
                    style: TextStyle(color: Colors.black),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: txtPassword,
                    decoration: InputDecoration(
                        labelText: 'Contraseña',
                        labelStyle: TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: Colors.grey.withOpacity(0.2),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: Icon(Icons.lock, color: Color(0xFF949699))
                    ),
                    style: TextStyle(color: Colors.black),
                    obscureText: true,
                  ),
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {

                      },
                      child: Text(
                        'Version 1.0',
                        style: TextStyle(color: Color(0xFF2467ae)
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _loginUser,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:Color(0xFF2467ae),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      minimumSize: Size(double.infinity, 50),
                    ),
                    child: Text(
                      'Aceptar',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        // Navigate to register screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Paciente(idPaciente: 0),
                          ),
                        );
                      },
                      child: Text.rich(
                        TextSpan(
                          text: " ",
                          children: [
                            TextSpan(
                              text: 'Crear cuenta',
                              style: TextStyle(color: Color(0xFF2467ae) ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
