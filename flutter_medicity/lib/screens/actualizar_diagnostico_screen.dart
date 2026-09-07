import 'package:flutter/material.dart';
import '../models/diagnostico.dart';
import '../services/medicity_service.dart';

class ActualizarDiagnosticoScreen extends StatefulWidget {
  final int index;
  final Diagnostico diagnostico;

  const ActualizarDiagnosticoScreen({
    super.key,
    required this.index,
    required this.diagnostico,
  });

  @override
  State<ActualizarDiagnosticoScreen> createState() => _ActualizarDiagnosticoScreenState();
}

class _ActualizarDiagnosticoScreenState extends State<ActualizarDiagnosticoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _idCitaCtrl = TextEditingController();
  late final TextEditingController _nombreCtrl;
  late final TextEditingController _descripcionCtrl;
  late final TextEditingController _tratamientoCtrl;
  final _service = MedicityService();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _nombreCtrl = TextEditingController(text: widget.diagnostico.nombreDiagnostico);
    _descripcionCtrl = TextEditingController(text: widget.diagnostico.descripcion);
    _tratamientoCtrl = TextEditingController(text: widget.diagnostico.tratamiento);
  }

  @override
  void dispose() {
    _idCitaCtrl.dispose();
    _nombreCtrl.dispose();
    _descripcionCtrl.dispose();
    _tratamientoCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_loading) return;
    setState(() => _loading = true);
    try {
      final msg = await _service.actualizarDiagnostico(
        id: widget.index,
        idCita: int.parse(_idCitaCtrl.text),
        nombre: _nombreCtrl.text,
        descripcion: _descripcionCtrl.text,
        tratamiento: _tratamientoCtrl.text,
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
      appBar: AppBar(title: const Text('Actualizar Diagnóstico')),
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
                      child: const Icon(Icons.assignment_rounded, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.diagnostico.nombreDiagnostico,
                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.notes_rounded, size: 13, color: colorScheme.onSurfaceVariant),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  widget.diagnostico.descripcion,
                                  style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Icon(Icons.healing_rounded, size: 13, color: colorScheme.onSurfaceVariant),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  widget.diagnostico.tratamiento,
                                  style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
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
                controller: _idCitaCtrl,
                decoration: const InputDecoration(
                  labelText: 'ID Cita',
                  prefixIcon: Icon(Icons.tag_rounded),
                  helperText: 'Ingrese el número de la cita médica asociada',
                  helperMaxLines: 2,
                ),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || int.tryParse(v) == null ? 'Ingrese un número válido' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nombreCtrl,
                decoration: const InputDecoration(
                  labelText: 'Nombre del diagnóstico',
                  prefixIcon: Icon(Icons.assignment_outlined),
                ),
                textCapitalization: TextCapitalization.sentences,
                validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descripcionCtrl,
                decoration: const InputDecoration(
                  labelText: 'Descripción',
                  prefixIcon: Icon(Icons.notes_rounded),
                  alignLabelWithHint: true,
                ),
                maxLines: 3,
                textCapitalization: TextCapitalization.sentences,
                validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _tratamientoCtrl,
                decoration: const InputDecoration(
                  labelText: 'Tratamiento',
                  prefixIcon: Icon(Icons.healing_rounded),
                  alignLabelWithHint: true,
                ),
                maxLines: 3,
                textCapitalization: TextCapitalization.sentences,
                validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
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
                      : const Text('Actualizar Diagnóstico'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
