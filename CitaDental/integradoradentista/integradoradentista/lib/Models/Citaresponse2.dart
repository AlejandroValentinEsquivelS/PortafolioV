class Citaresponse2 {
  String id;
  String estado; // Nuevo campo que se agregó
  String fecha; // Cambié el nombre a fecha
  String idConsultorio;
  String idDentista;
  String idEspecialidad;
  String idPaciente;

  Citaresponse2({
    required this.id,
    required this.estado, // Asegúrate de incluir este campo
    required this.fecha, // Cambia el nombre a fecha
    required this.idConsultorio,
    required this.idDentista,
    required this.idEspecialidad,
    required this.idPaciente,
  });

  factory Citaresponse2.fromJson(Map<String, dynamic> json) {
    return Citaresponse2(
      id: json['id'] ?? '', // Asegúrate de que este campo exista
      estado: json['estado'] ?? '', // Nuevo campo
      fecha: json['fecha'] ?? '', // Cambiado a fecha
      idConsultorio: json['idConsultorio'] ?? '',
      idDentista: json['idDentista'] ?? '',
      idEspecialidad: json['idEspecialidad'] ?? '',
      idPaciente: json['idPaciente'] ?? '',
    );
  }
}
