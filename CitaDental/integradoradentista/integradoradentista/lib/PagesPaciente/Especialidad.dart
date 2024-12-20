import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quickalert/quickalert.dart';

class Especialidad extends StatefulWidget {
  const Especialidad({super.key});

  @override
  State<Especialidad> createState() => _EspecialidadState();
}

class _EspecialidadState extends State<Especialidad> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController txtNom = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Agregar especialidad",
          style: TextStyle(fontSize: 24),
        ),
        backgroundColor: Color(0xFF00866E),
        foregroundColor: Colors.white,
        centerTitle: true,
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
                  try {
                    // Guardar en Firestore
                    await FirebaseFirestore.instance.collection('especialidades').add({
                      'nombre': txtNom.text,
                    });

                    Navigator.pop(context);
                  } catch (e) {
                    QuickAlert.show(
                      context: context,
                      type: QuickAlertType.error,
                      title: 'Oops..',
                      text: "Error: ${e.toString()}",
                    );
                  }
                }
              },
              style: TextButton.styleFrom(
                backgroundColor: Color(0xFF00866E),
                foregroundColor: Colors.white,
              ),
              child: Text('Aceptar'),
            ),
          ],
        ),
      ),
    );
  }
}
