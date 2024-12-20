import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gastosdecimouno/Pages/GraficaCategoriaMontoG.dart';
import 'package:gastosdecimouno/Pages/GraficaSubMonGastado.dart';
import 'package:gastosdecimouno/Pages/ListaCategorias.dart';
import 'package:gastosdecimouno/Pages/ListaCategorias2.dart';
import 'package:gastosdecimouno/Pages/Listagastos.dart';
import 'package:gastosdecimouno/Pages/Presupuesto.dart';
import 'package:gastosdecimouno/Pages/PresupuestoList.dart';
import 'Categorias.dart';
import 'Subcategoria.dart';
import 'Gastos.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Página de Inicio'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menú de Navegación',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            // Item para Categorías
            ListTile(
              leading: Icon(Icons.category),
              title: Text('Categorías'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>ListaCategorias2()),
                );
              },
            ),

            ListTile(
              leading: Icon(Icons.attach_money),
              title: Text('Gastos'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ListaGastos()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.attach_money),
              title: Text('Presupuestos'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Presupuesto()),
                );
              },
            ),

            ListTile(
              leading: Icon(Icons.attach_money),
              title: Text('Listar Presupuestos'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PresupuestoList()), // Asegúrate de usar PresupuestosPage
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.bar_chart),
              title: Text('Grafica Barras categoria monto'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GraficaSubMontoGastado()), // Asegúrate de usar PresupuestosPage
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.pie_chart),
              title: Text('Grafica Pastel categoria Monto'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GraficaPastelCategoria()), // Asegúrate de usar PresupuestosPage
                );
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Text('¡Bienvenido a la página principal!'),
      ),
    );
  }
}

// Clase para listar categorías con nombre en lugar de ID
class ListaCategorias extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Categorías'),
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
              return ListTile(
                title: Text(categorias[index]['nombre']), // Mostrar el nombre de la categoría
              );
            },
          );
        },
      ),
    );
  }
}

