class Consultorioresponse2 {
  final int id;
  final int numero;
  final String edificio;
  final int nivel;

  // Constructor
  Consultorioresponse2({
    required this.id,
    required this.numero,
    required this.edificio,
    required this.nivel,
  });

  // Método para crear una instancia desde un JSON
  factory Consultorioresponse2.fromJson(Map<String, dynamic> json) {
    // Validación de datos
    if (json['id'] == null || json['numero'] == null || json['edificio'] == null || json['nivel'] == null) {
      throw FormatException('Datos incompletos en el JSON');
    }

    return Consultorioresponse2(
      id: json['id'],
      numero: json['numero'],
      edificio: json['edificio'],
      nivel: json['nivel'],
    );
  }
}
