class Consultorioresponse {
  final String id;
  final String edificio;

  Consultorioresponse({required this.id, required this.edificio});

  factory Consultorioresponse.fromJson(Map<String, dynamic> json, String id) {
    if (json.containsKey('edificio')) {
      return Consultorioresponse(
        id: id,
        edificio: json['edificio'] ?? 'Sin edificio',
      );
    } else {
      throw FormatException("Datos incompletos en el JSON para Consultorio");
    }
  }
}
