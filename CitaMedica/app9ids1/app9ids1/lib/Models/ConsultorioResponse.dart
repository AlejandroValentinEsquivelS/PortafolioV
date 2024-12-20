class Consultorioresponse {
  final int id;
  final int numero;
  final String edificio;
  final int nivel;


  Consultorioresponse(this.id, this.numero, this.edificio, this.nivel);

  Consultorioresponse.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        numero = json['numero'],
        edificio = json['edificio'],
        nivel = json['nivel'];
}

