class Citaresponse {
  final int id;
  final int id_paciente;
  final int id_especialidad;
  final DateTime FechaHora;
  final int id_doc;
  final int id_consultorio;
  final String estado;

  Citaresponse(this.id, this.id_paciente, this.id_especialidad, this.FechaHora, this.id_doc, this.id_consultorio, this.estado);

  Citaresponse.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        id_paciente = json['id_paciente'],
        id_especialidad = json['id_especialidad'],
        FechaHora = json['FechaHora'],
        id_doc = json['id_doc'],
        id_consultorio = json['id_consultorio'],
        estado = json['estado'];
}

