class Citaresponse {
  final int id;
  final int id_paciente;
  final int id_especialidad;
  final DateTime FechaHora;
  final int id_doc;
  final int id_consultorio;
  final String estado;

  Citaresponse({
    required this.id,
    required this.id_paciente,
    required this.id_especialidad,
    required this.FechaHora,
    required this.id_doc,
    required this.id_consultorio,
    required this.estado,
  });

  factory Citaresponse.fromJson(Map<String, dynamic> json) {
    return Citaresponse(
      id: json['id'],
      id_paciente: json['id_paciente'],
      id_especialidad: json['id_especialidad'],
      FechaHora: DateTime.parse(json['FechaHora']), // Convertir la fecha
      id_doc: json['id_doc'],
      id_consultorio: json['id_consultorio'],
      estado: json['estado'],
    );
  }
}

