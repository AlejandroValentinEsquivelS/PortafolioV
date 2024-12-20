import 'dart:io';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart'; // Importa Firebase Storage
import 'package:firebase_database/firebase_database.dart'; // Importa Realtime Database

class Paciente extends StatefulWidget {
  final int idPaciente;

  const Paciente({Key? key, required this.idPaciente}) : super(key: key);

  @override
  State<Paciente> createState() => _PacienteState();
}

class _PacienteState extends State<Paciente> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController txtNombre = TextEditingController();
  final TextEditingController txtEdad = TextEditingController(text: "18");
  final TextEditingController txtTelefono = TextEditingController();
  final TextEditingController txtPeso = TextEditingController();
  final TextEditingController txtAltura = TextEditingController();
  final TextEditingController txtDireccion = TextEditingController();
  final TextEditingController txtCorreo = TextEditingController();
  final TextEditingController txtPassword = TextEditingController();

  File? _image;
  final ImagePicker _picker = ImagePicker();

  String? tipoSangreSeleccionado; // Variable para almacenar el tipo de sangre seleccionado
  List<String> tiposSangre = [
    'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-',
  ];

  Future<void> _registerPaciente() async {
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

        // Subir imagen a Firebase Storage si se seleccionó una
        String imageUrl = '';
        if (_image != null) {
          // Generar un nombre único para la imagen usando el UID del paciente
          String imagePath = 'pacientes/$uid/${DateTime
              .now()
              .millisecondsSinceEpoch}.jpg';

          // Subir la imagen al Storage
          Reference storageRef = FirebaseStorage.instance.ref().child(
              imagePath);
          UploadTask uploadTask = storageRef.putFile(_image!);
          TaskSnapshot snapshot = await uploadTask;

          // Obtener la URL de la imagen una vez que se haya subido
          imageUrl = await snapshot.ref.getDownloadURL();
        }

        // Actualizar perfil de usuario en Firebase Auth (nombre)
        await userCredential.user!.updateDisplayName(txtNombre.text.trim());

        // Guardar datos del paciente en Firebase Realtime Database
        DatabaseReference ref = FirebaseDatabase.instance.ref("pacientes")
            .child(uid);
        await ref.set({
          'nombre': txtNombre.text.trim(),
          'edad': int.parse(txtEdad.text),
          'telefono': txtTelefono.text,
          'peso': txtPeso.text,
          'altura': txtAltura.text,
          'direccion': txtDireccion.text,
          'correo': txtCorreo.text,
          'tipo_sangre': tipoSangreSeleccionado,
          'role': "Paciente",
          'foto': imageUrl, // Guardar la URL de la imagen en la base de datos
        });

        // Mostrar alerta de éxito
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          title: 'Registro Exitoso',
          text: 'El paciente ha sido registrado exitosamente.',
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

  Future<void> _selectImage() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('Seleccionar de la galería'),
              onTap: () async {
                Navigator.pop(context);
                final XFile? pickedFile = await _picker.pickImage(
                  source: ImageSource.gallery,
                );
                if (pickedFile != null) {
                  setState(() {
                    _image = File(pickedFile.path);
                  });
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('Tomar una foto'),
              onTap: () async {
                Navigator.pop(context);
                final XFile? pickedFile = await _picker.pickImage(
                  source: ImageSource.camera,
                );
                if (pickedFile != null) {
                  setState(() {
                    _image = File(pickedFile.path);
                  });
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registrar", style: TextStyle(fontSize: 24)),
        backgroundColor: Color(0xFF2467ae),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    _image != null
                        ? Image.file(
                      _image!,
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    )
                        : Container(
                      width: 150,
                      height: 150,
                      color: Colors.grey[300],
                      child: Icon(
                        Icons.person,
                        size: 100,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _selectImage,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF2467ae),
                        padding: EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.camera_alt, color: Colors.grey),
                          SizedBox(width: 8),
                          Text(
                            'Seleccionar una imagen',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5),
              // Reutilizamos el mismo estilo de InputDecoration para cada TextFormField
              _buildStyledTextFormField(txtNombre, 'Nombre', Icons.person),
              _buildStyledTextFormField(txtTelefono, 'Teléfono', Icons.phone),
              _buildStyledTextFormField(txtEdad, 'Edad', Icons.cake),
              _buildStyledTextFormField(txtPeso, 'Peso', Icons.monitor_weight),
              _buildStyledTextFormField(txtAltura, 'Altura', Icons.height),
              _buildStyledTextFormField(txtDireccion, 'Dirección', Icons.home),
              _buildStyledTextFormField(
                  txtCorreo, 'Correo electrónico', Icons.email),
              _buildStyledTextFormField(
                  txtPassword, 'Contraseña', Icons.lock, obscureText: true),
              Padding(
                padding: EdgeInsets.all(16),
                child: DropdownButtonFormField<String>(
                  value: tipoSangreSeleccionado,
                  items: tiposSangre.map((String tipo) {
                    return DropdownMenuItem<String>(
                      value: tipo,
                      child: Text(tipo),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      tipoSangreSeleccionado = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Tipo de sangre',
                    labelStyle: TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.grey.withOpacity(0.2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: Icon(Icons.bloodtype, color: Color(0xFF949699)),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed: _registerPaciente,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF2467ae),
                  ),
                  child: Text(
                      'Aceptar', style: TextStyle(color: Colors.white, fontSize: 18), ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
// Método auxiliar para crear un TextFormField con el mismo estilo
  Widget _buildStyledTextFormField(TextEditingController controller,
      String label, IconData icon, {bool obscureText = false}) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey),
          filled: true,
          fillColor: Colors.grey.withOpacity(0.2),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: BorderSide.none,
          ),
          prefixIcon: Icon(icon, color: Color(0xFF949699)),
        ),
        style: TextStyle(color: Colors.black),
        obscureText: obscureText,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Favor de ingresar $label.toLowerCase()';
          }
          return null;
        },
      ),
    );
  }
}
