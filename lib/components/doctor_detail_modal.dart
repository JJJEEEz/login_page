import 'package:flutter/material.dart';

class DoctorDetailModal extends StatelessWidget {
  final Map<String, dynamic> doctorData;
  final VoidCallback onSchedule;

  const DoctorDetailModal({
    super.key,
    required this.doctorData,
    required this.onSchedule,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: Colors.blue[100],
                child: const Icon(Icons.person, size: 32, color: Colors.blue),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctorData['nombre'] ??
                          doctorData['email'] ??
                          'Sin nombre',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      doctorData['especialidad'] ?? 'Sin especialidad',
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Email: ${doctorData['email'] ?? ''}',
            style: const TextStyle(fontSize: 14),
          ),
          if (doctorData['telefono'] != null)
            Text(
              'Teléfono: ${doctorData['telefono']}',
              style: const TextStyle(fontSize: 14),
            ),
          if (doctorData['descripcion'] != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                doctorData['descripcion'],
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
            ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.calendar_today),
              label: const Text('Agendar cita'),
              onPressed: onSchedule,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4A90E2),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
