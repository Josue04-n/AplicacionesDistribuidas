import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/consulta_general.dart';
import '../models/doctor.dart';
import '../models/paciente.dart';
import '../models/diagnostico.dart';
import '../models/cita_medica.dart';

class MedicityService {
  final String _baseUrl = ApiConfig.fullUrl;
  static const Duration _timeout = Duration(seconds: 15);

  /// Envuelve cualquier request HTTP con un timeout para evitar
  /// que la UI se quede colgada esperando respuesta del servidor.
  Future<http.Response> _send(Future<http.Response> request) async {
    try {
      return await request.timeout(_timeout);
    } on TimeoutException {
      throw Exception('Tiempo de espera agotado. Intenta de nuevo.');
    }
  }

  /// Decodifica el body de la respuesta de forma segura.
  /// Si no es JSON válido, retorna un map con el body como texto.
  dynamic _safeDecode(http.Response response) {
    try {
      return json.decode(response.body);
    } catch (_) {
      return {'mensaje': response.body};
    }
  }

  // ──────────────────────────────────────────────
  // GET - Consulta General
  // ──────────────────────────────────────────────
  Future<List<ConsultaGeneral>> getConsultaGeneral() async {
    final response = await _send(
      http.get(Uri.parse('$_baseUrl/general')),
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => ConsultaGeneral.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar la consulta general');
    }
  }

  // ──────────────────────────────────────────────
  // GET - Doctores
  // ──────────────────────────────────────────────
  Future<List<Doctor>> getDoctores() async {
    final response = await _send(
      http.get(Uri.parse('$_baseUrl/doctor')),
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Doctor.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar doctores');
    }
  }

  // ──────────────────────────────────────────────
  // GET - Pacientes
  // ──────────────────────────────────────────────
  Future<List<Paciente>> getPacientes() async {
    final response = await _send(
      http.get(Uri.parse('$_baseUrl/paciente')),
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Paciente.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar pacientes');
    }
  }

  // ──────────────────────────────────────────────
  // GET - Diagnósticos
  // ──────────────────────────────────────────────
  Future<List<Diagnostico>> getDiagnosticos() async {
    final response = await _send(
      http.get(Uri.parse('$_baseUrl/diagnostico')),
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Diagnostico.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar diagnósticos');
    }
  }

  // ──────────────────────────────────────────────
  // GET - Citas Médicas
  // ──────────────────────────────────────────────
  Future<List<CitaMedica>> getCitasMedicas() async {
    final response = await _send(
      http.get(Uri.parse('$_baseUrl/citasMedicas')),
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => CitaMedica.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar citas médicas');
    }
  }

  // ──────────────────────────────────────────────
  // POST - Crear Doctor
  // ──────────────────────────────────────────────
  Future<String> crearDoctor({
    required String nombre,
    required int idEspecialidad,
    required int idCiudad,
  }) async {
    final response = await _send(
      http.post(
        Uri.parse('$_baseUrl/sp_doctor'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'nombre': nombre,
          'idEspecialidad': idEspecialidad,
          'idCiudad': idCiudad,
        }),
      ),
    );
    final data = _safeDecode(response);
    if (response.statusCode == 200) {
      return data['mensaje'] ?? 'Doctor creado correctamente';
    } else {
      throw Exception(data['mensaje'] ?? 'Error al crear doctor');
    }
  }

  // ──────────────────────────────────────────────
  // PUT - Actualizar Cita Médica
  // ──────────────────────────────────────────────
  Future<String> actualizarCita({
    required int id,
    required int idPaciente,
    required int idDoctor,
    required DateTime fechaHora,
  }) async {
    final response = await _send(
      http.put(
        Uri.parse('$_baseUrl/cita/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'idPaciente': idPaciente,
          'idDoctor': idDoctor,
          'fechaHora': fechaHora.toIso8601String(),
        }),
      ),
    );
    final data = _safeDecode(response);
    if (response.statusCode == 200) {
      return data['mensaje'] ?? 'Cita actualizada correctamente';
    } else {
      throw Exception(data['mensaje'] ?? 'Error al actualizar cita');
    }
  }

  // ──────────────────────────────────────────────
  // PUT - Actualizar Diagnóstico
  // ──────────────────────────────────────────────
  Future<String> actualizarDiagnostico({
    required int id,
    required int idCita,
    required String nombre,
    required String descripcion,
    required String tratamiento,
  }) async {
    final response = await _send(
      http.put(
        Uri.parse('$_baseUrl/diagnostico/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'id_cita': idCita,
          'nombre': nombre,
          'descripcion': descripcion,
          'tratamiento': tratamiento,
        }),
      ),
    );
    final data = _safeDecode(response);
    if (response.statusCode == 200) {
      return data['mensaje'] ?? 'Diagnóstico actualizado correctamente';
    } else {
      throw Exception(data['mensaje'] ?? 'Error al actualizar diagnóstico');
    }
  }

  // ──────────────────────────────────────────────
  // PUT - Actualizar Paciente
  // ──────────────────────────────────────────────
  Future<String> actualizarPaciente({
    required int id,
    required String nombre,
    required DateTime fechaNacimiento,
    required String direccion,
    required int idCiudad,
  }) async {
    final response = await _send(
      http.put(
        Uri.parse('$_baseUrl/paciente/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'nombre': nombre,
          'fecha_nacimiento': fechaNacimiento.toIso8601String(),
          'direccion': direccion,
          'id_ciudad': idCiudad,
        }),
      ),
    );
    final data = _safeDecode(response);
    if (response.statusCode == 200) {
      return data['mensaje'] ?? 'Paciente actualizado correctamente';
    } else {
      throw Exception(data['mensaje'] ?? 'Error al actualizar paciente');
    }
  }
}
