class Pacienteresponse2{
  final int id;
  final String nombre;
  final int edad;
  final String telefono;
  final String peso;
  final String altura;
  final String direccion;
  final String correo;
  final String tipo_sangre;


  Pacienteresponse2(this.id,this.nombre,this.edad,this.telefono,this.peso,this.altura,this.direccion,this.correo,this.tipo_sangre);
  Pacienteresponse2.fromJson(Map<String, dynamic>json)
      : id= json['id'],
        nombre= json['nombre'],
        edad= json['edad'],
        telefono= json['telefono'],
        peso= json['peso'],
        altura= json['altura'],
        direccion= json['direccion'],
        correo= json['correo'],
        tipo_sangre= json['tipo_sangre'];
}
