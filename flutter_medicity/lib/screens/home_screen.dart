import 'package:flutter/material.dart';
import 'consulta_general_screen.dart';
import 'doctor_screen.dart';
import 'paciente_screen.dart';
import 'diagnostico_screen.dart';
import 'cita_medica_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.local_hospital_rounded, color: colorScheme.primary),
            const SizedBox(width: 8),
            const Text('MediCity'),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          _SectionHeader(title: 'Consultas', icon: Icons.search_rounded),
          const SizedBox(height: 8),
          _MenuCard(
            icon: Icons.dashboard_rounded,
            title: 'Consulta General',
            subtitle: 'Vista completa de citas y diagnósticos',
            onTap: () => _navigate(context, const ConsultaGeneralScreen()),
          ),
          const SizedBox(height: 20),
          _SectionHeader(title: 'Gestión', icon: Icons.settings_rounded),
          const SizedBox(height: 8),
          _MenuCard(
            icon: Icons.medical_services_rounded,
            title: 'Doctores',
            subtitle: 'Administrar doctores y especialidades',
            onTap: () => _navigate(context, const DoctorScreen()),
          ),
          const SizedBox(height: 8),
          _MenuCard(
            icon: Icons.person_rounded,
            title: 'Pacientes',
            subtitle: 'Registro y actualización de pacientes',
            onTap: () => _navigate(context, const PacienteScreen()),
          ),
          const SizedBox(height: 8),
          _MenuCard(
            icon: Icons.assignment_rounded,
            title: 'Diagnósticos',
            subtitle: 'Descripción y tratamientos',
            onTap: () => _navigate(context, const DiagnosticoScreen()),
          ),
          const SizedBox(height: 8),
          _MenuCard(
            icon: Icons.calendar_month_rounded,
            title: 'Citas Médicas',
            subtitle: 'Programación y seguimiento',
            onTap: () => _navigate(context, const CitaMedicaScreen()),
          ),
        ],
      ),
    );
  }

  void _navigate(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;

  const _SectionHeader({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(icon, size: 18, color: colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
        ),
      ],
    );
  }
}

class _MenuCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _MenuCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: colorScheme.onPrimaryContainer, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: colorScheme.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}
