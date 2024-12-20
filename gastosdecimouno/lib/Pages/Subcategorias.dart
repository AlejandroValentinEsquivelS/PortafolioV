import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Subcategorias extends StatefulWidget {
  final String categoriaId;
  final String categoriaNombre;

  const Subcategorias({
    Key? key,
    required this.categoriaId,
    required this.categoriaNombre,
  }) : super(key: key);

  @override
  State<Subcategorias> createState() => _SubcategoriasState();
}

class _SubcategoriasState extends State<Subcategorias> {
  final _nombreSubcategoriaController = TextEditingController();

  /// Función para agregar una subcategoría
  Future<void> agregarSubcategoria(String nombre) async {
    CollectionReference subcategorias = FirebaseFirestore.instance
        .collection('categorias')
        .doc(widget.categoriaId)
        .collection('subcategorias');

    return subcategorias
        .add({'nombre': nombre})
        .then((value) => print("Subcategoría agregada"))
        .catchError((error) => print("Error al agregar subcategoría: $error"));
  }

  /// Función para eliminar una subcategoría
  Future<void> eliminarSubcategoria(String subcategoriaId) async {
    DocumentReference subcategoria = FirebaseFirestore.instance
        .collection('categorias')
        .doc(widget.categoriaId)
        .collection('subcategorias')
        .doc(subcategoriaId);

    return subcategoria
        .delete()
        .then((value) => print("Subcategoría eliminada"))
        .catchError((error) => print("Error al eliminar subcategoría: $error"));
  }

  /// Función para editar una subcategoría
  Future<void> editarSubcategoria(String subcategoriaId, String nuevoNombre) async {
    DocumentReference subcategoria = FirebaseFirestore.instance
        .collection('categorias')
        .doc(widget.categoriaId)
        .collection('subcategorias')
        .doc(subcategoriaId);

    return subcategoria
        .update({'nombre': nuevoNombre})
        .then((value) => print("Subcategoría editada"))
        .catchError((error) => print("Error al editar subcategoría: $error"));
  }

  /// Mostrar diálogo para editar la subcategoría
  Future<void> mostrarDialogoEditar(String subcategoriaId, String nombreActual) async {
    TextEditingController _nombreController = TextEditingController(text: nombreActual);
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar Subcategoría'),
          content: TextField(
            controller: _nombreController,
            decoration: InputDecoration(labelText: 'Nombre de la subcategoría'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Guardar'),
              onPressed: () async {
                if (_nombreController.text.isNotEmpty) {
                  await editarSubcategoria(subcategoriaId, _nombreController.text);
                  Navigator.of(context).pop();
                } else {
                  // Mostrar alerta si el campo está vacío
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('El nombre no puede estar vacío')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Subcategorías de ${widget.categoriaNombre}'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nombreSubcategoriaController,
              decoration: InputDecoration(labelText: 'Nombre de la subcategoría'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_nombreSubcategoriaController.text.isNotEmpty) {
                  await agregarSubcategoria(_nombreSubcategoriaController.text);
                  _nombreSubcategoriaController.clear();
                }
              },
              child: Text('Agregar Subcategoría'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('categorias')
                    .doc(widget.categoriaId)
                    .collection('subcategorias')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  var subcategorias = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: subcategorias.length,
                    itemBuilder: (context, index) {
                      var subcategoria = subcategorias[index];
                      return ListTile(
                        title: Text(subcategoria['nombre']),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                mostrarDialogoEditar(subcategoria.id, subcategoria['nombre']);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                eliminarSubcategoria(subcategoria.id);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

