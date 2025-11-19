import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../components/appointment_dialog.dart';
import '../routes.dart';

class AppointmentScreen extends StatefulWidget {
  final String? especialidad;
  const AppointmentScreen({super.key, this.especialidad});

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  late String selectedEspecialidad;
  final especialidades = [
    'cardiologia',
    'neurologia',
    'pediatria',
    'podologia',
  ];

  @override
  void initState() {
    super.initState();
    selectedEspecialidad = widget.especialidad ?? 'cardiologia';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A90E2),
        title: const Text('Agenda de Citas Médicas'),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.grey[100],
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 24,
                    left: 20,
                    right: 20,
                    bottom: 8,
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search, color: Color(0xFF4A90E2)),
                      const SizedBox(width: 10),
                      const Text(
                        'Especialidad:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Color(0xFF4A90E2),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.15),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: selectedEspecialidad,
                                items: especialidades
                                    .map(
                                      (e) => DropdownMenuItem(
                                        value: e,
                                        child: Text(
                                          e[0].toUpperCase() + e.substring(1),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
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
                          ),
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
                          child: Text(
                            'No hay doctores para esta especialidad.',
                          ),
                        );
                      }
                      return ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: doctors.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final doctor = doctors[index];
                          final data = doctor.data();
                          return Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 12,
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: const Color(0xFF4A90E2),
                                  child: const Icon(
                                    Icons.medical_services,
                                    color: Colors.white,
                                  ),
                                ),
                                title: Text(
                                  data['nombre'] ??
                                      data['email'] ??
                                      'Sin nombre',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.email,
                                          size: 16,
                                          color: Colors.grey,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          data['email'] ?? '',
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      ],
                                    ),
                                    if (data['especialidad'] != null)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 2),
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.local_hospital,
                                              size: 16,
                                              color: Colors.grey,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              data['especialidad'],
                                              style: const TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                                trailing: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF4A90E2),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  icon: const Icon(Icons.event_available),
                                  label: const Text('Agendar'),
                                  onPressed: () async {
                                    await _mostrarDialogoCrearCita(
                                      data['email'],
                                    );
                                  },
                                ),
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
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF4A90E2),
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  icon: const Icon(Icons.calendar_today),
                  label: const Text(
                    'Tus citas',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(24),
                        ),
                      ),
                      builder: (context) => FractionallySizedBox(
                        heightFactor: 0.85,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 16.0,
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: 60,
                                height: 8,
                                margin: const EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                  color: Colors.grey[400],
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              const Text(
                                'Tus citas',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Expanded(child: _buildAppointmentCRUD()),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _mostrarDialogoCrearCita(String doctorEmail) async {
    // Mostrar el componente AppointmentDialog reusable
    await showDialog(
      context: context,
      builder: (_) => AppointmentDialog(
        doctorEmail: doctorEmail,
        especialidad: selectedEspecialidad,
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
          return const Center(child: Text('No tienes citas agendadas.'));
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
                title: Text(data['motivo'] ?? 'Sin motivo'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Doctor: ${data['emailDoctor'] ?? ''}'),
                    Text('Fecha: ${_formatDate(data['fecha'])}'),
                    Text('Inicio: ${data['hora'] ?? ''}'),
                    Text('Fin: ${data['horaFin'] ?? ''}'),
                    Text('Alergias: ${data['alergias'] ?? ''}'),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.orange),
                      onPressed: () => _mostrarDialogoEditarCita(cita.id, data),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _confirmarEliminarCita(cita.id),
                    ),
                  ],
                ),
                onTap: () => _mostrarDetalleCita(data),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _mostrarDialogoEditarCita(
    String editId,
    Map<String, dynamic> data,
  ) async {
    final motivoController = TextEditingController(text: data['motivo'] ?? '');
    final alergiasController = TextEditingController(
      text: data['alergias'] ?? '',
    );
    final horaController = TextEditingController(text: data['hora'] ?? '');
    final horaFinController = TextEditingController(
      text: data['horaFin'] ?? '',
    );
    DateTime? fechaSeleccionada = data['fecha'] is Timestamp
        ? (data['fecha'] as Timestamp).toDate()
        : null;
    final doctorEmail = data['emailDoctor'] ?? '';

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Editar cita'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: motivoController,
                      decoration: const InputDecoration(labelText: 'Motivo'),
                    ),
                    TextField(
                      controller: alergiasController,
                      decoration: const InputDecoration(labelText: 'Alergias'),
                    ),
                    TextField(
                      controller: horaController,
                      decoration: const InputDecoration(
                        labelText: 'Hora inicio (HH:mm)',
                      ),
                    ),
                    TextField(
                      controller: horaFinController,
                      decoration: const InputDecoration(
                        labelText: 'Hora fin (HH:mm)',
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
                  child: const Text('Cancelar'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                ElevatedButton(
                  child: const Text('Actualizar'),
                  onPressed: () async {
                    if (motivoController.text.isEmpty ||
                        alergiasController.text.isEmpty ||
                        horaController.text.isEmpty ||
                        horaFinController.text.isEmpty ||
                        fechaSeleccionada == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Completa todos los campos.'),
                        ),
                      );
                      return;
                    }
                    final overlap = await _checkOverlap(
                      fechaSeleccionada!,
                      horaController.text,
                      horaFinController.text,
                      editId,
                      doctorEmail,
                    );
                    if (overlap) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('El horario se solapa con otra cita.'),
                        ),
                      );
                      return;
                    }
                    final citaData = {
                      'motivo': motivoController.text,
                      'alergias': alergiasController.text,
                      'hora': horaController.text,
                      'horaFin': horaFinController.text,
                      'emailDoctor': doctorEmail,
                      'emailPaciente':
                          FirebaseAuth.instance.currentUser?.email ?? '',
                      'fecha': Timestamp.fromDate(fechaSeleccionada!),
                      'especialidad': selectedEspecialidad,
                    };
                    await FirebaseFirestore.instance
                        .collection('citas')
                        .doc(editId)
                        .update(citaData);
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Cita actualizada.')),
                    );
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

  void _confirmarEliminarCita(String citaId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar cita'),
        content: const Text('¿Estás seguro de que deseas cancelar esta cita?'),
        actions: [
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          ElevatedButton(
            child: const Text('Cancelar cita'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              final docRef = FirebaseFirestore.instance
                  .collection('citas')
                  .doc(citaId);
              final docSnap = await docRef.get();
              if (docSnap.exists) {
                final data = docSnap.data();
                await FirebaseFirestore.instance
                    .collection('citas canceladas')
                    .add(data!);
                await docRef.delete();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Cita cancelada y movida a "citas canceladas".',
                    ),
                  ),
                );
              } else {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('No se encontró la cita para cancelar.'),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  void _mostrarDetalleCita(Map<String, dynamic> data) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Detalle de la cita'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Motivo: ${data['motivo'] ?? ''}'),
            Text('Doctor: ${data['emailDoctor'] ?? ''}'),
            Text('Paciente: ${data['emailPaciente'] ?? ''}'),
            Text('Fecha: ${_formatDate(data['fecha'])}'),
            Text('Inicio: ${data['hora'] ?? ''}'),
            Text('Fin: ${data['horaFin'] ?? ''}'),
            Text('Alergias: ${data['alergias'] ?? ''}'),
            Text('Especialidad: ${data['especialidad'] ?? ''}'),
          ],
        ),
        actions: [
          TextButton(
            child: const Text('Cerrar'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  String _formatDate(dynamic fecha) {
    if (fecha is Timestamp) {
      final d = fecha.toDate();
      return '${d.day}/${d.month}/${d.year}';
    }
    return fecha?.toString() ?? '';
  }
}

// ...existing code...
