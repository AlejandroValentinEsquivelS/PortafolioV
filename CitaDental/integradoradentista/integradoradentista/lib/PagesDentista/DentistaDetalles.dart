import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:integradoradentista/PagesDentista/HomeDentista.dart';
import 'package:integradoradentista/PagesDentista/Citas.dart';
import 'package:integradoradentista/Pages/Login.dart';
import 'package:integradoradentista/Models/DentistaResponse2.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:integradoradentista/PagesDentista/VistaCalendario.dart';

class Dentistadetalles extends StatefulWidget {
  final String idUsuario;

  const Dentistadetalles({Key? key, required this.idUsuario}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Dentistadetalles> {
  Dentistaresponse2? dentista;
  String? imageUrl;
  int _selectedIndex = 3;
  final DatabaseReference databaseRef = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    super.initState();
    fnObtenerDentista();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.push(context, MaterialPageRoute(builder: (context) => HomeDentista(idUsuario: widget.idUsuario)));
        break;
      case 1:
        Navigator.push(context, MaterialPageRoute(builder: (context) => Citas(idDentista: widget.idUsuario)));
        break;
      case 2:
        Navigator.push(context, MaterialPageRoute(builder: (context) => VistaHorarios(idUsuario: widget.idUsuario)));
        break;
      case 3:
        Navigator.push(context, MaterialPageRoute(builder: (context) => Dentistadetalles(idUsuario: widget.idUsuario)));
        break;
      case 4:
        FirebaseAuth.instance.signOut().then((_) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
        });
        break;
    }
  }
  // Método para obtener la URL de la imagen desde Firebase Storage
  Future<void> fnObtenerDentista() async {
    try {
      // Obtener los datos del Dentista desde Firebase Realtime Database
      final dentistaSnapshot = await FirebaseDatabase.instance.ref('dentistas/${widget.idUsuario}').once();

      if (dentistaSnapshot.snapshot.exists) {
        final Map<String, dynamic> dentistaData = Map<String, dynamic>.from(dentistaSnapshot.snapshot.value as Map);
        dentistaData['id'] = dentistaSnapshot.snapshot.key;

        // Crear una instancia del modelo dentistaresponse2 con los datos obtenidos
        dentista = Dentistaresponse2.fromJson(dentistaData);

        // Obtener la URL de la imagen guardada en Firebase Storage
        if (dentistaData.containsKey('foto') && dentistaData['foto'].isNotEmpty) {
          imageUrl = dentistaData['foto'];
        }

        // Actualizar la UI después de obtener todos los datos
        setState(() {});
      } else {
        throw Exception('dentista no encontrado');
      }
    } catch (error) {
      print('Error obteniendo dentista: $error');
    }
  }


// Método para obtener la URL de la imagen desde Firebase Storage
  Future<String> _getImageUrlFromFirebase(String imageId) async {
    try {
      final ref = FirebaseStorage.instance.ref().child(imageId);
      return await ref.getDownloadURL();
    } catch (e) {
      print('Error obteniendo imagen desde Firebase Storage: $e');
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top:100, left:30, right:30, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Título
            Text(
              'Mi perfil',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2467ae),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            // Widget para mostrar la imagen
            Center(
              child: imageUrl != null && imageUrl!.isNotEmpty
                  ? ClipOval(
                child: Image.network(
                  imageUrl!,
                  height: 150,
                  width: 150,
                  fit: BoxFit.cover,
                ),
              )
                  : ClipOval(
                child: Container(
                  width: 100,
                  height: 100,
                  color: Colors.grey[500],
                  child: Icon(
                    Icons.person,
                    size: 50,
                    color: Colors.grey[700],
                  ),
                ),
              ),
            ),

            SizedBox(height: 30), // Espacio entre el título y las tarjetas de información
            // Tarjetas de información
            _buildInfoCard('Nombre', dentista?.nombre ?? 'Cargando...', Icons.person),
            SizedBox(height: 20),
            _buildInfoCard('Cedula', dentista?.cedula ?? 'Cargando...', Icons.account_box),
            SizedBox(height: 20),
            _buildInfoCard('Correo electrónico', dentista?.correo ?? 'Cargando...', Icons.email),
            SizedBox(height: 20),
            _buildInfoCard('Teléfono', dentista?.telefono ?? 'Cargando...', Icons.phone),
            SizedBox(height: 20),




          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Citas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule),
            label: 'Horario',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_rounded),
            label: 'Perfil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            label: 'Cerrar Sesión',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xFF2467ae),
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildInfoCard(String label, String value, IconData icon) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Color(0xFF2467ae), size: 30),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2467ae),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}