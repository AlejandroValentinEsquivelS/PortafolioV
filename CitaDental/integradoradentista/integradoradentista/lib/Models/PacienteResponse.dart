class Pacienteresponse {
  final String id; // Debe ser String
  final String nombre;
  final int edad;
  final String telefono;
  final String peso;
  final String altura;
  final String direccion;
  final String correo;
  final String tipo_sangre;
  final String name;
  final String email;
  final String password;
  final String role;

  Pacienteresponse({
    required this.id,
    required this.nombre,
    required this.edad,
    required this.telefono,
    required this.peso,
    required this.altura,
    required this.direccion,
    required this.correo,
    required this.tipo_sangre,
    required this.name,
    required this.email,
    required this.password,
    required this.role,
  });

  factory Pacienteresponse.fromJson(Map<String, dynamic> json) {
    return Pacienteresponse(
      id: json['id'] ?? '',
      nombre: json['nombre'] ?? '',
      edad: json['edad'] ?? 0,
      telefono: json['telefono'] ?? '',
      peso: json['peso'] ?? '',
      altura: json['altura'] ?? '',
      direccion: json['direccion'] ?? '',
      correo: json['correo'] ?? '',
      tipo_sangre: json['tipo_sangre'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      role: json['role'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'edad': edad,
      'telefono': telefono,
      'peso': peso,
      'altura': altura,
      'direccion': direccion,
      'correo': correo,
      'tipo_sangre': tipo_sangre,
      'name': name,
      'email': email,
      'password': password,
      'role': role,
    };
  }
}
