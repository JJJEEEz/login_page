import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../components/firestore/saveAppointment.dart';

class AgendarCitaScreen extends StatefulWidget {
  const AgendarCitaScreen({super.key});

  @override
  State<AgendarCitaScreen> createState() => _AgendarCitaScreenState();
}

class _AgendarCitaScreenState extends State<AgendarCitaScreen> {
  String selectedEspecialidad = 'cardiologia';
  final especialidades = [
    'cardiologia',
    'neurologia',
    'pediatria',
    'podologia',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A90E2),
        title: const Text(
          'Gestión de Usuarios',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const Text(
                  'Especialidad:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButton<String>(
                    value: selectedEspecialidad,
                    items: especialidades
                        .map(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: Text(e[0].toUpperCase() + e.substring(1)),
                          ),
                        )
                        .toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          selectedEspecialidad = val;
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('usuarios')
                  .where('esDoctor', isEqualTo: true)
                  .where('especialidad', isEqualTo: selectedEspecialidad)
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
                  padding: const EdgeInsets.all(16),
                  itemCount: doctors.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final doctor = doctors[index];
                    final data = doctor.data();
                    return Card(
                      child: ListTile(
                        leading: const Icon(
                          Icons.medical_services,
                          color: Colors.green,
                        ),
                        title: Text(
                          data['nombre'] ?? data['email'] ?? 'Sin nombre',
                        ),
                        subtitle: Text('Email: ${data['email'] ?? ''}'),
                        trailing: ElevatedButton(
                          child: const Text('Agendar cita'),
                          onPressed: () async {
                            await showDialog(
                              context: context,
                              builder: (context) {
                                final motivoController =
                                    TextEditingController();
                                final alergiasController =
                                    TextEditingController();
                                final horaController = TextEditingController();
                                DateTime? fechaSeleccionada;
                                return StatefulBuilder(
                                  builder: (context, setState) {
                                    return AlertDialog(
                                      title: const Text('Agendar cita'),
                                      content: SingleChildScrollView(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            TextField(
                                              controller: motivoController,
                                              decoration: const InputDecoration(
                                                labelText: 'Motivo',
                                              ),
                                            ),
                                            TextField(
                                              controller: alergiasController,
                                              decoration: const InputDecoration(
                                                labelText: 'Alergias',
                                              ),
                                            ),
                                            TextField(
                                              controller: horaController,
                                              decoration: const InputDecoration(
                                                labelText: 'Hora',
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Row(
                                              children: [
                                                const Text('Fecha:'),
                                                const SizedBox(width: 8),
                                                Text(
                                                  fechaSeleccionada == null
                                                      ? 'No seleccionada'
                                                      : '${fechaSeleccionada!.day}/${fechaSeleccionada!.month}/${fechaSeleccionada!.year}',
                                                ),
                                                IconButton(
                                                  icon: const Icon(
                                                    Icons.calendar_today,
                                                  ),
                                                  onPressed: () async {
                                                    final picked =
                                                        await showDatePicker(
                                                          context: context,
                                                          initialDate:
                                                              DateTime.now(),
                                                          firstDate:
                                                              DateTime.now(),
                                                          lastDate:
                                                              DateTime.now().add(
                                                                const Duration(
                                                                  days: 365,
                                                                ),
                                                              ),
                                                        );
                                                    if (picked != null) {
                                                      setState(() {
                                                        fechaSeleccionada =
                                                            picked;
                                                      });
                                                    }
                                                  },
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          child: const Text('Cancelar'),
                                          onPressed: () =>
                                              Navigator.of(context).pop(),
                                        ),
                                        ElevatedButton(
                                          child: const Text('Guardar'),
                                          onPressed: () async {
                                            if (motivoController.text.isEmpty ||
                                                alergiasController
                                                    .text
                                                    .isEmpty ||
                                                horaController.text.isEmpty ||
                                                fechaSeleccionada == null) {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                    'Completa todos los campos.',
                                                  ),
                                                ),
                                              );
                                              return;
                                            }
                                            final pacienteEmail =
                                                FirebaseAuth
                                                    .instance
                                                    .currentUser
                                                    ?.email ??
                                                '';
                                            await saveAppointment(
                                              emailPaciente: pacienteEmail,
                                              emailDoctor: data['email'],
                                              fecha: fechaSeleccionada!,
                                              hora: horaController.text,
                                              motivo: motivoController.text,
                                              alergias: alergiasController.text,
                                            );
                                            Navigator.of(context).pop();
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  'Cita agendada exitosamente.',
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ),
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
