import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:integradoradentista/Models/DentistaResponse.dart';
import 'package:integradoradentista/Models/ConsultorioResponse.dart';
import 'package:integradoradentista/Models/EspecialidadResponse.dart';

class Cita extends StatefulWidget {
  final String idPaciente;

  const Cita({Key? key, required this.idPaciente}) : super(key: key);

  @override
  State<Cita> createState() => _CitaState();
}

class _CitaState extends State<Cita> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController txtEstado = TextEditingController();
  DateTime? selectedDateTime;
  String nombrePaciente = '';

  List<Especialidadresponse> especialidades = [];
  Especialidadresponse? especialidad;
  List<Dentistaresponse> dentistas = [];
  Dentistaresponse? dentista;
  List<Consultorioresponse> consultorios = [];
  Consultorioresponse? consultorio;

  List<Map<String, dynamic>> horariosDisponibles = [];
  Map<String, dynamic>? selectedHorario;

  final DatabaseReference databaseRef = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    super.initState();
    fnObtenerNombrePaciente();
    fnObtenerEspecialidades();
    fnObtenerDentistas();
    fnObtenerConsultorios();
  }

  void fnObtenerNombrePaciente() async {
    try {
      final pacienteSnapshot = await databaseRef.child(
          'pacientes/${widget.idPaciente}').once();

      if (pacienteSnapshot.snapshot.exists) {
        setState(() {
          nombrePaciente = pacienteSnapshot.snapshot
              .child('nombre')
              .value
              .toString();
        });
      } else {
        throw Exception('Paciente no encontrado');
      }
    } catch (error) {
      print('Error obteniendo paciente: $error');
    }
  }

  void fnObtenerEspecialidades() async {
    try {
      final especialidadesSnapshot = await databaseRef.child('especialidades')
          .once();

      if (especialidadesSnapshot.snapshot.exists) {
        final data = especialidadesSnapshot.snapshot.value as Map<
            dynamic,
            dynamic>;
        setState(() {
          especialidades = data.entries
              .map((entry) => Especialidadresponse.fromJson(
              Map<String, dynamic>.from(entry.value), entry.key))
              .toList();
        });
      }
    } catch (error) {
      print('Error obteniendo especialidades: $error');
    }
  }

  void fnObtenerDentistas() async {
    try {
      final dentistasSnapshot = await databaseRef.child('dentistas').once();

      if (dentistasSnapshot.snapshot.exists) {
        final data = dentistasSnapshot.snapshot.value as Map<dynamic, dynamic>;
        setState(() {
          dentistas = data.entries
              .map((entry) => Dentistaresponse.fromJson(
              Map<String, dynamic>.from(entry.value), entry.key))
              .toList();
        });
      }
    } catch (error) {
      print('Error obteniendo dentistas: $error');
    }
  }

  void fnObtenerConsultorios() async {
    try {
      final consultoriosSnapshot = await databaseRef.child('consultorios')
          .once();

      if (consultoriosSnapshot.snapshot.exists) {
        final data = consultoriosSnapshot.snapshot.value as Map<dynamic,
            dynamic>;
        setState(() {
          consultorios = data.entries
              .map((entry) => Consultorioresponse.fromJson(
              Map<String, dynamic>.from(entry.value), entry.key))
              .toList();
        });
      }
    } catch (error) {
      print('Error obteniendo consultorios: $error');
    }
  }

  DateTime obtenerProximaFecha(String diaSemana) {
    final hoy = DateTime.now();
    final diasDeSemana = {
      'Lunes': DateTime.monday,
      'Martes': DateTime.tuesday,
      'Miércoles': DateTime.wednesday,
      'Jueves': DateTime.thursday,
      'Viernes': DateTime.friday,
      'Sábado': DateTime.saturday,
      'Domingo': DateTime.sunday,
    };

    final objetivo = diasDeSemana[diaSemana];
    if (objetivo == null) {
      throw Exception('Día de la semana no válido: $diaSemana');
    }

    final diferencia = (objetivo - hoy.weekday + 7) % 7;
    return hoy.add(Duration(days: diferencia == 0 ? 7 : diferencia));
  }

  void fnObtenerHorariosDentista(String idDentista,
      DateTime fechaSeleccionada) async {
    try {
      String diaSeleccionado = DateFormat('EEEE', 'es_ES').format(
          fechaSeleccionada);
      diaSeleccionado =
          diaSeleccionado[0].toUpperCase() + diaSeleccionado.substring(1);

      final horariosSnapshot = await databaseRef.child(
          'horariosDoctores/$idDentista/horarios').once();

      if (horariosSnapshot.snapshot.exists) {
        final data = horariosSnapshot.snapshot.value as Map<dynamic, dynamic>;
        setState(() {
          horariosDisponibles = [];
          data.forEach((dia, detalles) {
            if (dia.toString().toLowerCase() == diaSeleccionado.toLowerCase()) {
              final detallesMap = detalles as Map<dynamic, dynamic>;
              detallesMap.forEach((intervalo, info) {
                if (info['estado'] == 'disponible') {
                  horariosDisponibles.add({
                    'intervalo': intervalo,
                    'inicio': info['inicio'],
                    'fin': info['fin'],
                  });
                }
              });
            }
          });
        });
      }
    } catch (error) {
      print('Error obteniendo horarios del dentista: $error');
    }
    // Llama a 'ordenarHorarios()'
    setState(() {
      ordenarHorarios();
    });
  }

  void fnSeleccionarHorario(Map<String, dynamic> horario) {
    setState(() {
      selectedHorario = horario;
    });
  }

  void guardarCita() async {
    if (selectedHorario != null && selectedDateTime != null) {
      try {
        final nuevaCitaRef = databaseRef.child('citas').push();

        await nuevaCitaRef.set({

          'idPaciente': widget.idPaciente,
          'idDentista': dentista!.id,
          'fecha': DateFormat('yyyy-MM-dd HH:mm:ss').format(selectedDateTime!),
          'estado': "pendiente",
        });

        String diaSeleccionado = DateFormat('EEEE', 'es_ES').format(
            selectedDateTime!);
        diaSeleccionado =
            diaSeleccionado[0].toUpperCase() + diaSeleccionado.substring(1);

        final horarioRef = databaseRef.child(
          'horariosDoctores/${dentista!
              .id}/horarios/$diaSeleccionado/${selectedHorario!['intervalo']}',
        );
        await horarioRef.update({'estado': 'ocupado'});

        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          title: 'Éxito',
          text: 'La cita ha sido registrada',
        );

        fnObtenerHorariosDentista(dentista!.id, selectedDateTime!);
      } catch (error) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Error',
          text: 'Hubo un problema al registrar la cita. Inténtelo nuevamente.',
        );
      }
    } else {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Error',
        text: 'Selecciona un horario y una fecha.',
      );
    }
  }

  void ordenarHorarios() {
    horariosDisponibles.sort((a, b) {
      // Asume que 'inicio' es el campo con el horario en formato 'HH:mm'
      DateTime horaA = DateFormat('HH:mm').parse(a['inicio']);
      DateTime horaB = DateFormat('HH:mm').parse(b['inicio']);
      return horaA.compareTo(horaB); // Ordena de menor a mayor
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agendar cita'),
        backgroundColor: Color(0xFF2467ae),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Text(
                  '$nombrePaciente',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<Especialidadresponse>(
                  decoration: InputDecoration(
                    labelText: 'Especialidad',
                    labelStyle: TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.grey.withOpacity(0.2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: Icon(Icons.medical_services_rounded,
                        color: Color(0xFF949699)),
                  ),
                  items: especialidades.map((especialidad) {
                    return DropdownMenuItem(
                      value: especialidad,
                      child: Text(especialidad.nombre),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      especialidad = value;
                    });
                  },
                  validator: (value) =>
                  value == null
                      ? 'Seleccione una especialidad'
                      : null,
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<Dentistaresponse>(
                  decoration: InputDecoration(
                    labelText: 'Dentista',
                    labelStyle: TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.grey.withOpacity(0.2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: Icon(Icons.person, color: Color(0xFF949699)),
                  ),
                  items: dentistas.map((dentista) {
                    return DropdownMenuItem(
                      value: dentista,
                      child: Text(dentista.nombre),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      dentista = value;
                      if (selectedDateTime != null) {
                        fnObtenerHorariosDentista(dentista!.id,
                            selectedDateTime!);
                      }
                    });
                  },
                  validator: (value) =>
                  value == null
                      ? 'Seleccione un dentista'
                      : null,
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<Consultorioresponse>(
                  decoration: InputDecoration(
                    labelText: 'Consultorio',
                    labelStyle: TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.grey.withOpacity(0.2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: Icon(
                        Icons.home_work_rounded, color: Color(0xFF949699)),
                  ),
                  items: consultorios.map((consultorio) {
                    return DropdownMenuItem(
                      value: consultorio,
                      child: Text(consultorio.edificio),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      consultorio = value;
                    });
                  },
                  validator: (value) =>
                  value == null
                      ? 'Seleccione un consultorio'
                      : null,
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today, color: Color(0xFF949699)),
                      Expanded(
                        child: TextButton(
                          onPressed: () async {

                            DateTime? fechaSeleccionada = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(DateTime.now().year + 1),
                            );
                            if (fechaSeleccionada != null) {
                              setState(() {
                                selectedDateTime = fechaSeleccionada;
                                if (dentista != null) {
                                  fnObtenerHorariosDentista(dentista!.id, fechaSeleccionada);
                                }
                              });
                            }
                          },
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              selectedDateTime == null
                                  ? 'Seleccione una fecha'
                                  : DateFormat('EEEE, d \'de\' MMMM \'de\' y', 'es_ES').format(selectedDateTime!),
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Horarios disponibles',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),
                SizedBox(
                  height: 300.0, // Ajusta la altura según sea necesario
                  child: horariosDisponibles.isNotEmpty
                      ? ListView(
                    // Centra el contenido en el eje horizontal
                    padding: EdgeInsets.symmetric(horizontal: 20.0), // Opcional: ajustar el margen horizontal
                    children: horariosDisponibles.map((horario) {
                      return Center( // Centrar cada RadioListTile
                        child: RadioListTile<Map<String, dynamic>>(
                          title: Text(
                            '${horario['inicio']} - ${horario['fin']}',
                            textAlign: TextAlign.center, // Centra el texto dentro del RadioListTile
                          ),
                          value: horario,
                          groupValue: selectedHorario,
                          onChanged: (value) {
                            fnSeleccionarHorario(value!);
                          },
                          // Establece el color cuando está seleccionado
                          selectedTileColor: Colors.blue.withOpacity(0.2),
                          // Cambia el color del icono cuando está activo (seleccionado)
                          activeColor: Color(0xFF2467ae),
                          // Configura que el Tile se seleccione cuando es el grupo actual
                          selected: selectedHorario == horario,
                        ),
                      );
                    }).toList(),
                  )
                      : Center(
                    child: Text('No hay horarios disponibles para esta fecha'),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: guardarCita,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF2467ae),
                  ),
                  child: const Text(
                    'Guardar Cita',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}