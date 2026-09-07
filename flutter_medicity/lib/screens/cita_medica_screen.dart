import 'package:flutter/material.dart';
import '../models/cita_medica.dart';
import '../services/medicity_service.dart';
import '../utils/date_formatter.dart';
import 'actualizar_cita_screen.dart';

class CitaMedicaScreen extends StatefulWidget {
  const CitaMedicaScreen({super.key});

  @override
  State<CitaMedicaScreen> createState() => _CitaMedicaScreenState();
}

class _CitaMedicaScreenState extends State<CitaMedicaScreen> {
  final MedicityService _service = MedicityService();
  late Future<List<CitaMedica>> _futureData;

  @override
  void initState() {
    super.initState();
    _futureData = _service.getCitasMedicas();
  }

  void _refresh() => setState(() { _futureData = _service.getCitasMedicas(); });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Citas Médicas'),
        actions: [
          IconButton(
            onPressed: _refresh,
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Actualizar',
          ),
        ],
      ),
      body: FutureBuilder<List<CitaMedica>>(
        future: _futureData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return _ErrorView(
              message: '${snapshot.error}',
              onRetry: _refresh,
            );
          }
          final data = snapshot.data!;
          if (data.isEmpty) {
            return const _EmptyView(message: 'No hay citas registradas');
          }
          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final item = data[index];
              final fechaFormateada = DateFormatter.formatDate(item.fechaHora);
              final horaFormateada = DateFormatter.formatTime(item.fechaHora);

              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: colorScheme.primaryContainer,
                        foregroundColor: colorScheme.onPrimaryContainer,
                        child: const Icon(Icons.calendar_month_rounded, size: 20),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${item.paciente} → ${item.doctor}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(Icons.event_rounded, size: 14, color: colorScheme.onSurfaceVariant),
                                const SizedBox(width: 4),
                                Text(
                                  fechaFormateada,
                                  style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
                                ),
                                const SizedBox(width: 12),
                                Icon(Icons.access_time_rounded, size: 14, color: colorScheme.onSurfaceVariant),
                                const SizedBox(width: 4),
                                Text(
                                  horaFormateada,
                                  style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.edit_rounded,
                          size: 20,
                          color: colorScheme.primary,
                        ),
                        tooltip: 'Editar',
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ActualizarCitaScreen(
                                index: index + 1,
                                cita: item,
                              ),
                            ),
                          );
                          if (result == true) _refresh();
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline_rounded, size: 48, color: colorScheme.error),
            const SizedBox(height: 16),
            Text('Ocurrió un error', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center, style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 13)),
            const SizedBox(height: 20),
            FilledButton.tonalIcon(onPressed: onRetry, icon: const Icon(Icons.refresh_rounded, size: 18), label: const Text('Reintentar')),
          ],
        ),
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  final String message;

  const _EmptyView({required this.message});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inbox_rounded, size: 48, color: colorScheme.onSurfaceVariant),
            const SizedBox(height: 16),
            Text(message, style: TextStyle(color: colorScheme.onSurfaceVariant)),
          ],
        ),
      ),
    );
  }
}
