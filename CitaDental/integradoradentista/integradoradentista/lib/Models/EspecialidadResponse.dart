class Especialidadresponse {
  final String id;
  final String nombre;

  Especialidadresponse({required this.id, required this.nombre});

  factory Especialidadresponse.fromJson(Map<String, dynamic> json, String id) {
    return Especialidadresponse(
      id: id,
      nombre: json['nombre'],
    );
  }
}
