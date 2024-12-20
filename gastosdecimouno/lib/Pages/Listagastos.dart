import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Para formatear la fecha
import 'package:gastosdecimouno/Pages/Gastos.dart'; // Importar la página Gastos

class ListaGastos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Gastos'),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.grey[200], // Color de fondo
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('gastos').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            var gastos = snapshot.data!.docs;
            if (gastos.isEmpty) {
              return Center(
                child: Text('No hay gastos registrados'),
              );
            }
            return ListView.builder(
              itemCount: gastos.length,
              itemBuilder: (context, index) {
                var gasto = gastos[index];

                // Obtener el nombre de la categoría y subcategoría
                return FutureBuilder<Map<String, String>>(
                  future: _obtenerCategoriaYSubcategoria(gasto['categoria'], gasto['subcategoria']),
                  builder: (context, futureSnapshot) {
                    if (futureSnapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (futureSnapshot.hasError || futureSnapshot.data == null) {
                      return ListTile(
                        title: Text('Error al cargar datos'),
                      );
                    }

                    var nombres = futureSnapshot.data!;
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0), // Bordes redondeados
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      child: ListTile(
                        leading: Icon(Icons.attach_money, color: Colors.blueAccent), // Color del ícono
                        title: Text('${nombres['categoria']} - ${nombres['subcategoria']}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Monto: \$${gasto['monto']}'),
                            Text('Fecha: ${_formatearFecha(gasto['fecha'])}'),
                            if (gasto['observaciones'] != null && gasto['observaciones'].isNotEmpty)
                              Text('Observaciones: ${gasto['observaciones']}'),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                // Navegar a la página de Gastos para editar
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Gastos(), // Navegar a Gastos
                                  ),
                                );
                              },
                              color: Colors.black,
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                _eliminarGasto(gasto.id); // Eliminar gasto
                              },
                              color: Colors.red,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navegar a la página de Gastos para agregar un nuevo gasto
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Gastos(), // Llama a la página de Gastos
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  /// Función para formatear la fecha del gasto
  String _formatearFecha(Timestamp timestamp) {
    DateTime fecha = timestamp.toDate();
    return DateFormat('dd/MM/yyyy').format(fecha);
  }

  /// Función para eliminar un gasto
  Future<void> _eliminarGasto(String gastoId) async {
    await FirebaseFirestore.instance.collection('gastos').doc(gastoId).delete();
    print("Gasto eliminado");
  }

  /// Función para obtener el nombre de la categoría y subcategoría
  Future<Map<String, String>> _obtenerCategoriaYSubcategoria(String categoriaId, String subcategoriaId) async {
    DocumentSnapshot categoriaSnapshot = await FirebaseFirestore.instance.collection('categorias').doc(categoriaId).get();
    DocumentSnapshot subcategoriaSnapshot = await FirebaseFirestore.instance.collection('subcategorias').doc(subcategoriaId).get();

    String categoriaNombre = categoriaSnapshot.exists ? categoriaSnapshot['nombre'] : 'Categoría no encontrada';
    String subcategoriaNombre = subcategoriaSnapshot.exists ? subcategoriaSnapshot['nombre'] : '';

    return {
      'categoria': categoriaNombre,
      'subcategoria': subcategoriaNombre,
    };
  }
}
