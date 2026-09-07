import 'package:flutter/material.dart';
import '../models/cita_medica.dart';
import '../services/medicity_service.dart';
import '../utils/date_formatter.dart';

class ActualizarCitaScreen extends StatefulWidget {
  final int index;
  final CitaMedica cita;

  const ActualizarCitaScreen({
    super.key,
    required this.index,
    required this.cita,
  });

  @override
  State<ActualizarCitaScreen> createState() => _ActualizarCitaScreenState();
}

class _ActualizarCitaScreenState extends State<ActualizarCitaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _pacienteCtrl = TextEditingController();
  final _doctorCtrl = TextEditingController();
  final _service = MedicityService();
  late DateTime _fecha;
  late TimeOfDay _hora;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    // Pre-fill date and time from existing cita
    final parsed = DateFormatter.tryParse(widget.cita.fechaHora);
    if (parsed != null) {
      _fecha = DateTime(parsed.year, parsed.month, parsed.day);
      _hora = TimeOfDay(hour: parsed.hour, minute: parsed.minute);
    } else {
      _fecha = DateTime.now().add(const Duration(days: 1));
      _hora = TimeOfDay.now();
    }
  }

  @override
  void dispose() {
    _pacienteCtrl.dispose();
    _doctorCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_loading) return;
    final fechaHora = DateTime(
      _fecha.year, _fecha.month, _fecha.day,
      _hora.hour, _hora.minute,
    );
    setState(() => _loading = true);
    try {
      final msg = await _service.actualizarCita(
        id: widget.index,
        idPaciente: int.parse(_pacienteCtrl.text),
        idDoctor: int.parse(_doctorCtrl.text),
        fechaHora: fechaHora,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceAll('Exception: ', '')),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Actualizar Cita')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with current info
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: colorScheme.primaryContainer,
                      foregroundColor: colorScheme.onPrimaryContainer,
                      child: const Icon(Icons.calendar_month_rounded, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Cita #${widget.index}',
                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.person_rounded, size: 13, color: colorScheme.onSurfaceVariant),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  'Paciente: ${widget.cita.paciente}',
                                  style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Icon(Icons.medical_services_rounded, size: 13, color: colorScheme.onSurfaceVariant),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  'Doctor: ${widget.cita.doctor}',
                                  style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Icon(Icons.event_rounded, size: 13, color: colorScheme.onSurfaceVariant),
                              const SizedBox(width: 4),
                              Text(
                                DateFormatter.formatDate(widget.cita.fechaHora),
                                style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
                              ),
                              const SizedBox(width: 10),
                              Icon(Icons.access_time_rounded, size: 13, color: colorScheme.onSurfaceVariant),
                              const SizedBox(width: 4),
                              Text(
                                DateFormatter.formatTime(widget.cita.fechaHora),
                                style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Modificar datos',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _pacienteCtrl,
                decoration: InputDecoration(
                  labelText: 'ID Paciente',
                  prefixIcon: const Icon(Icons.person_outline_rounded),
                  helperText: 'Paciente actual: ${widget.cita.paciente}',
                  helperMaxLines: 2,
                ),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || int.tryParse(v) == null ? 'Ingrese un número válido' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _doctorCtrl,
                decoration: InputDecoration(
                  labelText: 'ID Doctor',
                  prefixIcon: const Icon(Icons.medical_services_outlined),
                  helperText: 'Doctor actual: ${widget.cita.doctor}',
                  helperMaxLines: 2,
                ),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || int.tryParse(v) == null ? 'Ingrese un número válido' : null,
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () async {
                  final d = await showDatePicker(
                    context: context,
                    initialDate: _fecha,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                  );
                  if (d != null) setState(() => _fecha = d);
                },
                borderRadius: BorderRadius.circular(12),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Fecha',
                    prefixIcon: Icon(Icons.calendar_today_rounded),
                  ),
                  child: Text(
                    '${_fecha.day.toString().padLeft(2, '0')}/${_fecha.month.toString().padLeft(2, '0')}/${_fecha.year}',
                  ),
                ),
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () async {
                  final t = await showTimePicker(context: context, initialTime: _hora);
                  if (t != null) setState(() => _hora = t);
                },
                borderRadius: BorderRadius.circular(12),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Hora',
                    prefixIcon: Icon(Icons.access_time_rounded),
                  ),
                  child: Text(
                    '${_hora.hour.toString().padLeft(2, '0')}:${_hora.minute.toString().padLeft(2, '0')}',
                  ),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _loading ? null : _submit,
                  child: _loading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Text('Actualizar Cita'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
