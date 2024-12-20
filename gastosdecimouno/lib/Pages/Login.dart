import 'package:flutter/material.dart';
import 'package:gastosdecimouno/Pages/ListaCategorias.dart';
import 'package:quickalert/quickalert.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Importa Firebase Auth
import 'package:gastosdecimouno/Pages/Registro.dart';
import 'package:gastosdecimouno/Pages/Home.dart'; // Asegúrate de tener tu página Home
import 'package:gastosdecimouno/Pages/Categorias.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController txtUser = TextEditingController();
  TextEditingController txtPassword = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance; // Instancia de Firebase Auth

  // Función para mostrar la alerta de bienvenida
  void showWelcomeAlert(BuildContext context) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      title: '¡Bienvenido!',
      text: 'Gracias por iniciar sesión.',
      confirmBtnText: 'Aceptar',
    );
  }

  // Función para iniciar sesión
  Future<void> _loginUser() async {
    try {
      // Intentamos iniciar sesión con el correo y contraseña proporcionados
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: txtUser.text.trim(),
        password: txtPassword.text.trim(),
      );

      // Si la autenticación es exitosa, mostramos la alerta y redirigimos a la página Home
      showWelcomeAlert(context);

      // Esperamos un momento antes de la redirección para que la alerta se vea
      await Future.delayed(Duration(seconds: 2));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Home(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      // Manejamos posibles errores de autenticación

      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Error',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Iniciar Sesión",
          style: TextStyle(fontSize: 24),
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 40),
              Image.network(
                'https://cdn-icons-png.flaticon.com/512/12538/12538444.png',
                width: 250,
                height: 250,
              ),
              SizedBox(height: 20),
              TextField(
                controller: txtUser,
                decoration: InputDecoration(
                  labelText: 'Correo electrónico',
                  labelStyle: TextStyle(color: Color(0xFF1565C0)),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF00866E)),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: txtPassword,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  labelStyle: TextStyle(color: Color(0xFF1565C0)),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF00866E)),
                  ),
                ),
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _loginUser(); // Llama a la función de iniciar sesión
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Color(0xFF1565C0),
                ),
                child: Text('Iniciar sesión'),
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Registro(),
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  foregroundColor: Color(0xFF1565C0),
                ),
                child: Text('Registrar paciente'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
