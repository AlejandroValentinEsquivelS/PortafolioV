class Citaresponse3 {
  String id;
  String estado;
  String fecha;
  String idConsultorio;
  String idDentista;
  String idEspecialidad;
  String idPaciente;

  Citaresponse3({
    required this.id,
    required this.estado,
    required this.fecha,
    required this.idConsultorio,
    required this.idDentista,
    required this.idEspecialidad,
    required this.idPaciente,
  });

  // Recibe el 'id' como un parámetro separado
  factory Citaresponse3.fromJson(Map<String, dynamic> json, String id) {
    return Citaresponse3(
      id: id, // El ID viene de la clave del snapshot
      estado: json['estado'] ?? '',
      fecha: json['fecha'] ?? '',
      idConsultorio: json['idConsultorio'] ?? '',
      idDentista: json['idDentista'] ?? '',
      idEspecialidad: json['idEspecialidad'] ?? '',
      idPaciente: json['idPaciente'] ?? '',
    );
  }
}
