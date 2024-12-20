import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Gastos extends StatefulWidget {
  @override
  State<Gastos> createState() => _GastosState();
}

class _GastosState extends State<Gastos> {
  String? categoriaSeleccionada;
  String? subcategoriaSeleccionada;
  double monto = 0.0;
  double presupuestoDisponible = 0.0;
  DateTime fechaGasto = DateTime.now();
  final _observacionesController = TextEditingController();

  /// Obtener las categorías desde Firebase
  Stream<QuerySnapshot> obtenerCategorias() {
    return FirebaseFirestore.instance.collection('categorias').snapshots();
  }

  /// Obtener las subcategorías según la categoría seleccionada
  Stream<QuerySnapshot> obtenerSubcategorias(String categoriaId) {
    return FirebaseFirestore.instance
        .collection('categorias')
        .doc(categoriaId)
        .collection('subcategorias')
        .snapshots();
  }

  /// Obtener el presupuesto disponible para la categoría seleccionada
  Future<void> obtenerPresupuestoDisponible() async {
    double totalPresupuesto = 0.0;
    double totalGastado = 0.0;

    if (categoriaSeleccionada != null) {
      // Obtener el presupuesto para la categoría seleccionada
      QuerySnapshot presupuestoSnapshot = await FirebaseFirestore.instance
          .collection('presupuestos')
          .where('categoria', isEqualTo: categoriaSeleccionada)
          .get();

      if (presupuestoSnapshot.docs.isNotEmpty) {
        var presupuesto = presupuestoSnapshot.docs.first;
        totalPresupuesto = presupuesto['monto'];
      }

      // Obtener los gastos de la categoría seleccionada
      QuerySnapshot gastosSnapshot = await FirebaseFirestore.instance
          .collection('gastos')
          .where('categoria', isEqualTo: categoriaSeleccionada)
          .get();

      if (gastosSnapshot.docs.isNotEmpty) {
        for (var gasto in gastosSnapshot.docs) {
          totalGastado += gasto['monto'];
        }
      }

      // Calcular el monto disponible
      setState(() {
        presupuestoDisponible = totalPresupuesto - totalGastado;
      });
    }
  }

  /// Función para agregar el gasto a Firebase
  Future<void> agregarGasto() async {
    // Continuar con el registro del gasto aunque se haya excedido el presupuesto
    if (monto > presupuestoDisponible) {
      // Mostrar alerta de que el presupuesto fue excedido
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Advertencia: Has excedido el presupuesto')),
      );
    }

    CollectionReference gastos = FirebaseFirestore.instance.collection('gastos');

    return gastos
        .add({
      'categoria': categoriaSeleccionada,
      'subcategoria': subcategoriaSeleccionada,
      'monto': monto,
      'fecha': fechaGasto,
      'observaciones': _observacionesController.text,
    })
        .then((value) => print("Gasto agregado"))
        .catchError((error) => print("Error al agregar gasto: $error"));
  }

  /// Mostrar el selector de fecha
  Future<void> _seleccionarFecha(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: fechaGasto,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != fechaGasto) {
      setState(() {
        fechaGasto = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registrar Gasto'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            /// Dropdown para seleccionar la categoría
            StreamBuilder<QuerySnapshot>(
              stream: obtenerCategorias(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();
                var categorias = snapshot.data!.docs;

                return DropdownButtonFormField<String>(
                  value: categoriaSeleccionada,
                  hint: Text('Selecciona una categoría'),
                  items: categorias.map((categoria) {
                    return DropdownMenuItem<String>(
                      value: categoria.id,
                      child: Text(categoria['nombre']),
                    );
                  }).toList(),
                  onChanged: (nuevaCategoria) {
                    setState(() {
                      categoriaSeleccionada = nuevaCategoria;
                      subcategoriaSeleccionada = null; // Resetear subcategoría al cambiar de categoría
                    });
                    obtenerPresupuestoDisponible(); // Obtener el presupuesto al cambiar de categoría
                  },
                );
              },
            ),
            SizedBox(height: 20),

            /// Mostrar el presupuesto disponible
            Text(
              'Presupuesto disponible: \$${presupuestoDisponible.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),

            /// Dropdown para seleccionar la subcategoría (dependiente de la categoría seleccionada)
            if (categoriaSeleccionada != null)
              StreamBuilder<QuerySnapshot>(
                stream: obtenerSubcategorias(categoriaSeleccionada!),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return CircularProgressIndicator();
                  var subcategorias = snapshot.data!.docs;

                  return DropdownButtonFormField<String>(
                    value: subcategoriaSeleccionada,
                    hint: Text('Selecciona una subcategoría'),
                    items: subcategorias.map((subcategoria) {
                      return DropdownMenuItem<String>(
                        value: subcategoria.id,
                        child: Text(subcategoria['nombre']),
                      );
                    }).toList(),
                    onChanged: (nuevaSubcategoria) {
                      setState(() {
                        subcategoriaSeleccionada = nuevaSubcategoria;
                      });
                    },
                  );
                },
              ),
            SizedBox(height: 20),

            /// Campo para ingresar el monto
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Monto'),
              onChanged: (value) {
                setState(() {
                  monto = double.tryParse(value) ?? 0.0;
                });
              },
            ),
            SizedBox(height: 20),

            /// Seleccionar la fecha del gasto
            Row(
              children: [
                Text("Fecha del gasto: ${DateFormat('dd/MM/yyyy').format(fechaGasto)}"),
                IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () => _seleccionarFecha(context),
                ),
              ],
            ),
            SizedBox(height: 20),

            /// Campo para ingresar observaciones
            TextField(
              controller: _observacionesController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Observaciones',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),

            /// Botón para agregar el gasto
            ElevatedButton(
              onPressed: () async {
                if (categoriaSeleccionada != null && subcategoriaSeleccionada != null && monto > 0) {
                  await agregarGasto();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Gasto registrado con éxito')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Por favor, completa todos los campos')),
                  );
                }
              },
              child: Text('Agregar Gasto'),
            ),
          ],
        ),
      ),
    );
  }
}
