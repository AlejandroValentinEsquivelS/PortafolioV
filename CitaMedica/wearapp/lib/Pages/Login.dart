import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:http/http.dart' as http;
import 'package:wearapp/Pages/Home.dart';
import '../Models/LoginResponse.dart';
import '../Utils/Ambiente.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController txtUser = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  bool isLoading = false;

  Future<void> _login() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('${Ambiente.urlServer}/api/login'),
        body: jsonEncode(<String, dynamic>{
          'email': txtUser.text,
          'password': txtPassword.text,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseJson = jsonDecode(response.body);
        final loginResponse = Loginresponse.fromJson(responseJson);

        if (loginResponse.acceso == "Ok") {
          Navigator.push(
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
          title: 'Oops..',
          text: 'Error de servidor: ${response.statusCode}',
        );
      }
    } catch (error) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Oops..',
        text: 'Error: $error',
      );
    } finally {
      setState(() {
        isLoading = false;
      });
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
              const SizedBox(height: 10),
              Image.network(
                'https://cdn-icons-png.flaticon.com/512/3985/3985429.png',
                width: 50,
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: TextField(
                  controller: txtUser,
                  decoration: const InputDecoration(
                    labelText: 'Usuario',
                    labelStyle: TextStyle(color: Color(0xFF00866E)),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF00866E)),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: TextField(
                  controller: txtPassword,
                  decoration: const InputDecoration(
                    labelText: 'Contraseña',
                    labelStyle: TextStyle(color: Color(0xFF00866E)),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF00866E)),
                    ),
                  ),
                  obscureText: true,
                ),
              ),
              isLoading
                  ? const CircularProgressIndicator()
                  : TextButton(
                onPressed: _login,
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFF00866E),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Aceptar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
