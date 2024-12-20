class EspecialidadResponse2 {
  final String id;
  final String nombre; // Asegúrate de que este campo coincida con el de Firebase

  EspecialidadResponse2({
    required this.id,
    required this.nombre,
  });

  factory EspecialidadResponse2.fromJson(Map<String, dynamic> json) {
    return EspecialidadResponse2(
      id: json['id'] ?? '', // Manejar el caso de que no exista
      nombre: json['nombre'] ?? '', // Asegúrate de que este campo exista
    );
  }
}
