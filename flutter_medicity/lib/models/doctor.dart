class Doctor {
  final String nombre;
  final String especialidad;
  final String ciudadDoctor;

  Doctor({
    required this.nombre,
    required this.especialidad,
    required this.ciudadDoctor,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      nombre: json['nombre'] ?? '',
      especialidad: json['especialidad'] ?? '',
      ciudadDoctor: json['ciudad_Doctor'] ?? '',
    );
  }
}
