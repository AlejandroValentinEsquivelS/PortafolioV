class Dentistaresponse {
  final String id;
  final String nombre;

  Dentistaresponse({required this.id, required this.nombre});

  factory Dentistaresponse.fromJson(Map<String, dynamic> json, String id) {
    if (json.containsKey('nombre')) {
      return Dentistaresponse(
        id: id,
        nombre: json['nombre'] ?? 'Sin nombre',
      );
    } else {
      throw FormatException("Datos incompletos en el JSON para Dentista");
    }
  }
}

