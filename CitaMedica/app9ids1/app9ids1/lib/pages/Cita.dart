import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/quickalert.dart';
import 'package:intl/intl.dart';
import 'package:board_datetime_picker/board_datetime_picker.dart';
import 'package:app9ids1/Models/EspecialidadResponse.dart';
import 'package:app9ids1/Models/DoctorResponse.dart';
import 'package:app9ids1/Models/ConsultorioResponse.dart';
import 'package:app9ids1/Utils/Ambiente.dart';

class Cita extends StatefulWidget {
  final int idPaciente;

  const Cita({Key? key, required this.idPaciente}) : super(key: key);

  @override
  State<Cita> createState() => _CitaState();
}

class _CitaState extends State<Cita> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController txtEstado = TextEditingController();
  final textController = BoardDateTimeTextController();
  DateTime? selectedDateTime;
  String nombrePaciente = ''; // Variable para almacenar el nombre del paciente

  List<Especialidadresponse> especialidades = [];
  Especialidadresponse? especialidad;
  List<Doctorresponse> doctores = [];
  Doctorresponse? doctor;
  List<Consultorioresponse> consultorios = [];
  Consultorioresponse? consultorio;

  @override
  void initState() {
    super.initState();
    // Llamar a la función para obtener el nombre del paciente
    fnObtenerNombrePaciente();
    fnObtenerEspecialidades();
    fnObtenerDoctores();
    fnObtenerConsultorios();
  }

  void fnObtenerNombrePaciente() async {
    try {
      var response = await http.get(
        Uri.parse('${Ambiente.urlServer}/api/paciente/${widget.idPaciente}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> pacienteJson = jsonDecode(response.body);
        String nombre = pacienteJson['nombre'];
        setState(() {
          nombrePaciente = nombre; // Almacenar el nombre del paciente
        });
      } else {
        throw Exception('Error al obtener los datos del paciente: ${response.statusCode}');
      }
    } catch (error) {
      print('Error obteniendo paciente: $error');
    }
  }

  void fnObtenerEspecialidades() async {
    var response = await http.get(
      Uri.parse('${Ambiente.urlServer}/api/especialidades'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      Iterable mapEspecialidades = jsonDecode(response.body);
      especialidades = List<Especialidadresponse>.from(
        mapEspecialidades.map((model) => Especialidadresponse.fromJson(model)),
      );
      setState(() {});
    } else {
      throw Exception('Error al obtener las especialidades: ${response.statusCode}');
    }
  }

  void fnObtenerDoctores() async {
    var response = await http.get(
      Uri.parse('${Ambiente.urlServer}/api/doctores'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      Iterable mapDoctores = jsonDecode(response.body);
      doctores = List<Doctorresponse>.from(
        mapDoctores.map((model) => Doctorresponse.fromJson(model)),
      );
      setState(() {});
    } else {
      throw Exception('Error al obtener los doctores: ${response.statusCode}');
    }
  }

  void fnObtenerConsultorios() async {
    var response = await http.get(
      Uri.parse('${Ambiente.urlServer}/api/consultorios'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      Iterable mapConsultorios = jsonDecode(response.body);
      consultorios = List<Consultorioresponse>.from(
        mapConsultorios.map((model) => Consultorioresponse.fromJson(model)),
      );
      setState(() {});
    } else {
      throw Exception('Error al obtener los consultorios: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Agregar Cita',
          style: TextStyle(fontSize: 24),
        ),
        backgroundColor: Color(0xFF00866E),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(8),
                margin: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Color(0xFFE0F7FA),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.person,
                      color: Color(0xFF00866E),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Nombre del Paciente: $nombrePaciente',
                      style: TextStyle(
                        color: Color(0xFF00866E),
                        fontWeight: FontWeight.normal,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<Especialidadresponse>(
                value: especialidad,
                hint: Text('Especialidad'),
                decoration: InputDecoration(

                  filled: true,
                  fillColor: Color(0xFFE0F7FA),
                  prefixIcon: Icon(Icons.monitor_heart, color: Color(0xFF00866E)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide.none, // Ocultar el borde predeterminado
                  ),
                ),
                style: TextStyle(color: Colors.black),
                onChanged: (Especialidadresponse? value) {
                  especialidad = value;
                  setState(() {});
                },
                items: especialidades.map<DropdownMenuItem<Especialidadresponse>>(
                      (Especialidadresponse value) {
                    return DropdownMenuItem<Especialidadresponse>(
                      value: value,
                      child: Text(value.nombre),
                    );
                  },
                ).toList(),
              ),
              SizedBox(height: 16),
              BoardDateTimeInputField(
                controller: textController,
                pickerType: DateTimePickerType.datetime,
                options: const BoardDateTimeOptions(
                  languages: BoardPickerLanguages.en(),
                ),
                textStyle: TextStyle(

                ),
                onChanged: (date) {
                  setState(() {
                    selectedDateTime = date;
                  });
                },
                onFocusChange: (val, date, text) {
                  print('on focus changed date: $val, $date, $text');
                  setState(() {
                    if (date != null) {
                      selectedDateTime = date;
                    }
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Fecha y hora',
                  labelStyle: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide.none, // Ocultar el borde predeterminado
                  ),
                  fillColor: Color(0xFFE0F7FA),
                  filled: true,
                  prefixIcon: Icon(Icons.calendar_today, color: Color(0xFF00866E)), // Color del ícono de calendario

                ),
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<Doctorresponse>(
                value: doctor,
                hint: Text('Doctor'),
                decoration: InputDecoration(

                  filled: true,
                  fillColor: Color(0xFFE0F7FA),
                  prefixIcon: Icon(Icons.perm_contact_cal_sharp  , color: Color(0xFF00866E)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide.none, // Ocultar el borde predeterminado
                  ),
                ),
                style: TextStyle(color: Color(0xFF00866E)),
                onChanged: (Doctorresponse? value) {
                  doctor = value;
                  setState(() {});
                },
                items: doctores.map<DropdownMenuItem<Doctorresponse>>(
                      (Doctorresponse value) {
                    return DropdownMenuItem<Doctorresponse>(
                      value: value,
                      child: Text(value.nombre),
                    );
                  },
                ).toList(),
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<Consultorioresponse>(
                value: consultorio,
                hint: Text('Consultorio'),
                decoration: InputDecoration(
                  fillColor: Color(0xFFE0F7FA),
                  filled: true,
                  prefixIcon: Icon(Icons.home_work_sharp , color: Color(0xFF00866E)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide.none, // Ocultar el borde predeterminado
                  ),
                ),
                style: TextStyle(color: Colors.black),
                onChanged: (Consultorioresponse? value) {
                  consultorio = value;
                  setState(() {});
                },
                items: consultorios.map<DropdownMenuItem<Consultorioresponse>>(
                      (Consultorioresponse value) {
                    return DropdownMenuItem<Consultorioresponse>(
                      value: value,
                      child: Text(value.edificio),
                    );
                  },
                ).toList(),
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        if (selectedDateTime == null) {
                          QuickAlert.show(
                            context: context,
                            type: QuickAlertType.warning,
                            title: 'Advertencia',
                            text: 'Seleccione una fecha y hora',
                          );
                          return;
                        }

                        String FechaHora =
                        DateFormat('yyyy-MM-dd HH:mm:ss').format(selectedDateTime!);

                        final response = await http.post(
                          Uri.parse('${Ambiente.urlServer}/api/cita/guardar'),
                          body: jsonEncode(<String, dynamic>{
                            'id_paciente': widget.idPaciente,
                            'id_especialidad': especialidad?.id,
                            'FechaHora': FechaHora,
                            'id_doc': doctor?.id,
                            'id_consultorio': consultorio?.id,
                            'estado': "Pendiente",
                          }),
                          headers: <String, String>{
                            'Content-Type': 'application/json; charset=UTF-8',
                            'Accept': 'application/json',
                          },
                        );

                        if (response.body == 'Ok') {
                          Navigator.pop(context);
                        } else {
                          QuickAlert.show(
                            context: context,
                            type: QuickAlertType.error,
                            title: 'Oops..',
                            text: 'Error',
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF00866E),
                      foregroundColor: Colors.white,
                    ),
                    child: Text('Guardar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
