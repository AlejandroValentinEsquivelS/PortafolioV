class EspecialidadResponse {
  final int id;
  final String nombre;

  EspecialidadResponse({required this.id, required this.nombre});

  factory EspecialidadResponse.fromJson(Map<String, dynamic> json) {
    return EspecialidadResponse(
      id: json['id'],
      nombre: json['nombre'],
    );
  }
}
