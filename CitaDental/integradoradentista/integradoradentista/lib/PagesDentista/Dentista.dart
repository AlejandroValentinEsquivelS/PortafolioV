import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:integradoradentista/Pages/Login.dart';
import 'package:quickalert/quickalert.dart';

class Dentista extends StatefulWidget {
  final int idDentista;

  const Dentista({Key? key, required this.idDentista}) : super(key: key);

  @override
  State<Dentista> createState() => _Dentistastate();
}

class _Dentistastate extends State<Dentista> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController txtNombre = TextEditingController();
  final TextEditingController txtEdad = TextEditingController(text: "18");
  final TextEditingController txtTelefono = TextEditingController();
  final TextEditingController txtPeso = TextEditingController();
  final TextEditingController txtAltura = TextEditingController();
  final TextEditingController txtDireccion = TextEditingController();
  final TextEditingController txtCorreo = TextEditingController();
  final TextEditingController txtPassword = TextEditingController();

  String? tipoSangreSeleccionado; // Variable para almacenar el tipo de sangre seleccionado
  List<String> tiposSangre = [
    'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-',
  ];

  Future<void> _registerDentista() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Crear usuario en Firebase Auth
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
          email: txtCorreo.text.trim(),
          password: txtPassword.text.trim(),
        );

        // Obtener el UID del usuario recién registrado
        String uid = userCredential.user!.uid;

        // Actualizar perfil de usuario en Firebase Auth (nombre)
        await userCredential.user!.updateDisplayName(txtNombre.text.trim());

        // Guardar datos del Dentista en Firebase Realtime Database
        DatabaseReference ref = FirebaseDatabase.instance.ref("dentistas").child(uid);
        await ref.set({
          'nombre': txtNombre.text,
          'edad': int.parse(txtEdad.text),
          'telefono': txtTelefono.text,
          'peso': txtPeso.text,
          'altura': txtAltura.text,
          'direccion': txtDireccion.text,
          'correo': txtCorreo.text,
          'tipo_sangre': tipoSangreSeleccionado,
          'role': "Dentista",
        });

        // Mostrar alerta de éxito
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          title: 'Registro Exitoso',
          text: 'El Dentista ha sido registrado exitosamente.',
          confirmBtnText: 'Aceptar',
        );

        // Navegar a otra página o cerrar el formulario
        Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Error',
          text: e.message ?? 'Error desconocido.',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Agregar Dentista", style: TextStyle(fontSize: 24)),
        backgroundColor: Color(0xFF00866E),
        foregroundColor: Colors.white,
        centerTitle: true,
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
                child: TextFormField(
                  controller: txtNombre,
                  decoration: InputDecoration(
                    labelText: 'Nombre',
                    labelStyle: TextStyle(fontSize: 14),
                    prefixIcon: Icon(Icons.person, color: Color(0xFF00866E)),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Favor de ingresar el nombre';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: TextFormField(
                  controller: txtTelefono,
                  decoration: InputDecoration(
                    labelText: 'Teléfono',
                    labelStyle: TextStyle(fontSize: 14),
                    prefixIcon: Icon(Icons.phone, color: Color(0xFF00866E)),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Favor de ingresar el teléfono';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: TextFormField(
                  controller: txtEdad,
                  decoration: InputDecoration(
                    labelText: 'Edad',
                    labelStyle: TextStyle(fontSize: 14),
                    prefixIcon: Icon(Icons.cake, color: Color(0xFF00866E)),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Favor de ingresar la edad';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: TextFormField(
                  controller: txtPeso,
                  decoration: InputDecoration(
                    labelText: 'Peso',
                    labelStyle: TextStyle(fontSize: 14),
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
              Padding(
                padding: EdgeInsets.all(16),
                child: TextFormField(
                  controller: txtAltura,
                  decoration: InputDecoration(
                    labelText: 'Altura',
                    labelStyle: TextStyle(fontSize: 14),
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
              Padding(
                padding: EdgeInsets.all(16),
                child: TextFormField(
                  controller: txtDireccion,
                  decoration: InputDecoration(
                    labelText: 'Dirección',
                    labelStyle: TextStyle(fontSize: 14),
                    prefixIcon: Icon(Icons.home, color: Color(0xFF00866E)),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Favor de ingresar la dirección';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  controller: txtCorreo,
                  decoration: InputDecoration(
                    labelText: 'Correo',
                    labelStyle: TextStyle(fontSize: 14),
                    prefixIcon: Icon(Icons.email, color: Color(0xFF00866E)),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Favor de ingresar el correo';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 16),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  controller: txtPassword,
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    labelStyle: TextStyle(fontSize: 14),
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
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  await _registerDentista(); // Guardar los datos en Realtime Database
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Login(), // Redirigir a la página de login
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF00866E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                ),
                child: Text('Guardar', style: TextStyle(fontSize: 16)),
              ),

              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
