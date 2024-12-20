class EspecialidadResponse2 {
  final int id;
  final String nombre;

  EspecialidadResponse2({required this.id, required this.nombre});

  factory EspecialidadResponse2.fromJson(Map<String, dynamic> json) {
    return EspecialidadResponse2(
      id: json['id'],
      nombre: json['nombre'],
    );
  }
}