class Paciente {
  final String nombrePaciente;
  final int edad;
  final String direccion;
  final String ciudadPaciente;

  Paciente({
    required this.nombrePaciente,
    required this.edad,
    required this.direccion,
    required this.ciudadPaciente,
  });

  factory Paciente.fromJson(Map<String, dynamic> json) {
    return Paciente(
      nombrePaciente: json['nombre_paciente'] ?? '',
      edad: json['edad'] ?? 0,
      direccion: json['direccion'] ?? '',
      ciudadPaciente: json['ciudad_paciente'] ?? '',
    );
  }
}
