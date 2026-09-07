class CitaMedica {
  final String paciente;
  final String doctor;
  final String fechaHora;

  CitaMedica({
    required this.paciente,
    required this.doctor,
    required this.fechaHora,
  });

  factory CitaMedica.fromJson(Map<String, dynamic> json) {
    return CitaMedica(
      paciente: json['paciente'] ?? '',
      doctor: json['doctor'] ?? '',
      fechaHora: json['fechaHora']?.toString() ?? '',
    );
  }
}
