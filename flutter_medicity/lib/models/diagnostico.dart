class Diagnostico {
  final String nombreDiagnostico;
  final String descripcion;
  final String tratamiento;

  Diagnostico({
    required this.nombreDiagnostico,
    required this.descripcion,
    required this.tratamiento,
  });

  factory Diagnostico.fromJson(Map<String, dynamic> json) {
    return Diagnostico(
      nombreDiagnostico: json['nombre_diagnostico'] ?? '',
      descripcion: json['descripcion'] ?? '',
      tratamiento: json['tratamiento'] ?? '',
    );
  }
}
