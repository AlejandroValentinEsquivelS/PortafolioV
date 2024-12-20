import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gastosdecimouno/Pages/EditarCategoria.dart';

class ListaCategorias2 extends StatefulWidget {
  const ListaCategorias2({Key? key}) : super(key: key);

  @override
  State<ListaCategorias2> createState() => _ListaCategorias2State();
}

class _ListaCategorias2State extends State<ListaCategorias2> {
  final Map<String, bool> _isExpanded = {};
  final _nombreSubcategoriaController = TextEditingController();
  final _nombreCategoriaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categorías'),
        backgroundColor: Colors.teal, // Color del AppBar
      ),
      body: Container(
        color: Colors.grey[200], // Color de fondo
        child: Center(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('categorias').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              List<DocumentSnapshot> docs = snapshot.data!.docs;
              return ListView.builder(
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot doc = docs[index];
                  bool isExpanded = _isExpanded[doc.id] ?? false;

                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0), // Bordes redondeados
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    color: Colors.white, // Color de la tarjeta
                    elevation: 5,
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.business, color: Colors.teal),
                          title: Text(doc["nombre"]),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditarCategoria(
                                        docId: doc.id,
                                        nombreInicial: doc["nombre"],
                                      ),
                                    ),
                                  );
                                },
                                color: Colors.teal,
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  _confirmDelete(doc.id);
                                },
                                color: Colors.red,
                              ),
                              IconButton(
                                icon: isExpanded
                                    ? const Icon(Icons.arrow_drop_up)
                                    : const Icon(Icons.arrow_drop_down),
                                onPressed: () {
                                  setState(() {
                                    _isExpanded[doc.id] = !isExpanded;
                                  });
                                },
                                color: Colors.teal,
                              ),
                            ],
                          ),
                        ),
                        if (isExpanded) ...[
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: TextField(
                              controller: _nombreSubcategoriaController,
                              decoration: const InputDecoration(labelText: 'Nueva Subcategoría'),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              if (_nombreSubcategoriaController.text.isNotEmpty) {
                                await agregarSubcategoria(doc.id, _nombreSubcategoriaController.text);
                                _nombreSubcategoriaController.clear();
                              }
                            },
                            child: const Text('Agregar Subcategoría'),
                          ),
                          const SizedBox(height: 10),
                          StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('categorias')
                                .doc(doc.id)
                                .collection('subcategorias')
                                .snapshots(),
                            builder: (context, subSnap) {
                              if (!subSnap.hasData) {
                                return const Center(child: CircularProgressIndicator());
                              }
                              var subcategorias = subSnap.data!.docs;
                              return ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: subcategorias.length,
                                itemBuilder: (context, subIndex) {
                                  var subcategoria = subcategorias[subIndex];
                                  return Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0), // Bordes redondeados
                                    ),
                                    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                                    color: Colors.teal[50], // Color de la subcategoría
                                    child: ListTile(
                                      title: Text(subcategoria['nombre']),
                                      trailing: IconButton(
                                        icon: const Icon(Icons.delete),
                                        onPressed: () {
                                          eliminarSubcategoria(doc.id, subcategoria.id);
                                        },
                                        color: Colors.red,
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Agregar Categoría',
        onPressed: () {
          _mostrarDialogoAgregarCategoria();
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.teal, // Color del botón flotante
      ),
    );
  }

  Future<void> agregarSubcategoria(String categoriaId, String nombre) async {
    CollectionReference subcategorias = FirebaseFirestore.instance
        .collection('categorias')
        .doc(categoriaId)
        .collection('subcategorias');

    return subcategorias
        .add({'nombre': nombre})
        .then((value) => print("Subcategoría agregada"))
        .catchError((error) => print("Error al agregar subcategoría: $error"));
  }

  Future<void> eliminarSubcategoria(String categoriaId, String subcategoriaId) async {
    DocumentReference subcategoria = FirebaseFirestore.instance
        .collection('categorias')
        .doc(categoriaId)
        .collection('subcategorias')
        .doc(subcategoriaId);

    return subcategoria
        .delete()
        .then((value) => print("Subcategoría eliminada"))
        .catchError((error) => print("Error al eliminar subcategoría: $error"));
  }

  void _confirmDelete(String docId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Eliminar categoría'),
          content: const Text('¿Estás seguro de que deseas eliminar esta categoría?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                await FirebaseFirestore.instance.collection('categorias').doc(docId).delete();
                Navigator.of(context).pop(); // Cierra el diálogo
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Categoría eliminada'), backgroundColor: Colors.black),
                );
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  void _mostrarDialogoAgregarCategoria() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Agregar Categoría'),
          content: TextField(
            controller: _nombreCategoriaController,
            decoration: const InputDecoration(labelText: 'Nombre de la categoría'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                if (_nombreCategoriaController.text.isNotEmpty) {
                  await FirebaseFirestore.instance.collection('categorias').add({
                    'nombre': _nombreCategoriaController.text,
                  });
                  _nombreCategoriaController.clear();
                  Navigator.of(context).pop(); // Cierra el diálogo
                }
              },
              child: const Text('Agregar'),
            ),
          ],
        );
      },
    );
  }
}
