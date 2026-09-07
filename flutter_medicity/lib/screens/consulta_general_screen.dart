import 'package:flutter/material.dart';
import '../models/consulta_general.dart';
import '../services/medicity_service.dart';
import '../utils/date_formatter.dart';

class ConsultaGeneralScreen extends StatefulWidget {
  const ConsultaGeneralScreen({super.key});

  @override
  State<ConsultaGeneralScreen> createState() => _ConsultaGeneralScreenState();
}

class _ConsultaGeneralScreenState extends State<ConsultaGeneralScreen> {
  final MedicityService _service = MedicityService();
  late Future<List<ConsultaGeneral>> _futureData;

  @override
  void initState() {
    super.initState();
    _futureData = _service.getConsultaGeneral();
  }

  void _refresh() => setState(() { _futureData = _service.getConsultaGeneral(); });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consulta General'),
        actions: [
          IconButton(
            onPressed: _refresh,
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Actualizar',
          ),
        ],
      ),
      body: FutureBuilder<List<ConsultaGeneral>>(
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
            return const _EmptyView(message: 'No hay datos de consulta');
          }
          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final item = data[index];
              return _ConsultaCard(item: item);
            },
          );
        },
      ),
    );
  }
}

class _ConsultaCard extends StatelessWidget {
  final ConsultaGeneral item;

  const _ConsultaCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          leading: CircleAvatar(
            radius: 18,
            backgroundColor: colorScheme.primaryContainer,
            foregroundColor: colorScheme.onPrimaryContainer,
            child: Text(
              '${item.num}',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
          title: Text(
            item.paciente,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          subtitle: Text(
            '${item.doctor} · ${item.especialidad}',
            style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
          ),
          children: [
            const Divider(),
            const SizedBox(height: 8),

            // — Paciente —
            _SectionLabel(label: 'Paciente'),
            const SizedBox(height: 4),
            _InfoRow(label: 'Nacimiento', value: DateFormatter.formatDate(item.fechaNacimiento)),
            _InfoRow(label: 'Dirección', value: item.direccion),
            _InfoRow(label: 'Ciudad', value: item.ciudadPaciente),
            const SizedBox(height: 8),

            // — Doctor —
            _SectionLabel(label: 'Doctor'),
            const SizedBox(height: 4),
            _InfoRow(label: 'Especialidad', value: item.especialidad),
            _InfoRow(label: 'Ciudad', value: item.ciudadDoctor),
            const SizedBox(height: 8),

            // — Cita —
            _SectionLabel(label: 'Cita'),
            const SizedBox(height: 4),
            _InfoRow(label: 'Fecha', value: DateFormatter.formatDate(item.fechahora)),
            _InfoRow(label: 'Hora', value: DateFormatter.formatTime(item.fechahora)),
            const SizedBox(height: 8),

            // — Diagnóstico —
            _SectionLabel(label: 'Diagnóstico'),
            const SizedBox(height: 4),
            _InfoRow(label: 'Descripción', value: item.descripcion),
            _InfoRow(label: 'Tratamiento', value: item.tratamiento),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;

  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: colorScheme.primary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.isNotEmpty ? value : '—',
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
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
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 13),
            ),
            const SizedBox(height: 20),
            FilledButton.tonalIcon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Reintentar'),
            ),
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
