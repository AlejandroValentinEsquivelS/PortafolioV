class ConsultorioResponse3 {
  String id;
  String edificio;
  int numero;
  int nivel;

  ConsultorioResponse3({
    required this.id,
    required this.edificio,
    required this.numero,
    required this.nivel,
  });

  factory ConsultorioResponse3.fromJson(Map<String, dynamic> json) {
    return ConsultorioResponse3(
      id: json['id'],
      edificio: json['edificio'],
      numero: json['numero'],
      nivel: json['nivel'],
    );
  }

}
