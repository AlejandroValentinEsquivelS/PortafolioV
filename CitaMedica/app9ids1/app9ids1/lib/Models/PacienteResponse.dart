class Pacienteresponse{
  final int id;
  final String nombre;
  final int edad;
  final String telefono;
  final String peso;
  final String altura;
  final String direccion;
  final String correo;
  final String tipo_sangre;
  final String name;
  final String email;
  final String password;
  final String role;

  Pacienteresponse(this.id,this.nombre,this.edad,this.telefono,this.peso,this.altura,this.direccion,this.correo,this.tipo_sangre,this.name,this.email,this.password,
      this.role);
  Pacienteresponse.fromJson(Map<String, dynamic>json)
      : id= json['id'],
        nombre= json['nombre'],
        edad= json['edad'],
        telefono= json['telefono'],
        peso= json['peso'],
        altura= json['altura'],
        direccion= json['direccion'],
        correo= json['correo'],
        tipo_sangre= json['tipo_sangre'],
        name= json['name'],
        email= json['email'],
        password= json['password'],
        role= json['role'];
}


