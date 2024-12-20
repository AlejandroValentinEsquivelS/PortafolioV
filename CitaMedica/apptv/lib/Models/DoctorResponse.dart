class Doctorresponse {
  final int id;
  final String nombre;

  Doctorresponse({required this.id, required this.nombre});

  factory Doctorresponse.fromJson(Map<String, dynamic> json) {
    return Doctorresponse(
      id: json['id'],
      nombre: json['nombre'],
    );
  }
}