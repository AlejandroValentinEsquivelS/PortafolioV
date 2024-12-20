import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Presupuesto extends StatefulWidget {
  @override
  _PresupuestoState createState() => _PresupuestoState();
}

class _PresupuestoState extends State<Presupuesto> {
  String? categoriaSeleccionada;
  double monto = 0.0;
  DateTime fechaInicial = DateTime.now();
  DateTime fechaFinal = DateTime.now().add(Duration(days: 30));
  final _montoController = TextEditingController();

  /// Obtener las categorías desde Firebase
  Stream<QuerySnapshot> obtenerCategorias() {
    return FirebaseFirestore.instance.collection('categorias').snapshots();
  }

  /// Función para agregar presupuesto a Firebase
  Future<void> agregarPresupuesto() async {
    CollectionReference presupuestos = FirebaseFirestore.instance.collection('presupuestos');

    return presupuestos.add({
      'categoria': categoriaSeleccionada,
      'monto': monto,
      'fechaInicial': fechaInicial,
      'fechaFinal': fechaFinal,
    }).then((value) => print("Presupuesto agregado"))
        .catchError((error) => print("Error al agregar presupuesto: $error"));
  }

  /// Mostrar el selector de fecha
  Future<void> _seleccionarFechaInicial(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: fechaInicial,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != fechaInicial) {
      setState(() {
        fechaInicial = picked;
      });
    }
  }

  Future<void> _seleccionarFechaFinal(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: fechaFinal,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != fechaFinal) {
      setState(() {
        fechaFinal = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Presupuesto'),
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
                    });
                  },
                );
              },
            ),
            SizedBox(height: 20),

            /// Campo para ingresar el monto del presupuesto
            TextField(
              controller: _montoController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Monto del presupuesto'),
              onChanged: (value) {
                setState(() {
                  monto = double.tryParse(value) ?? 0.0;
                });
              },
            ),
            SizedBox(height: 20),

            /// Seleccionar la fecha inicial del presupuesto
            Row(
              children: [
                Text("Fecha inicial: ${DateFormat('dd/MM/yyyy').format(fechaInicial)}"),
                IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () => _seleccionarFechaInicial(context),
                ),
              ],
            ),
            SizedBox(height: 20),

            /// Seleccionar la fecha final del presupuesto
            Row(
              children: [
                Text("Fecha final: ${DateFormat('dd/MM/yyyy').format(fechaFinal)}"),
                IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () => _seleccionarFechaFinal(context),
                ),
              ],
            ),
            SizedBox(height: 20),

            /// Botón para agregar el presupuesto
            ElevatedButton(
              onPressed: () async {
                if (categoriaSeleccionada != null && monto > 0) {
                  await agregarPresupuesto();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Presupuesto registrado con éxito')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Por favor, completa todos los campos')),
                  );
                }
              },
              child: Text('Agregar Presupuesto'),
            ),
          ],
        ),
      ),
    );
  }
}
