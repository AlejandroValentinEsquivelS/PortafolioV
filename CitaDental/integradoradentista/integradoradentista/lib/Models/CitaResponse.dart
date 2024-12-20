class Citaresponse {
  final String id;
  final String idPaciente;
  final String idDentista;
  final String fecha;
  final String estado;
  final String idConsultorio;
  final String idEspecialidad;

  Citaresponse({
    required this.id,
    required this.idPaciente,
    required this.idDentista,
    required this.fecha,
    required this.estado,
    required this.idConsultorio,
    required this.idEspecialidad,
  });

  factory Citaresponse.fromJson(Map<String, dynamic> json) {
    return Citaresponse(
      id: json['id'] as String,
      idPaciente: json['idPaciente'] as String,
      idDentista: json['idDentista'] as String,
      fecha: json['fecha'] as String,
      estado: json['estado'] as String,
      idConsultorio: json['idConsultorio'] as String,
      idEspecialidad: json['idEspecialidad'] as String,
    );
  }
}
