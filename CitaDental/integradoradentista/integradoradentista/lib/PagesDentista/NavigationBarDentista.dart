import 'package:integradoradentista/PagesDentista/DentistaDetalles.dart';

import 'Citas.dart';
import '../Pages/Login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:integradoradentista/PagesDentista/VistaCalendario.dart';

import 'HomeDentista.dart';

class NavigationBarDentista extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  final String idUsuario;

  const NavigationBarDentista({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
    required this.idUsuario,
  }) : super(key: key);

  @override
  _NavigationBarDentistaState createState() => _NavigationBarDentistaState();
}

class _NavigationBarDentistaState extends State<NavigationBarDentista> {
  void _onItemTapped(int index) {
    widget.onItemTapped(index);
    if (index != widget.selectedIndex) {
      switch (index) {
        case 0:
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>
                    HomeDentista(idUsuario: widget.idUsuario)));
          });
          break; // Puedes dejar vacío si es la pantalla de inicio
        case 1:
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Citas(idDentista: widget.idUsuario)),
          );
          break;
        case 2:
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>
                    VistaHorarios(idUsuario: widget.idUsuario)));
          });
          break;
        case 3:
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>
                    Dentistadetalles(idUsuario: widget.idUsuario)));
          });
          break;
        case 4:
          FirebaseAuth.instance.signOut().then((_) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Login()),
            );
          });
          break;
      }
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
          icon: Icon(Icons.schedule),
          label: 'Horario',
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
      selectedItemColor: Color(0xFF2467ae),
      unselectedItemColor: Colors.grey,
      onTap: _onItemTapped,
    );
  }
}
