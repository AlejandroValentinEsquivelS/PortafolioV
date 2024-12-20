import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:integradoradentista/PagesPaciente/Especialidad.dart';
import 'package:integradoradentista/Models/EspecialidadResponse.dart';

class Especialidades extends StatefulWidget {
  const Especialidades({super.key});

  @override
  State<Especialidades> createState() => _EspecialidadesState();
}

class _EspecialidadesState extends State<Especialidades> {
  List<Especialidadresponse> especialidades = [];

  Widget _listViewEspecialidades() {
    return ListView.builder(
      itemCount: especialidades.length,
      itemBuilder: (context, index) {
        var especialidad = especialidades[index];
        return ListTile(
          title: Text(especialidad.id), // Mostrar ID como texto
          subtitle: Text(especialidad.nombre),
        );
      },
    );
  }

  void fnObtenerEspecialidades() async {
    try {
      var snapshot = await FirebaseFirestore.instance.collection('especialidades').get();
      setState(() {
        especialidades = snapshot.docs.map((doc) {
          return Especialidadresponse.fromJson(doc.data(), doc.id); // Pasar el ID
        }).toList();
      });
    } catch (e) {
      print('Error obteniendo especialidades: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fnObtenerEspecialidades();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Especialidades', style: TextStyle(fontSize: 24)),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'Actualizar Lista') {
                fnObtenerEspecialidades(); // Actualiza la lista al seleccionar
              }
            },
            itemBuilder: (BuildContext context) {
              return {'Actualizar Lista'}.map((String item) {
                return PopupMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList();
            },
          ),
        ],
        backgroundColor: Color(0xFF00866E),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: _listViewEspecialidades(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const Especialidad(),
            ),
          ).then((_) => fnObtenerEspecialidades()); // Actualiza la lista después de volver
        },
        backgroundColor: Color(0xFF00866E),
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
      ),
    );
  }
}
