import 'package:flutter/material.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

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
          'Privacidad',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF4A90E2).withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.shield_outlined,
                    size: 48,
                    color: Color(0xFF4A90E2),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'Tu privacidad es nuestra prioridad',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4A90E2),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            _buildSection(
              title: 'Política de Privacidad',
              content:
                  'En DoctorAppointmentApp, nos comprometemos a proteger tu privacidad y la seguridad de tus datos personales. Esta política describe cómo recopilamos, usamos y protegemos tu información.',
            ),

            _buildSection(
              title: 'Información que Recopilamos',
              content:
                  '• Información de cuenta: correo electrónico y contraseña\n'
                  '• Datos personales: nombre, edad, lugar de nacimiento\n'
                  '• Información médica: padecimientos y condiciones de salud\n'
                  '• Datos de citas: historial de citas médicas',
            ),

            _buildSection(
              title: 'Uso de la Información',
              content:
                  'Utilizamos tu información para:\n'
                  '• Proporcionar y mejorar nuestros servicios\n'
                  '• Facilitar la comunicación con profesionales médicos\n'
                  '• Gestionar tus citas médicas\n'
                  '• Personalizar tu experiencia en la aplicación',
            ),

            _buildSection(
              title: 'Protección de Datos',
              content:
                  'Implementamos medidas de seguridad técnicas y organizativas para proteger tus datos:\n'
                  '• Encriptación de datos sensibles\n'
                  '• Autenticación segura con Firebase\n'
                  '• Acceso restringido a información médica\n'
                  '• Cumplimiento con normativas de protección de datos',
            ),

            _buildSection(
              title: 'Compartir Información',
              content:
                  'No compartimos tu información personal con terceros, excepto:\n'
                  '• Profesionales médicos autorizados para tu atención\n'
                  '• Cuando sea requerido por ley\n'
                  '• Con tu consentimiento explícito',
            ),

            _buildSection(
              title: 'Tus Derechos',
              content:
                  'Tienes derecho a:\n'
                  '• Acceder a tu información personal\n'
                  '• Corregir datos inexactos\n'
                  '• Solicitar la eliminación de tus datos\n'
                  '• Exportar tu información\n'
                  '• Revocar tu consentimiento en cualquier momento',
            ),

            _buildSection(
              title: 'Contacto',
              content:
                  'Si tienes preguntas sobre nuestra política de privacidad o el manejo de tus datos, contáctanos en:\n\n'
                  'Email: privacidad@doctorappointmentapp.com\n'
                  'Teléfono: +52 55 1234 5678',
            ),

            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange[300]!),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.update, color: Colors.orange[700]),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Última actualización: Octubre 2025\n\n'
                      'Nos reservamos el derecho de actualizar esta política. Te notificaremos sobre cambios importantes.',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required String content}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4A90E2),
            ),
          ),
          const SizedBox(height: 12),
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
}
