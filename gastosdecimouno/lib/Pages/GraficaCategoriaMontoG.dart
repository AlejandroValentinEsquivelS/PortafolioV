import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class GraficaPastelCategoria extends StatefulWidget {
  @override
  _GraficaPastelCategoriaState createState() => _GraficaPastelCategoriaState();
}

class _GraficaPastelCategoriaState extends State<GraficaPastelCategoria> {
  DateTime fechaInicial = DateTime.now().subtract(Duration(days: 30));
  DateTime fechaFinal = DateTime.now();

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(start: fechaInicial, end: fechaFinal),
    );

    if (picked != null) {
      setState(() {
        fechaInicial = picked.start;
        fechaFinal = picked.end;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gasto por Categoría'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center( // Centro el botón aquí
              child: ElevatedButton(
                onPressed: () => _selectDateRange(context),
                child: const Text('Seleccionar Rango de Fechas'),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('gastos')
                  .where('fecha', isGreaterThanOrEqualTo: fechaInicial)
                  .where('fecha', isLessThanOrEqualTo: fechaFinal)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

                final gastos = snapshot.data!.docs;
                Map<String, double> categoriaGastos = {};
                for (var gasto in gastos) {
                  String categoria = gasto['categoria'];
                  double monto = gasto['monto'];
                  categoriaGastos[categoria] = (categoriaGastos[categoria] ?? 0) + monto;
                }

                List<PieChartData> chartData = categoriaGastos.entries.map((entry) {
                  return PieChartData(entry.key, entry.value);
                }).toList();

                return SfCircularChart(
                  title: ChartTitle(text: 'Gasto por Categoría'),
                  series: <CircularSeries>[
                    PieSeries<PieChartData, String>(
                      dataSource: chartData,
                      xValueMapper: (PieChartData data, _) => data.categoria,
                      yValueMapper: (PieChartData data, _) => data.monto,
                      dataLabelSettings: DataLabelSettings(isVisible: true),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class PieChartData {
  PieChartData(this.categoria, this.monto);

  final String categoria;
  final double monto;
}
