class PacienteresponseLogin {
  final String acceso;
  final String error;
  final String token;
  final int idPaciente; // Renamed to follow Dart naming conventions
  final String nombre;

  PacienteresponseLogin({
    required this.acceso,
    required this.error,
    required this.token,
    required this.idPaciente,
    required this.nombre,
  });

  factory PacienteresponseLogin.fromJson(Map<String, dynamic> json) {
    return PacienteresponseLogin(
      acceso: json['acceso'] ?? '',
      error: json['error'] ?? '',
      token: json['token'] ?? '',
      idPaciente: json['id_paciente'] ?? 0,
      nombre: json['nombre'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'acceso': acceso,
      'error': error,
      'token': token,
      'id_paciente': idPaciente,
      'nombre': nombre,
    };
  }
}

class PacienteresponseLogin2 {
  final int idUsuario;
  final String nombreUsuario;
  final String rol;

  PacienteresponseLogin2({
    required this.idUsuario,
    required this.nombreUsuario,
    required this.rol,
  });

  factory PacienteresponseLogin2.fromJson(Map<String, dynamic> json) {
    return PacienteresponseLogin2(
      idUsuario: json['idUsuario'] ?? 0,
      nombreUsuario: json['nombreUsuario'] ?? '',
      rol: json['rol'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idUsuario': idUsuario,
      'nombreUsuario': nombreUsuario,
      'rol': rol,
    };
  }
}
