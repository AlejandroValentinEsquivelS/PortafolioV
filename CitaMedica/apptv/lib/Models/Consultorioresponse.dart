class Consultorioresponse {
  final int id;
  final int numero;
  final String edificio;
  final int nivel;

  Consultorioresponse({
    required this.id,
    required this.numero,
    required this.edificio,
    required this.nivel,
  });

  factory Consultorioresponse.fromJson(Map<String, dynamic> json) {
    return Consultorioresponse(
      id: json['id'],
      numero: json['numero'],
      edificio: json['edificio'],
      nivel: json['nivel'],
    );
  }
}
