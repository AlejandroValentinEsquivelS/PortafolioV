class DentistaResponse3 {
  String id;
  String nombre;
  // Agrega más propiedades según sea necesario

  DentistaResponse3({
    required this.id,
    required this.nombre,
  });


  factory DentistaResponse3.fromJson(Map<String, dynamic> json) {
    return DentistaResponse3(
      id: json['id'] ?? '',
      nombre: json['nombre'] ?? '',
    );
  }
}
