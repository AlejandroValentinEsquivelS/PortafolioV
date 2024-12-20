import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class GraficaSubMontoGastado extends StatefulWidget {
  @override
  _GraficaSubMontoGastadoState createState() => _GraficaSubMontoGastadoState();
}

class _GraficaSubMontoGastadoState extends State<GraficaSubMontoGastado> {
  DateTime? _startDate;
  DateTime? _endDate;
  List<ChartData> _chartData = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    QuerySnapshot gastosSnapshot = await FirebaseFirestore.instance
        .collection('gastos')
        .where('fecha', isGreaterThanOrEqualTo: _startDate ?? DateTime.now().subtract(Duration(days: 30)))
        .where('fecha', isLessThanOrEqualTo: _endDate ?? DateTime.now())
        .get();

    Map<String, double> categoriaGastos = {};
    List<String> categoriaIds = [];

    for (var doc in gastosSnapshot.docs) {
      String categoriaId = doc['categoria']; // ID de la categoría
      double monto = doc['monto'];

      categoriaIds.add(categoriaId); // Almacena los IDs para la consulta posterior

      // Suma los montos por ID de categoría
      if (categoriaGastos.containsKey(categoriaId)) {
        categoriaGastos[categoriaId] = categoriaGastos[categoriaId]! + monto;
      } else {
        categoriaGastos[categoriaId] = monto;
      }
    }

    // Ahora consulta los nombres de las categorías usando los IDs
    Map<String, String> categoriasNombres = {};
    if (categoriaIds.isNotEmpty) {
      QuerySnapshot categoriasSnapshot = await FirebaseFirestore.instance
          .collection('categorias')
          .where(FieldPath.documentId, whereIn: categoriaIds)
          .get();

      for (var categoriaDoc in categoriasSnapshot.docs) {
        categoriasNombres[categoriaDoc.id] = categoriaDoc['nombre']; // Asumiendo que el campo que contiene el nombre es 'nombre'
      }
    }

    setState(() {
      _chartData = categoriaGastos.entries
          .map((entry) => ChartData(categoriasNombres[entry.key] ?? 'Desconocido', entry.value))
          .toList();
    });
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
      _fetchData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gastos por Categoria'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => _selectDateRange(context),
              child: const Text('Seleccionar Rango de Fechas'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SfCartesianChart(
                title: ChartTitle(text: 'Gastos por Categoria'),
                primaryXAxis: CategoryAxis(),
                primaryYAxis: NumericAxis(),
                series: <CartesianSeries>[
                  ColumnSeries<ChartData, String>(
                    dataSource: _chartData,
                    xValueMapper: (ChartData data, _) => data.categoria,
                    yValueMapper: (ChartData data, _) => data.monto,
                    color: Colors.teal,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChartData {
  ChartData(this.categoria, this.monto);
  final String categoria;
  final double monto;
}
