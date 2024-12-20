class Doctorresponse2 {
  final int id;
  final String nombre;

  Doctorresponse2({required this.id, required this.nombre});

  factory Doctorresponse2.fromJson(Map<String, dynamic> json) {
    return Doctorresponse2(
      id: json['id'],
      nombre: json['nombre'],
    );
  }
}