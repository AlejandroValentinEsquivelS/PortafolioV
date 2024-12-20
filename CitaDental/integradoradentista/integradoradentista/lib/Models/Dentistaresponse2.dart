class Dentistaresponse2 {
  final String id; // Debe ser String
  final String nombre;
  final String telefono;
  final String correo;
  final String cedula;
  final String name;
  final String email;
  final String password;

  Dentistaresponse2({
    required this.id,
    required this.nombre,
    required this.telefono,
    required this.correo,
    required this.cedula,
    required this.name,
    required this.email,
    required this.password,
  });

  factory Dentistaresponse2.fromJson(Map<String, dynamic> json) {
    return Dentistaresponse2(
      id: json['id'] ?? '',
      nombre: json['nombre'] ?? '',
      telefono: json['telefono'] ?? '',
      correo: json['correo'] ?? '',
      cedula: json['cedula'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'telefono': telefono,
      'correo': correo,
      'cedula': correo,
      'name': name,
      'email': email,
      'password': password,
    };
  }
}
