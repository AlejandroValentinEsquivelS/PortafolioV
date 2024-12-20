import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'Subcategoria.dart'; // Importar la nueva página de Subcategorías

class Categorias extends StatefulWidget {
  const Categorias({super.key});

  @override
  State<Categorias> createState() => _CategoriasState();
}

class _CategoriasState extends State<Categorias> {
  final _nombreController = TextEditingController();

  ///Función para agregar una nueva Categoría desde la App
  Future<void> agregarCategoria(String nombre) async {
    CollectionReference categorias = FirebaseFirestore.instance.collection('categorias');

    return categorias
        .add({'nombre': nombre})
        .then((value) => print("Categoría agregada"))
        .catchError((error) => print("Error al agregar categoría: $error"));
  }

  void _Alerta_exito() {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      text: 'Registro éxitoso!',
      autoCloseDuration: Duration(seconds: 2), // Duración de la alerta
    );
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pop(context);
    });
  }

  void _Alerta_error() {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      title: "Error",
      text: "El nombre de la categoría no puede estar vacío",
      confirmBtnText: "OK",
      autoCloseDuration: Duration(seconds: 2), // Duración de la alerta
    );
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pop(context);
    });
  }

  /// Navegar a la página de Subcategorías


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categorías'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.network(
              'https://cdn-icons-png.flaticon.com/512/6724/6724239.png',
              width: 220,
              height: 220,
            ),
            const SizedBox(height: 5),
            TextField(
              controller: _nombreController,
              decoration: InputDecoration(labelText: 'Nombre'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                if (_nombreController.text.isNotEmpty) {
                  await agregarCategoria(_nombreController.text);
                  _nombreController.clear();
                  _Alerta_exito();
                } else {
                  _Alerta_error();
                }
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.black,
              ),
              child: Text('Agregar Categoría'),
            ),
            SizedBox(height: 20),

          ],
        ),
      ),
    );
  }
}
