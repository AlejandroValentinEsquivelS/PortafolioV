import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gastosdecimouno/Pages/Categorias.dart';
import 'package:gastosdecimouno/Pages/EditarCategoria.dart';

class ListaCategorias extends StatefulWidget {
  const ListaCategorias({Key? key}) : super(key: key);

  @override
  State<ListaCategorias> createState() => _ListacategoriasState();
}

class _ListacategoriasState extends State<ListaCategorias> {
  // Mapa para manejar la expansión de cada categoría
  final Map<String, bool> _isExpanded = {};

  // Controlador para el nombre de la nueva subcategoría
  final _nombreSubcategoriaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Categorías'),
      ),
      body: Center(
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
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.business),
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
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                _confirmDelete(doc.id);
                              },
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
                                return ListTile(
                                  title: Text(subcategoria['nombre']),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () {
                                      eliminarSubcategoria(doc.id, subcategoria.id);
                                    },
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
      floatingActionButton: FloatingActionButton(
        tooltip: 'Agregar Categoría',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Categorias(),
            ),
          );
        },
        child: const Icon(Icons.add),
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
}
