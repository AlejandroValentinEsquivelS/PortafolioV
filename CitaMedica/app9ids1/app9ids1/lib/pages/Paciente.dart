import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:quickalert/quickalert.dart';

import '../Utils/Ambiente.dart';

class Paciente extends StatefulWidget {
  final int idPaciente;

  const Paciente({Key? key, required this.idPaciente}) : super(key: key);

  @override
  State<Paciente> createState() => _PacienteState();
}

class _PacienteState extends State<Paciente> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController txtNom = TextEditingController();
  TextEditingController txtEdad = TextEditingController(text: "18");
  TextEditingController txtTel = TextEditingController();
  TextEditingController txtPeso = TextEditingController();
  TextEditingController txtAltura = TextEditingController();
  TextEditingController txtDireccion = TextEditingController();
  TextEditingController txtCorreo = TextEditingController();
  TextEditingController txtSangre = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  String? tipoSangreSeleccionado; // Variable para almacenar el tipo de sangre seleccionado

  List<String> tiposSangre = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Agregar paciente",
          style: TextStyle(fontSize: 24),
        ),
        backgroundColor: Color(0xFF00866E), // Color de fondo del AppBar
        foregroundColor: Colors.white,
        centerTitle: true, // Para centrar el título
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 16),
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextFormField(
                      controller: txtNom,
                      decoration: InputDecoration(
                        labelText: 'Nombre',
                        labelStyle: TextStyle(
                          fontSize: 14,
                        ),
                        prefixIcon: Icon(Icons.person, color: Color(0xFF00866E)),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Favor de ingresar el nombre';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    // Campo de teléfono que ocupa 2/3 de la pantalla
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: EdgeInsets.only(right: 10), // Espacio a la derecha
                        child: TextFormField(
                          controller: txtTel,
                          decoration: InputDecoration(
                            labelText: 'Teléfono',
                            labelStyle: TextStyle(
                              fontSize: 14,
                            ),
                            prefixIcon: Icon(Icons.call, color: Color(0xFF00866E)),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Favor de ingresar el teléfono';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    // Campo de edad que ocupa 1/3 de la pantalla
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.only(left: 10), // Espacio a la izquierda
                        child: Row(
                          children: [
                            // Campo de edad
                            Expanded(
                              child: TextFormField(
                                controller: txtEdad,
                                decoration: InputDecoration(
                                  labelText: 'Edad',
                                  labelStyle: TextStyle(
                                    fontSize: 14,
                                  ),
                                  prefixIcon: Icon(Icons.numbers_outlined, color: Color(0xFF00866E)),
                                ),
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Favor de ingresar la edad';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            // Botones para incrementar y decrementar la edad
                            Column(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.arrow_drop_up),
                                  onPressed: () {
                                    int currentValue = int.parse(txtEdad.text);
                                    setState(() {
                                      currentValue++;
                                      txtEdad.text = currentValue.toString();
                                    });
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.arrow_drop_down),
                                  onPressed: () {
                                    int currentValue = int.parse(txtEdad.text);
                                    setState(() {
                                      currentValue--;
                                      txtEdad.text = currentValue.toString();
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    // Campo de peso que ocupa 1/2 de la pantalla
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.only(right: 10), // Espacio a la derecha
                        child: TextFormField(
                          controller: txtPeso,
                          decoration: InputDecoration(
                            labelText: 'Peso',
                            labelStyle: TextStyle(
                              fontSize: 14,
                            ),
                            prefixIcon: Icon(Icons.monitor_weight, color: Color(0xFF00866E)),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Favor de ingresar el peso';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    // Campo de altura que ocupa 1/2 de la pantalla
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.only(left: 10), // Espacio a la izquierda
                        child: TextFormField(
                          controller: txtAltura,
                          decoration: InputDecoration(
                            labelText: 'Altura',
                            labelStyle: TextStyle(
                              fontSize: 14,
                            ),
                            prefixIcon: Icon(Icons.height, color: Color(0xFF00866E)),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Favor de ingresar la altura';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Column(
                  children: [
                    TextFormField(
                      controller: txtDireccion,
                      decoration: InputDecoration(
                        labelText: 'Dirección',
                        labelStyle: TextStyle(
                          fontSize: 14,
                        ),
                        prefixIcon: Icon(Icons.location_on, color: Color(0xFF00866E)),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Favor de ingresar la dirección';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 18), // Espacio tanto a la derecha como a la izquierda
                child: DropdownButtonFormField<String>(
                  value: tipoSangreSeleccionado,
                  onChanged: (String? newValue) {
                    setState(() {
                      tipoSangreSeleccionado = newValue;
                      txtSangre.text = newValue ?? '';
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Tipo de Sangre',
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                    fillColor: Color(0xFFE0F7FA),
                    filled: true,
                    prefixIcon: Icon(Icons.bloodtype_rounded, color: Color(0xFF00866E)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide.none, // Ocultar el borde predeterminado
                    ),
                  ),
                  style: TextStyle(color: Color(0xFF00866E)),
                  items: tiposSangre.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Favor de seleccionar el tipo de sangre';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 16),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    TextFormField(
                      controller: txtCorreo,
                      decoration: InputDecoration(
                        labelText: 'Correo',
                        labelStyle: TextStyle(
                          fontSize: 14,
                        ),
                        prefixIcon: Icon(Icons.email, color: Color(0xFF00866E)),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Favor de ingresar el correo';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    TextFormField(
                      controller: txtPassword,
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                        labelStyle: TextStyle(
                          fontSize: 14,
                        ),
                        prefixIcon: Icon(Icons.lock, color: Color(0xFF00866E)),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Favor de ingresar la contraseña';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final response = await http.post(
                      Uri.parse('${Ambiente.urlServer}/api/paciente/registrar'),
                      body: jsonEncode(<String, dynamic>{
                        'nombre': txtNom.text,
                        'edad': txtEdad.text,
                        'telefono': txtTel.text,
                        'peso': txtPeso.text,
                        'altura': txtAltura.text,
                        'direccion': txtDireccion.text,
                        'correo': txtCorreo.text,
                        'tipo_sangre': txtSangre.text,
                        'name': txtNom.text,
                        'email': txtCorreo.text,
                        'password': txtPassword.text,
                        'role': "Paciente",
                      }),
                      headers: <String, String>{
                        'Content-Type': 'application/json; charset=UTF-8',
                        'Accept': 'application/json',
                      },
                    );
                    if (response.body == "Ok") {
                      Navigator.pop(context);
                    } else {
                      QuickAlert.show(
                        context: context,
                        type: QuickAlertType.error,
                        title: 'Oops..',
                        text: "Error",
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF00866E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                ),
                child: Text(
                  'Guardar',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
