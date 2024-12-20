class Consultorioresponse2 {
  final int id;
  final int numero;
  final String edificio;
  final int nivel;

  Consultorioresponse2({
    required this.id,
    required this.numero,
    required this.edificio,
    required this.nivel,
  });

  factory Consultorioresponse2.fromJson(Map<String, dynamic> json) {
    return Consultorioresponse2(
      id: json['id'],
      numero: json['numero'],
      edificio: json['edificio'],
      nivel: json['nivel'],
    );
  }
}