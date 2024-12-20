class Citaresponse2 {
  final int id;
  final int idPaciente;
  final int idEspecialidad;
  final DateTime fechaHora; // Cambiado a DateTime
  final int idDoc;
  final int idConsultorio;
  final String estado;

  Citaresponse2({
    required this.id,
    required this.idPaciente,
    required this.idEspecialidad,
    required this.fechaHora, // Cambiado a DateTime
    required this.idDoc,
    required this.idConsultorio,
    required this.estado,
  });

  factory Citaresponse2.fromJson(Map<String, dynamic> json) {
    // Conversión de String a DateTime asumiendo formato 'yyyy-MM-dd HH:mm:ss'
    DateTime parsedFechaHora = DateTime.parse(json['FechaHora']);

    return Citaresponse2(
      id: json['id'],
      idPaciente: json['id_paciente'],
      idEspecialidad: json['id_especialidad'],
      fechaHora: parsedFechaHora, // Utilizando DateTime
      idDoc: json['id_doc'],
      idConsultorio: json['id_consultorio'],
      estado: json['estado'],
    );
  }
}
