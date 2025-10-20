import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A90E2),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Sobre Nosotros',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Logo
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF4A90E2).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.local_hospital,
                size: 80,
                color: Color(0xFF4A90E2),
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'DoctorAppointmentApp',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4A90E2),
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Versión 1.0.0',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),

            const SizedBox(height: 32),

            _buildSection(
              icon: Icons.info_outline,
              title: '¿Quiénes Somos?',
              content:
                  'DoctorAppointmentApp es una aplicación innovadora diseñada para facilitar la conexión entre pacientes y profesionales de la salud. Nuestra misión es hacer que el acceso a la atención médica sea más simple, rápido y eficiente.',
            ),

            _buildSection(
              icon: Icons.flag_outlined,
              title: 'Nuestra Misión',
              content:
                  'Transformar la experiencia de atención médica mediante tecnología accesible, conectando a pacientes con los mejores profesionales de la salud y facilitando el proceso de agendar y gestionar citas médicas.',
            ),

            _buildSection(
              icon: Icons.visibility_outlined,
              title: 'Nuestra Visión',
              content:
                  'Ser la plataforma líder en gestión de citas médicas, reconocida por su innovación, confiabilidad y compromiso con la salud y bienestar de nuestros usuarios.',
            ),

            _buildSection(
              icon: Icons.star_outline,
              title: 'Valores',
              content:
                  '• Accesibilidad: Atención médica al alcance de todos\n'
                  '• Confianza: Protección de datos y privacidad\n'
                  '• Innovación: Mejora continua de nuestros servicios\n'
                  '• Calidad: Profesionales médicos certificados\n'
                  '• Empatía: Entendemos tus necesidades de salud',
            ),

            _buildSection(
              icon: Icons.featured_play_list_outlined,
              title: 'Características',
              content:
                  '• Búsqueda de especialistas por especialidad\n'
                  '• Agenda de citas en tiempo real\n'
                  '• Historial médico digitalizado\n'
                  '• Recordatorios de citas\n'
                  '• Consejos médicos de emergencia\n'
                  '• Mensajería con doctores\n'
                  '• Gestión de perfil personalizado',
            ),

            _buildSection(
              icon: Icons.groups_outlined,
              title: 'Nuestro Equipo',
              content:
                  'Somos un equipo multidisciplinario de desarrolladores, diseñadores y profesionales de la salud comprometidos con mejorar la experiencia de atención médica para todos.',
            ),

            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.email_outlined,
                    size: 40,
                    color: Color(0xFF4A90E2),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Contáctanos',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Email: contacto@doctorappointmentapp.com\n'
                    'Teléfono: +52 55 1234 5678\n'
                    'Sitio Web: www.doctorappointmentapp.com',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildSocialIcon(Icons.facebook),
                      _buildSocialIcon(Icons.alternate_email), // Twitter
                      _buildSocialIcon(Icons.camera_alt), // Instagram
                      _buildSocialIcon(Icons.language), // Website
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.favorite, color: Colors.red[400]),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Hecho con ❤️ para mejorar tu experiencia de atención médica',
                      style: TextStyle(fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            Text(
              '© 2025 DoctorAppointmentApp. Todos los derechos reservados.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF4A90E2).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: const Color(0xFF4A90E2), size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4A90E2),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF4A90E2).withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: const Color(0xFF4A90E2), size: 20),
    );
  }
}
