import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppointmentDialog extends StatefulWidget {
  final String doctorEmail;
  final String especialidad;

  const AppointmentDialog({
    super.key,
    required this.doctorEmail,
    required this.especialidad,
  });

  @override
  State<AppointmentDialog> createState() => _AppointmentDialogState();
}

class _AppointmentDialogState extends State<AppointmentDialog> {
  final motivoController = TextEditingController();
  final alergiasController = TextEditingController();

  DateTime? fechaSeleccionada;
  TimeOfDay? horaInicio;
  TimeOfDay? horaFin;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    fechaSeleccionada = now;
    // Por defecto, inicio = siguiente media hora aproximada
    horaInicio = _roundUpToNext30(TimeOfDay.fromDateTime(now));
    horaFin = _addMinutes(horaInicio!, 30);
  }

  TimeOfDay _roundUpToNext30(TimeOfDay t) {
    int m = t.minute;
    int add = m == 0 ? 30 : (m <= 30 ? 30 - m : 60 - m);
    final dt = DateTime(0, 0, 0, t.hour, t.minute).add(Duration(minutes: add));
    return TimeOfDay(hour: dt.hour % 24, minute: dt.minute);
  }

  TimeOfDay _addMinutes(TimeOfDay t, int minutes) {
    final dt = DateTime(
      0,
      0,
      0,
      t.hour,
      t.minute,
    ).add(Duration(minutes: minutes));
    return TimeOfDay(hour: dt.hour % 24, minute: dt.minute);
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: fechaSeleccionada ?? now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => fechaSeleccionada = picked);
  }

  Future<void> _pickStartTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: horaInicio ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        horaInicio = picked;
        horaFin = _addMinutes(picked, 30); // actualizar fin automáticamente
      });
    }
  }

  Future<void> _pickEndTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: horaFin ?? _addMinutes(TimeOfDay.now(), 30),
    );
    if (picked != null) setState(() => horaFin = picked);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Agendar cita'),
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
            const SizedBox(height: 12),
            Row(
              children: [
                const Text('Fecha:'),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    fechaSeleccionada == null
                        ? 'No seleccionada'
                        : '${fechaSeleccionada!.day}/${fechaSeleccionada!.month}/${fechaSeleccionada!.year}',
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: _pickDate,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text('Inicio:'),
                const SizedBox(width: 8),
                Expanded(child: Text(horaInicio?.format(context) ?? '--:--')),
                TextButton(
                  onPressed: _pickStartTime,
                  child: const Text('Cambiar'),
                ),
              ],
            ),
            Row(
              children: [
                const Text('Fin:'),
                const SizedBox(width: 8),
                Expanded(child: Text(horaFin?.format(context) ?? '--:--')),
                TextButton(
                  onPressed: _pickEndTime,
                  child: const Text('Cambiar'),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _saveAppointment,
          child: const Text('Guardar'),
        ),
      ],
    );
  }

  Future<void> _saveAppointment() async {
    if (motivoController.text.isEmpty ||
        horaInicio == null ||
        horaFin == null ||
        fechaSeleccionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa todos los campos.')),
      );
      return;
    }

    final pacienteEmail = FirebaseAuth.instance.currentUser?.email ?? '';
    final citaData = {
      'motivo': motivoController.text.trim(),
      'alergias': alergiasController.text.trim(),
      'hora':
          '${horaInicio!.hour.toString().padLeft(2, '0')}:${horaInicio!.minute.toString().padLeft(2, '0')}',
      'horaFin':
          '${horaFin!.hour.toString().padLeft(2, '0')}:${horaFin!.minute.toString().padLeft(2, '0')}',
      'emailDoctor': widget.doctorEmail,
      'emailPaciente': pacienteEmail,
      'fecha': Timestamp.fromDate(
        DateTime(
          fechaSeleccionada!.year,
          fechaSeleccionada!.month,
          fechaSeleccionada!.day,
        ),
      ),
      'especialidad': widget.especialidad,
    };

    // Verificar solapamiento básico para el doctor en la misma fecha
    final overlapQuery = await FirebaseFirestore.instance
        .collection('citas')
        .where('emailDoctor', isEqualTo: widget.doctorEmail)
        .where('fecha', isEqualTo: citaData['fecha'])
        .get();
    for (var doc in overlapQuery.docs) {
      final start = (doc.data()['hora'] ?? '') as String;
      final end = (doc.data()['horaFin'] ?? '') as String;
      if (_timeOverlap(
        citaData['hora'] as String,
        citaData['horaFin'] as String,
        start,
        end,
      )) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('El horario se solapa con otra cita.')),
        );
        return;
      }
    }

    await FirebaseFirestore.instance.collection('citas').add(citaData);
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cita agendada exitosamente.')),
    );
  }

  bool _timeOverlap(String start1, String end1, String start2, String end2) {
    TimeOfDay _parse(String s) {
      final parts = s.split(':');
      return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
    }

    final s1 = _parse(start1);
    final e1 = _parse(end1);
    final s2 = _parse(start2);
    final e2 = _parse(end2);
    final dt = DateTime.now();
    final a1 = DateTime(dt.year, dt.month, dt.day, s1.hour, s1.minute);
    final b1 = DateTime(dt.year, dt.month, dt.day, e1.hour, e1.minute);
    final a2 = DateTime(dt.year, dt.month, dt.day, s2.hour, s2.minute);
    final b2 = DateTime(dt.year, dt.month, dt.day, e2.hour, e2.minute);
    return a1.isBefore(b2) && a2.isBefore(b1);
  }

  @override
  void dispose() {
    motivoController.dispose();
    alergiasController.dispose();
    super.dispose();
  }
}
