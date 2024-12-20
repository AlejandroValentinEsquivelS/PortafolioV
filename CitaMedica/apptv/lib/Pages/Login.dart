import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:http/http.dart' as http;
import 'package:apptv/Pages/Home.dart';
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

  final FocusNode userFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode buttonFocusNode = FocusNode();

  @override
  void dispose() {
    txtUser.dispose();
    txtPassword.dispose();
    userFocusNode.dispose();
    passwordFocusNode.dispose();
    buttonFocusNode.dispose();
    super.dispose();
  }

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
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Image.network(
                'https://cdn-icons-png.flaticon.com/512/3985/3985429.png',
                width: 120, // Tamaño adecuado para mejor visibilidad en TV
                height: 120,
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: Focus(
                  focusNode: userFocusNode,
                  child: TextField(
                    controller: txtUser,
                    decoration: InputDecoration(
                      labelText: 'Usuario',
                      labelStyle: TextStyle(color: Color(0xFF00866E)),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF00866E)),
                      ),
                      prefixIcon: Icon(Icons.person, color: Color(0xFF00866E)),
                    ),
                    onEditingComplete: () => FocusScope.of(context).requestFocus(passwordFocusNode),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: Focus(
                  focusNode: passwordFocusNode,
                  child: TextField(
                    controller: txtPassword,
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      labelStyle: TextStyle(color: Color(0xFF00866E)),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF00866E)),
                      ),
                      prefixIcon: Icon(Icons.lock, color: Color(0xFF00866E)),
                    ),
                    obscureText: true,
                    onEditingComplete: () => FocusScope.of(context).requestFocus(buttonFocusNode),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              isLoading
                  ? const CircularProgressIndicator()
                  : Focus(
                focusNode: buttonFocusNode,
                child: ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Color(0xFF00866E), // Color del texto
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                  child: const Text('Aceptar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
