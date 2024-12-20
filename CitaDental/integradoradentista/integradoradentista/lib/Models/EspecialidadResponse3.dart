class EspecialidadResponse3 {
  String id;
  String nombre;

  EspecialidadResponse3({
    required this.id,
    required this.nombre,
  });

  factory EspecialidadResponse3.fromJson(Map<String, dynamic> json) {
    return EspecialidadResponse3(
      id: json['id'],
      nombre: json['nombre'],
    );
  }

}
