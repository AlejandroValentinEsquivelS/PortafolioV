class PacienteresponseLogin{
  final String acceso;
  final String error;
  final String token;
  final int id_paciente;
  final String nombre;

  PacienteresponseLogin(this.acceso,this.error,this.token,this.id_paciente,this.nombre);

  PacienteresponseLogin.fromJson(Map<String, dynamic>json)
      : acceso= json['acceso'],
        error= json['error'],
        token= json['token'],
        id_paciente= json['id_paciente'],
        nombre= json['nombre'];
}

class PacienteresponseLogin2{

  final int idUsuario;
  final String nombreUsuario;
  final String rol;

  PacienteresponseLogin2(this.idUsuario,this.nombreUsuario,this.rol);

  PacienteresponseLogin2.fromJson(Map<String, dynamic>json)
      : idUsuario= json['idUsuario'],
        nombreUsuario= json['nombreUsuario'],
        rol =json['rol'];
}
