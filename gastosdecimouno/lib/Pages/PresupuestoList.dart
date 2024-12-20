import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class PresupuestoList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Presupuestos y Gastos'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('categorias').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final categorias = snapshot.data!.docs;

          return ListView.builder(
            itemCount: categorias.length,
            itemBuilder: (context, index) {
              final categoriaData = categorias[index];
              final categoriaId = categoriaData.id;
              final categoriaNombre = categoriaData['nombre'];

              return StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('presupuestos')
                    .where('categoria', isEqualTo: categoriaId)
                    .snapshots(),
                builder: (context, presupuestoSnapshot) {
                  if (presupuestoSnapshot.connectionState == ConnectionState.waiting) {
                    return Container(); // O puedes mostrar un indicador de carga aquí
                  }

                  final presupuestos = presupuestoSnapshot.data!.docs;
                  double totalPresupuestos = presupuestos.fold(0, (sum, doc) => sum + (doc['monto'] ?? 0));

                  return StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('gastos')
                        .where('categoria', isEqualTo: categoriaId)
                        .snapshots(),
                    builder: (context, gastoSnapshot) {
                      if (gastoSnapshot.connectionState == ConnectionState.waiting) {
                        return Container(); // O puedes mostrar un indicador de carga aquí
                      }

                      final gastos = gastoSnapshot.data!.docs;
                      double totalGastos = gastos.fold(0, (sum, doc) => sum + (doc['monto'] ?? 0));

                      double balance = totalPresupuestos - totalGastos;

                      // Mensaje sobre el balance
                      String mensajeBalance;
                      Color colorMensaje;
                      Color fondoColor;

                      if (balance >= 0) {
                        mensajeBalance = 'Aún se cuenta con presupuesto';
                        colorMensaje = Colors.green;
                        fondoColor = Colors.green.withOpacity(0.1); // Color de fondo verde claro
                      } else {
                        mensajeBalance = 'Se excedió el límite de presupuesto';
                        colorMensaje = Colors.red;
                        fondoColor = Colors.red.withOpacity(0.1); // Color de fondo rojo claro
                      }

                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        decoration: BoxDecoration(
                          color: fondoColor, // Color de fondo según el balance
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3), // Cambia la posición de la sombra
                            ),
                          ],
                        ),
                        child: ExpansionTile(
                          title: Text(categoriaNombre), // Nombre de la categoría
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Balance: \$${balance.toStringAsFixed(2)}'), // Mostrar el balance
                              Text(
                                mensajeBalance,
                                style: TextStyle(color: colorMensaje),
                              ),
                            ],
                          ),
                          children: [
                            // StreamBuilder para presupuestos
                            StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('presupuestos')
                                  .where('categoria', isEqualTo: categoriaId)
                                  .snapshots(),
                              builder: (context, presupuestoSnapshot) {
                                if (presupuestoSnapshot.connectionState == ConnectionState.waiting) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('Cargando presupuestos...'),
                                  );
                                }

                                final presupuestos = presupuestoSnapshot.data!.docs;

                                if (presupuestos.isEmpty) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('No hay presupuestos para esta categoría.'),
                                  );
                                }

                                return Column(
                                  children: presupuestos.map((presupuestoData) {
                                    // Formateo de las fechas
                                    DateTime fechaInicial = (presupuestoData['fechaInicial'] as Timestamp).toDate();
                                    DateTime fechaFinal = (presupuestoData['fechaFinal'] as Timestamp).toDate();

                                    String fechaInicialFormateada = DateFormat('d \'de\' MMMM \'del\' y').format(fechaInicial);
                                    String fechaFinalFormateada = DateFormat('d \'de\' MMMM \'del\' y').format(fechaFinal);

                                    return Container(
                                      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 2,
                                            blurRadius: 5,
                                            offset: Offset(0, 3), // Cambia la posición de la sombra
                                          ),
                                        ],
                                      ),
                                      child: ListTile(
                                        title: Text('Presupuesto: \$${presupuestoData['monto']}'), // Mostrar el monto del presupuesto
                                        subtitle: Text(
                                            'Fecha Inicial: $fechaInicialFormateada\nFecha Final: $fechaFinalFormateada'), // Mostrar fechas
                                        trailing: IconButton(
                                          icon: Icon(Icons.delete, color: Colors.red),
                                          onPressed: () {
                                            _eliminarPresupuesto(presupuestoData.id);
                                          },
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                );
                              },
                            ),

                            // StreamBuilder para gastos
                            StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('gastos')
                                  .where('categoria', isEqualTo: categoriaId)
                                  .snapshots(),
                              builder: (context, gastoSnapshot) {
                                if (gastoSnapshot.connectionState == ConnectionState.waiting) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('Cargando gastos...'),
                                  );
                                }

                                final gastos = gastoSnapshot.data!.docs;

                                if (gastos.isEmpty) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('No hay gastos para esta categoría.'),
                                  );
                                }

                                return Column(
                                  children: gastos.map((gastoData) {
                                    // Formateo de la fecha del gasto
                                    DateTime fechaGasto = (gastoData['fecha'] as Timestamp).toDate();
                                    String fechaGastoFormateada = DateFormat('d \'de\' MMMM \'del\' y').format(fechaGasto);

                                    return Container(
                                      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 2,
                                            blurRadius: 5,
                                            offset: Offset(0, 3), // Cambia la posición de la sombra
                                          ),
                                        ],
                                      ),
                                      child: ListTile(
                                        title: Text('Gasto: \$${gastoData['monto']}'), // Mostrar el monto del gasto
                                        subtitle: Text('Fecha: $fechaGastoFormateada'), // Mostrar la fecha del gasto
                                        trailing: IconButton(
                                          icon: Icon(Icons.delete, color: Colors.red),
                                          onPressed: () {
                                            _eliminarGasto(gastoData.id);
                                          },
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _eliminarPresupuesto(String presupuestoId) async {
    try {
      await FirebaseFirestore.instance.collection('presupuestos').doc(presupuestoId).delete();
      print('Presupuesto eliminado con éxito.');
    } catch (e) {
      print('Error al eliminar el presupuesto: $e');
    }
  }

  Future<void> _eliminarGasto(String gastoId) async {
    try {
      await FirebaseFirestore.instance.collection('gastos').doc(gastoId).delete();
      print('Gasto eliminado con éxito.');
    } catch (e) {
      print('Error al eliminar el gasto: $e');
    }
  }
}
