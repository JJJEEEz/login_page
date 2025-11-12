import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:login/screens/appointment_screen.dart';
import 'doctor_detail_modal.dart';

class SpecialistDoctorListModal extends StatelessWidget {
  final String especialidad;
  const SpecialistDoctorListModal({super.key, required this.especialidad});

  @override
  Widget build(BuildContext context) {
    // Descripciones de especialidades
    final Map<String, String> descripciones = {
      'cardiologia':
          'La cardiología se encarga del estudio y tratamiento de las enfermedades del corazón y el sistema circulatorio.',
      'neurologia':
          'La neurología estudia y trata los trastornos del sistema nervioso, como el cerebro y la médula espinal.',
      'pediatria':
          'La pediatría se dedica a la salud y el bienestar de los niños desde el nacimiento hasta la adolescencia.',
      'oftalmologia':
          'La oftalmología trata las enfermedades y problemas de los ojos y la visión.',
      'dermatologia':
          'La dermatología se especializa en el diagnóstico y tratamiento de enfermedades de la piel, cabello y uñas.',
      // Puedes agregar más especialidades aquí
    };
    final especialidadKey = especialidad
        .toLowerCase()
        .replaceAll('í', 'i')
        .replaceAll('á', 'a')
        .replaceAll('é', 'e')
        .replaceAll('ó', 'o')
        .replaceAll('ú', 'u')
        .replaceAll('ñ', 'n');

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Doctores de $especialidad',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            descripciones[especialidadKey] ?? 'Especialidad médica.',
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          Flexible(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('usuarios')
                  .where('esDoctor', isEqualTo: true)
                  .where('especialidad', isEqualTo: especialidadKey)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                final doctors = snapshot.data?.docs ?? [];
                if (doctors.isEmpty) {
                  return const Center(
                    child: Text('No hay doctores para esta especialidad.'),
                  );
                }
                return ListView.separated(
                  itemCount: doctors.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final data = doctors[index].data();
                    return ListTile(
                      leading: const Icon(Icons.person, color: Colors.blue),
                      title: Text(
                        data['nombre'] ?? data['email'] ?? 'Sin nombre',
                      ),
                      subtitle: Text(data['email'] ?? ''),
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          builder: (context) => DoctorDetailModal(
                            doctorData: data,
                            onSchedule: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AppointmentScreen(),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
