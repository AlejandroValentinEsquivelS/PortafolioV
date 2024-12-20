import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:integradoradentista/Models/PacienteResponse2.dart';
import '../Models/CitaResponse3.dart';
import 'package:integradoradentista/PagesPaciente/Home.dart';
import '../Pages/Login.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'CitaDetalles.dart';

import 'PacienteDetalles.dart';


class Citas extends StatefulWidget {
  final String idUsuario;

  const Citas({Key? key, required this.idUsuario}) : super(key: key);

  @override
  _CitasState createState() => _CitasState();
}

class _CitasState extends State<Citas> {
  Pacienteresponse2? paciente;
  List<Citaresponse3> citas = [];
  bool isLoading = true;
  String nombrePaciente = '';
  Map<String, bool> expandedCitas = {};
  List<Citaresponse3> citasFiltradas = [];
  final DatabaseReference databaseRef = FirebaseDatabase.instance.ref();
  String filtroEstado = 'todas';
  int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    fnObtenerPaciente();
    initializeDateFormatting('es', null).then((_) => fnObtenerPaciente());
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navegación según la pestaña seleccionada
    switch (index) {
      case 0:
      // Mantener la página actual
        Navigator.push(context, MaterialPageRoute(builder: (context) => Home(idUsuario: widget.idUsuario)));
        break;
      case 1:

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

  Future<void> fnObtenerPaciente() async {
    try {
      final pacienteSnapshot = await databaseRef.child('pacientes/${widget.idUsuario}').once();
      if (pacienteSnapshot.snapshot.exists) {
        final pacienteData = Map<String, dynamic>.from(pacienteSnapshot.snapshot.value as Map);
        pacienteData['id'] = pacienteSnapshot.snapshot.key;

        paciente = Pacienteresponse2.fromJson(pacienteData);
        await fnObtenerCitas(paciente!.id);

        setState(() {
          nombrePaciente = paciente!.nombre;
        });
      } else {
        throw Exception('Paciente no encontrado');
      }
    } catch (error) {
      print('Error obteniendo paciente: $error');
    }
  }

  Future<void> fnObtenerCitas(String idPaciente) async {
    try {
      final citasSnapshot = await databaseRef.child('citas').orderByChild('idPaciente').equalTo(idPaciente).once();
      if (citasSnapshot.snapshot.exists) {
        final data = citasSnapshot.snapshot.value as Map<dynamic, dynamic>;
        setState(() {
          citas = data.entries.map((entry) {
            return Citaresponse3.fromJson(Map<String, dynamic>.from(entry.value), entry.key);
          }).toList();
          citasFiltradas = List.from(citas);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error obteniendo citas: $e');
    }
  }

  Future<String> obtenerNombreDentista(String idDentista) async {
    try {
      final dentistaSnapshot = await databaseRef.child('dentistas/$idDentista').once();
      if (dentistaSnapshot.snapshot.exists) {
        final dentistaData = dentistaSnapshot.snapshot.value as Map<dynamic, dynamic>;
        return dentistaData['nombre'] ?? 'Dentista desconocido';
      } else {
        return 'Dentista no encontrado';
      }
    } catch (e) {
      print('Error obteniendo dentista: $e');
      return 'Error al obtener nombre';
    }
  }

  void filtrarCitas(String estado) {
    setState(() {
      filtroEstado = estado;
      if (estado == 'todas') {
        citasFiltradas = List.from(citas);
      } else {
        citasFiltradas = citas.where((cita) => cita.estado == estado).toList();
      }
    });
  }

  Color obtenerColorTarjeta(String estado) {
    switch (estado) {
      case 'aceptada':
        return Colors.green.shade400;
      case 'rechazada':
        return Colors.orangeAccent;
      case 'cancelado':
        return Colors.red.shade300;
      case 'pendiente':
      default:
        return Colors.blueAccent;
    }
  }

  Future<void> _cancelarCita(String idCita) async {
    try {
      await databaseRef.child('citas/$idCita').update({'estado': 'cancelado'});
      setState(() {
        citas.firstWhere((cita) => cita.id == idCita).estado = 'cancelado';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cita cancelada')),
      );
    } catch (e) {
      print('Error al cancelar la cita: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al cancelar la cita')),
      );
    }
  }

  String formatFecha(String fecha) {
    try {
      DateTime dateTime = DateTime.parse(fecha);
      return DateFormat('d \'de\' MMMM \'de\' yyyy', 'es').format(dateTime);
    } catch (e) {
      print('Error formateando la fecha: $e');
      return 'Formato de fecha inválido';
    }
  }

  String formatHora(String fecha) {
    try {
      DateTime dateTime = DateTime.parse(fecha);
      return DateFormat('hh:mm a', 'es').format(dateTime);
    } catch (e) {
      print('Error formateando la hora: $e');
      return 'Formato de hora inválido';
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Historial de citas',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF2467ae),
        elevation: 0,
        automaticallyImplyLeading: false, // Elimina la flecha de retroceso
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Filtrar por estado:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                DropdownButton<String>(
                  value: filtroEstado,
                  onChanged: (String? newValue) {
                    filtrarCitas(newValue!);
                  },
                  items: <String>['todas', 'aceptada', 'rechazada', 'cancelado', 'pendiente']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value.toUpperCase()),
                    );
                  }).toList(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : citasFiltradas.isEmpty
                ? const Center(child: Text('No tienes citas'))
                : Expanded(
              child: ListView(
                children: citasFiltradas.map((cita) {
                  return FutureBuilder<String>(
                    future: obtenerNombreDentista(cita.idDentista),
                    builder: (context, snapshot) {
                      String nombreDentista = 'Cargando...';
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasData) {
                          nombreDentista = snapshot.data!;
                        } else {
                          nombreDentista = 'Error al cargar';
                        }
                      }

                      return Card(
                        color: obtenerColorTarjeta(cita.estado),
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          leading: const Icon(
                            Icons.calendar_today,
                            color: Colors.white,
                          ),
                          title: Text(
                            'Dentista: $nombreDentista',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Fecha: ${formatFecha(cita.fecha)}',
                                style: const TextStyle(fontSize: 14, color: Colors.white),
                              ),
                              Text(
                                'Hora: ${formatHora(cita.fecha)}',
                                style: const TextStyle(fontSize: 14, color: Colors.white),
                              ),
                              Text(
                                'Estado: ${cita.estado}',
                                style: const TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          trailing: PopupMenuButton<String>(
                            icon: const Icon(Icons.more_vert, color: Colors.white),
                            onSelected: (String result) {
                              if (result == 'Cancelar') {
                                _cancelarCita(cita.id);
                              }
                              if (result == 'Detalles') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CitaDetalles(cita.id),
                                  ),
                                );
                              }
                            },
                            itemBuilder: (BuildContext context) {
                              return <PopupMenuEntry<String>>[
                                const PopupMenuItem<String>(
                                  value: 'Cancelar',
                                  child: Text('Cancelar cita'),
                                ),
                                const PopupMenuItem<String>(
                                  value: 'Detalles',
                                  child: Text('Detalles cita'),
                                ),
                              ];


                            },
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
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
}
