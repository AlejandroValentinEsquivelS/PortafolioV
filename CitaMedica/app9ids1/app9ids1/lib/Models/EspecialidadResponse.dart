

class Especialidadresponse{
  final int id;

  final String nombre;


  Especialidadresponse(this.id,this.nombre);

  Especialidadresponse.fromJson(Map<String, dynamic>json)
      : id= json['id'],
        nombre= json['nombre'];
}