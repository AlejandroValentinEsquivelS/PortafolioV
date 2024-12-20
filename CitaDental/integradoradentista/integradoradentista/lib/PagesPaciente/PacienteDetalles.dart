import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:integradoradentista/PagesPaciente/Home.dart';
import 'package:integradoradentista/PagesPaciente/Citas.dart';
import 'package:integradoradentista/Pages/Login.dart';
import 'package:integradoradentista/Models/PacienteResponse2.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Pacientedetalles extends StatefulWidget {
  final String idUsuario;

  const Pacientedetalles({Key? key, required this.idUsuario}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Pacientedetalles> {
  Pacienteresponse2? paciente;
  String? imageUrl;
  int _selectedIndex = 2;
  final DatabaseReference databaseRef = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    super.initState();
    fnObtenerPaciente();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.push(context, MaterialPageRoute(builder: (context) => Home(idUsuario: widget.idUsuario)));
        break;
      case 1:
        Navigator.push(context, MaterialPageRoute(builder: (context) => Citas(idUsuario: widget.idUsuario)));
        break;
      case 2:
        break;
      case 3:
        FirebaseAuth.instance.signOut().then((_) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
        });
        break;
    }
  }
  // Método para obtener la URL de la imagen desde Firebase Storage
  Future<void> fnObtenerPaciente() async {
    try {
      // Obtener los datos del paciente desde Firebase Realtime Database
      final pacienteSnapshot = await FirebaseDatabase.instance.ref('pacientes/${widget.idUsuario}').once();

      if (pacienteSnapshot.snapshot.exists) {
        final Map<String, dynamic> pacienteData = Map<String, dynamic>.from(pacienteSnapshot.snapshot.value as Map);
        pacienteData['id'] = pacienteSnapshot.snapshot.key;

        // Crear una instancia del modelo Pacienteresponse2 con los datos obtenidos
        paciente = Pacienteresponse2.fromJson(pacienteData);

        // Obtener la URL de la imagen guardada en Firebase Storage
        if (pacienteData.containsKey('foto') && pacienteData['foto'].isNotEmpty) {
          imageUrl = pacienteData['foto'];
        }

        // Actualizar la UI después de obtener todos los datos
        setState(() {});
      } else {
        throw Exception('Paciente no encontrado');
      }
    } catch (error) {
      print('Error obteniendo paciente: $error');
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
            _buildInfoCard('Nombre', paciente?.nombre ?? 'Cargando...', Icons.person),
            SizedBox(height: 20),
            _buildInfoCard('Correo electrónico', paciente?.correo ?? 'Cargando...', Icons.email),
            SizedBox(height: 20),
            _buildInfoCard('Teléfono', paciente?.telefono ?? 'Cargando...', Icons.phone),
            SizedBox(height: 20),
            _buildInfoCard('Dirección', paciente?.direccion ?? 'Cargando...', Icons.account_balance_rounded),
            SizedBox(height: 20),
            _buildInfoCard(
                'Peso',
                paciente?.peso != null ? '${paciente!.peso} kg' : 'Cargando...',
                Icons.monitor_weight
            ),
            SizedBox(height: 20),
            _buildInfoCard(
                'Altura',
                paciente?.altura != null ? '${paciente!.altura} cm' : 'Cargando...',
                Icons.height
            ),

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
            icon: Icon(Icons.account_circle_rounded),
            label: 'Perfil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            label: 'Cerrar Sesión',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
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