import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quickalert/quickalert.dart';
import 'package:gastosdecimouno/Pages/ListaCategorias.dart';

class EditarCategoria extends StatefulWidget {
  final String docId;
  final String nombreInicial;

  const EditarCategoria({super.key, required this.docId, required this.nombreInicial});

  @override
  _EditarCategoriaState createState() => _EditarCategoriaState();
}

class _EditarCategoriaState extends State<EditarCategoria> {
  final TextEditingController _nombreController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nombreController.text = widget.nombreInicial;  // Inicializar con el nombre actual
  }

  void _EditarCategoria() {
    // Función para actualizar la categoría
    FirebaseFirestore.instance.collection('categorias').doc(widget.docId).update({
      'nombre': _nombreController.text,
    }).then((_) {
      Navigator.pop(context);// Regresa otra vista atrás // Volver a la pantalla anterior
    });
  }

  void _EliminarCategoria() {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.confirm,
      text: '¿Estás seguro de querer borrar este registro?',
      confirmBtnText: 'Sí',
      cancelBtnText: 'No',
      confirmBtnColor: Colors.green,
      onConfirmBtnTap: () {
        // Proceder a borrar el registro si el usuario confirma
        // Función para eliminar la categoría
        FirebaseFirestore.instance.collection('categorias').doc(widget.docId).delete().then((_) {
          Navigator.pop(context); // Regresa una vista atrás
          Navigator.pop(context); // Regresa otra vista atrás
        });
        // Regresar a la lista de categorías
      },
      onCancelBtnTap: () {
        Navigator.of(context).pop(); // Solo cerrar la alerta si cancela
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Categoría'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              _EliminarCategoria();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nombreController,
              decoration: InputDecoration(labelText: 'Nombre de la categoría'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _EditarCategoria();
              },
              child: Text('Guardar Cambios'),
            ),
          ],
        ),
      ),
    );
  }
}
