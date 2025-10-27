import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../components/firestore/saveAppointment.dart';

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({super.key});

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  String selectedEspecialidad = 'cardiologia';
  final especialidades = [
    'cardiologia',
    'neurologia',
    'pediatria',
    'podologia',
  ];

  // CRUD State
  String? editingAppointmentId;
  DateTime? editingFecha;
  String? editingHoraInicio;
  String? editingHoraFin;
  String? editingMotivo;
  String? editingDoctorEmail;
  String? editingPacienteEmail;
  String? editingAlergias;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A90E2),
        title: const Text('Medical Appointments'),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const Text(
                  'Specialty:',
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
          Expanded(child: _buildAppointmentCRUD()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateOrEditDialog(),
        child: const Icon(Icons.add),
        backgroundColor: const Color(0xFF4A90E2),
        tooltip: 'Create Appointment',
      ),
    );
  }

  Widget _buildAppointmentCRUD() {
    final user = FirebaseAuth.instance.currentUser;
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('citas')
          .where('emailPaciente', isEqualTo: user?.email ?? '')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final citas = snapshot.data?.docs ?? [];
        if (citas.isEmpty) {
          return const Center(child: Text('No appointments found.'));
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: citas.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final cita = citas[index];
            final data = cita.data();
            return Card(
              child: ListTile(
                leading: const Icon(
                  Icons.medical_services,
                  color: Colors.green,
                ),
                title: Text(data['motivo'] ?? 'No reason'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Doctor: ${data['emailDoctor'] ?? ''}'),
                    Text('Date: ${_formatDate(data['fecha'])}'),
                    Text('Start: ${data['hora'] ?? ''}'),
                    Text('End: ${data['horaFin'] ?? ''}'),
                    Text('Alergias: ${data['alergias'] ?? ''}'),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.orange),
                      onPressed: () =>
                          _showCreateOrEditDialog(editId: cita.id, data: data),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _confirmDelete(cita.id),
                    ),
                  ],
                ),
                onTap: () => _showDetailDialog(data),
              ),
            );
          },
        );
      },
    );
  }

  String _formatDate(dynamic fecha) {
    if (fecha is Timestamp) {
      final d = fecha.toDate();
      return '${d.day}/${d.month}/${d.year}';
    }
    return fecha?.toString() ?? '';
  }

  void _showCreateOrEditDialog({String? editId, Map<String, dynamic>? data}) {
    final motivoController = TextEditingController(text: data?['motivo'] ?? '');
    final alergiasController = TextEditingController(
      text: data?['alergias'] ?? '',
    );
    final horaController = TextEditingController(text: data?['hora'] ?? '');
    final horaFinController = TextEditingController(
      text: data?['horaFin'] ?? '',
    );
    DateTime? fechaSeleccionada = data?['fecha'] is Timestamp
        ? (data!['fecha'] as Timestamp).toDate()
        : null;
    final doctorController = TextEditingController(
      text: data?['emailDoctor'] ?? '',
    );
    final pacienteController = TextEditingController(
      text:
          data?['emailPaciente'] ??
          FirebaseAuth.instance.currentUser?.email ??
          '',
    );

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                editId == null ? 'Create Appointment' : 'Edit Appointment',
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: motivoController,
                      decoration: const InputDecoration(labelText: 'Reason'),
                    ),
                    TextField(
                      controller: alergiasController,
                      decoration: const InputDecoration(labelText: 'Alergias'),
                    ),
                    TextField(
                      controller: horaController,
                      decoration: const InputDecoration(
                        labelText: 'Start Time',
                      ),
                    ),
                    TextField(
                      controller: horaFinController,
                      decoration: const InputDecoration(labelText: 'End Time'),
                    ),
                    TextField(
                      controller: doctorController,
                      decoration: const InputDecoration(
                        labelText: 'Doctor Email',
                      ),
                    ),
                    TextField(
                      controller: pacienteController,
                      decoration: const InputDecoration(
                        labelText: 'Patient Email',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Text('Date:'),
                        const SizedBox(width: 8),
                        Text(
                          fechaSeleccionada == null
                              ? 'Not selected'
                              : '${fechaSeleccionada!.day}/${fechaSeleccionada!.month}/${fechaSeleccionada!.year}',
                        ),
                        IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: fechaSeleccionada ?? DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(
                                const Duration(days: 365),
                              ),
                            );
                            if (picked != null) {
                              setState(() {
                                fechaSeleccionada = picked;
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
                  child: const Text('Cancel'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                ElevatedButton(
                  child: Text(editId == null ? 'Create' : 'Update'),
                  onPressed: () async {
                    if (motivoController.text.isEmpty ||
                        alergiasController.text.isEmpty ||
                        horaController.text.isEmpty ||
                        horaFinController.text.isEmpty ||
                        doctorController.text.isEmpty ||
                        pacienteController.text.isEmpty ||
                        fechaSeleccionada == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Complete all fields.')),
                      );
                      return;
                    }
                    // Validar solapamiento
                    final overlap = await _checkOverlap(
                      fechaSeleccionada!,
                      horaController.text,
                      horaFinController.text,
                      editId,
                      doctorController.text,
                    );
                    if (overlap) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Time overlaps with another appointment.',
                          ),
                        ),
                      );
                      return;
                    }
                    final citaData = {
                      'motivo': motivoController.text,
                      'alergias': alergiasController.text,
                      'hora': horaController.text,
                      'horaFin': horaFinController.text,
                      'emailDoctor': doctorController.text,
                      'emailPaciente': pacienteController.text,
                      'fecha': Timestamp.fromDate(fechaSeleccionada!),
                      'especialidad': selectedEspecialidad,
                    };
                    if (editId == null) {
                      await FirebaseFirestore.instance
                          .collection('citas')
                          .add(citaData);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Appointment created.')),
                      );
                    } else {
                      await FirebaseFirestore.instance
                          .collection('citas')
                          .doc(editId)
                          .update(citaData);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Appointment updated.')),
                      );
                    }
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<bool> _checkOverlap(
    DateTime fecha,
    String horaInicio,
    String horaFin,
    String? editId,
    String doctorEmail,
  ) async {
    final citas = await FirebaseFirestore.instance
        .collection('citas')
        .where('emailDoctor', isEqualTo: doctorEmail)
        .where('fecha', isEqualTo: Timestamp.fromDate(fecha))
        .get();
    for (var doc in citas.docs) {
      if (editId != null && doc.id == editId) continue;
      final start = doc['hora'];
      final end = doc['horaFin'];
      if (_timeOverlap(horaInicio, horaFin, start, end)) {
        return true;
      }
    }
    return false;
  }

  bool _timeOverlap(String start1, String end1, String start2, String end2) {
    final s1 = _parseTime(start1);
    final e1 = _parseTime(end1);
    final s2 = _parseTime(start2);
    final e2 = _parseTime(end2);
    return s1.isBefore(e2) && s2.isBefore(e1);
  }

  TimeOfDay _parseTime(String time) {
    final parts = time.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  void _confirmDelete(String citaId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Appointment'),
        content: const Text(
          'Are you sure you want to delete this appointment?',
        ),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          ElevatedButton(
            child: const Text('Delete'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection('citas')
                  .doc(citaId)
                  .delete();
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Appointment deleted.')),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showDetailDialog(Map<String, dynamic> data) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Appointment Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Reason: ${data['motivo'] ?? ''}'),
            Text('Doctor: ${data['emailDoctor'] ?? ''}'),
            Text('Patient: ${data['emailPaciente'] ?? ''}'),
            Text('Date: ${_formatDate(data['fecha'])}'),
            Text('Start: ${data['hora'] ?? ''}'),
            Text('End: ${data['horaFin'] ?? ''}'),
            Text('Alergias: ${data['alergias'] ?? ''}'),
            Text('Specialty: ${data['especialidad'] ?? ''}'),
          ],
        ),
        actions: [
          TextButton(
            child: const Text('Close'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
