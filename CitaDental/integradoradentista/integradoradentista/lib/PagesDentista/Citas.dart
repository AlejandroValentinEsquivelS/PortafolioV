import 'package:integradoradentista/PagesDentista/DentistaDetalles.dart';
import '../Pages/Login.dart';
import 'package:intl/intl.dart';
import '../Models/CitaResponse3.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:integradoradentista/PagesDentista/HomeDentista.dart';
import 'package:integradoradentista/PagesDentista/VistaCalendario.dart';
import 'package:integradoradentista/PagesDentista/NavigationBarDentista.dart';
import 'package:integradoradentista/PagesDentista/CitaDetalles.dart';

class Citas extends StatefulWidget {
  final String idDentista;

  const Citas({Key? key, required this.idDentista}) : super(key: key);

  @override
  _CitasState createState() => _CitasState();
}

class _CitasState extends State<Citas> {
  List<Citaresponse3> citas = [];
  List<Citaresponse3> citasFiltradas = [];
  bool isLoading = true;
  final DatabaseReference databaseRef = FirebaseDatabase.instance.ref();
  String filtroEstado = 'todas';
  int _selectedIndex = 1; // Configura el índice inicial para "Citas"

  @override
  void initState() {
    super.initState();
    fnObtenerCitas();
  }

  Future<void> fnObtenerCitas() async {
    try {
      final citasSnapshot = await databaseRef
          .child('citas')
          .orderByChild('idDentista')
          .equalTo(widget.idDentista)
          .once();

      if (citasSnapshot.snapshot.exists) {
        final data = citasSnapshot.snapshot.value as Map<dynamic, dynamic>;

        setState(() {
          citas = data.entries.map((entry) {
            return Citaresponse3.fromJson(
                Map<String, dynamic>.from(entry.value), entry.key);
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

  Future<String> obtenerNombrePaciente(String idPaciente) async {
    try {
      final pacienteSnapshot =
      await databaseRef.child('pacientes/$idPaciente').once();

      if (pacienteSnapshot.snapshot.exists) {
        final pacienteData =
        pacienteSnapshot.snapshot.value as Map<dynamic, dynamic>;
        return pacienteData['nombre'] as String? ?? 'Nombre desconocido';
      } else {
        return 'Paciente no encontrado';
      }
    } catch (e) {
      print('Error obteniendo paciente: $e');
      return 'Error al obtener nombre del paciente';
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


  Future<void> actualizarEstadoCita(String citaId, String nuevoEstado) async {
    try {
      print('Actualizando estado de la cita con ID: $citaId a $nuevoEstado');
      await databaseRef.child('citas/$citaId').update({
        'estado': nuevoEstado,
      });

      setState(() {
        final index = citas.indexWhere((cita) => cita.id == citaId);
        if (index != -1) {
          citas[index].estado = nuevoEstado;
        }
      });
    } catch (e) {
      print('Error actualizando estado de la cita: $e');
    }
  }

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return; // Evita recargar la misma página

    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => HomeDentista(idUsuario: widget.idDentista)),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Citas(idDentista: widget.idDentista)),
        );
        break;
      case 2:
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    VistaHorarios(idUsuario: widget.idDentista)),
          );
        });
        break;
      case 3:
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    Dentistadetalles(idUsuario: widget.idDentista)),
          );
        });
        break;
      case 4:
        FirebaseAuth.instance.signOut().then((_) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Login()));
        });
        break;
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
        title: const Text('Historial de citas'),
        backgroundColor: const Color(0xFF2467ae),
        foregroundColor: Colors.white,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                    if (newValue != null) filtrarCitas(newValue);
                  },
                  items: ['todas', 'aceptada', 'rechazada', 'cancelado', 'pendiente']
                      .map<DropdownMenuItem<String>>(
                        (String value) => DropdownMenuItem<String>(
                      value: value,
                      child: Text(value.toUpperCase()),
                    ),
                  )
                      .toList(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : (citasFiltradas.isEmpty
                  ? const Center(child: Text('No tienes citas con este estado'))
                  : ListView.builder(
                itemCount: citasFiltradas.length,
                itemBuilder: (context, index) {
                  var cita = citasFiltradas[index];
                  return Card(
                    color: obtenerColorTarjeta(cita.estado),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.person,
                                  color: Colors.white, size: 30),
                              const SizedBox(width: 8),
                              FutureBuilder<String>(
                                future: obtenerNombrePaciente(
                                    cita.idPaciente),
                                builder: (context, snapshot) {
                                  String nombrePaciente = 'Cargando...';
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    nombrePaciente = snapshot.data ??
                                        'Error al cargar';
                                  }
                                  return Flexible(
                                    child: Text(
                                      nombrePaciente,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),

                                  );

                                },

                              ),


                            ],
                          ),

                          PopupMenuButton<String>(
                            icon: const Icon(Icons.more_vert,
                                color: Colors.white),
                            onSelected: (String result) {

                               if (result == 'Detalles') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        CitaDetalles(cita.id),
                                  ),
                                );
                              }
                            },
                            itemBuilder: (BuildContext context) {
                              return <PopupMenuEntry<String>>[
                                const PopupMenuItem<String>(
                                  value: 'Detalles',
                                  child: Text('Detalles cita'),
                                ),
                              ];
                            },
                          ),
                          const SizedBox(height: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Text(
                                'Fecha: ${formatFecha(cita.fecha)}',
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.white),
                              ),
                              Text(
                                'Hora: ${formatHora(cita.fecha)}',
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.white),
                              ),
                              Text(
                                'Estado: ${cita.estado}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (cita.estado == 'pendiente')
                                Row(
                                  children: [

                                    IconButton(
                                      icon: const Icon(Icons.check_circle,
                                          color: Colors.green),
                                      onPressed: () async {
                                        await actualizarEstadoCita(
                                            cita.id, 'aceptada');
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  'Cita aceptada')),
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.cancel,
                                          color: Colors.red),
                                      onPressed: () async {
                                        await actualizarEstadoCita(
                                            cita.id, 'cancelado');
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  'Cita cancelada')),
                                        );
                                      },
                                    ),
                                  ],
                                ),

                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBarDentista(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
        idUsuario: widget.idDentista,
      ),
    );
  }
}