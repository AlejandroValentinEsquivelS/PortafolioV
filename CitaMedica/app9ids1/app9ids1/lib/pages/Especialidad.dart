
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:quickalert/quickalert.dart';

import '../Utils/Ambiente.dart';

class Especialidad extends StatefulWidget {
  const Especialidad({super.key});

  @override
  State<Especialidad> createState() => _EspecialidadState();
}

class _EspecialidadState extends State<Especialidad> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController txtNom = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Agregar especialidad",
          style: TextStyle(fontSize: 24),
        ),
        backgroundColor: Color(0xFF00866E), // Color de fondo del AppBar
        foregroundColor: Colors.white,
        centerTitle: true, // Para centrar el título
      ),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(40, 0, 40, 40),
              child: Column(
                children: [
                  TextFormField(
                    controller: txtNom,

                    decoration: InputDecoration(labelText: 'Nombre'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Favor de ingresar el nombre';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final response = await http.post(
                    Uri.parse('${Ambiente.urlServer}/api/especialidad/guardar'),
                    body: jsonEncode(<String, dynamic>{
                      'id': 0,
                      'nombre': txtNom.text,
                    }),
                    headers: <String, String>{
                      'Content-Type': 'application/json; charset=UTF-8',
                      'Accept': 'application/json',
                    },
                  );
                  if (response.body == "Ok") {
                    Navigator.pop(context);
                  } else {
                    QuickAlert.show(
                      context: context,
                      type: QuickAlertType.error,
                      title: 'Oops..',
                      text: "Error",
                    );
                  }
                }
              },
              style: TextButton.styleFrom(
                backgroundColor:  Color(0xFF00866E),// Color de fondo del botón
                foregroundColor: Colors.white, // Color del texto del botón
              ),
              child: Text('Aceptar'),
            ),
          ],
        ),
      ),
    );
  }
}
