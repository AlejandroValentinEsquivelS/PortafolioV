class Doctorresponse {
  final int id;
  final String nombre;
  final String cedula;
  final String telefono;
  final String correo;
  final int id_especialidad;
  

  Doctorresponse(this.id, this.nombre,this.cedula,  this.telefono, this.correo, this.id_especialidad);

  Doctorresponse.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        nombre = json['nombre'],
        cedula = json['cedula'],
        telefono = json['telefono'],
        correo = json['correo'],
        id_especialidad = json['id_especialidad'];
}
