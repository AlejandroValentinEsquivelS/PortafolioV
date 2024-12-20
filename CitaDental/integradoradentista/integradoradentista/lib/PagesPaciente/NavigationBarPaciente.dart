import 'package:integradoradentista/PagesPaciente/PacienteDetalles.dart';

import 'Citas.dart';
import '../Pages/Login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'Home.dart';

class NavigationBarPaciente extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  final String idUsuario;

  const NavigationBarPaciente({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
    required this.idUsuario,
  }) : super(key: key);

  @override
  _NavigationBarPacienteState createState() => _NavigationBarPacienteState();
}

class _NavigationBarPacienteState extends State< NavigationBarPaciente> {
  void _onItemTapped(int index) {
    setState(() {
    });

    // Navegación según la pestaña seleccionada
    switch (index) {
      case 0:
      // Mantener la página actual
        Navigator.push(context, MaterialPageRoute(builder: (context) => Home(idUsuario: widget.idUsuario)));
        break;
      case 1:
        Navigator.push(context, MaterialPageRoute(builder: (context) => Citas(idUsuario: widget.idUsuario)));
        break;
      case 2:
        Navigator.push(context, MaterialPageRoute(builder: (context) => Pacientedetalles(idUsuario: widget.idUsuario)));
        break;
      case 3:
        FirebaseAuth.instance.signOut().then((_) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
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
          icon: Icon(Icons.account_circle),
          label: 'Perfil',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.logout),
          label: 'Cerrar Sesión',
        ),
      ],
      currentIndex: widget.selectedIndex,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.black,
      onTap: _onItemTapped,
    );
  }
}
