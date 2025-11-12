import 'package:flutter/material.dart';

class AppointmentModal extends StatefulWidget {
  final String? doctorEmail;
  final String? especialidad;
  final Function(Map<String, dynamic>) onSave;
  const AppointmentModal({
    super.key,
    this.doctorEmail,
    this.especialidad,
    required this.onSave,
  });

  @override
  State<AppointmentModal> createState() => _AppointmentModalState();
}

class _AppointmentModalState extends State<AppointmentModal> {
  final motivoController = TextEditingController();
  final alergiasController = TextEditingController();
  TimeOfDay? horaInicio;
  TimeOfDay? horaFin;
  DateTime? fechaSeleccionada;

  @override
  void dispose() {
    motivoController.dispose();
    alergiasController.dispose();
    super.dispose();
  }

  void _pickHoraInicio() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: horaInicio ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        horaInicio = picked;
        // Por defecto, horaFin es 30 min después
        final finMinutes = picked.minute + 30;
        final finHour = picked.hour + (finMinutes ~/ 60);
        final finMinute = finMinutes % 60;
        horaFin = TimeOfDay(hour: finHour, minute: finMinute);
      });
    }
  }

  void _pickHoraFin() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: horaFin ?? (horaInicio ?? TimeOfDay.now()),
    );
    if (picked != null) {
      setState(() {
        horaFin = picked;
      });
    }
  }

  void _pickFecha() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: fechaSeleccionada ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        fechaSeleccionada = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const Text(
              'Agendar cita',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (widget.doctorEmail != null)
              Text(
                'Doctor: ${widget.doctorEmail}',
                style: const TextStyle(fontSize: 16),
              ),
            if (widget.especialidad != null)
              Text(
                'Especialidad: ${widget.especialidad}',
                style: const TextStyle(fontSize: 16),
              ),
            const SizedBox(height: 16),
            TextField(
              controller: motivoController,
              decoration: const InputDecoration(labelText: 'Motivo'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: alergiasController,
              decoration: const InputDecoration(labelText: 'Alergias'),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: _pickHoraInicio,
                    child: AbsorbPointer(
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Hora inicio',
                          hintText: horaInicio != null
                              ? horaInicio!.format(context)
                              : '--:--',
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: _pickHoraFin,
                    child: AbsorbPointer(
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Hora fin',
                          hintText: horaFin != null
                              ? horaFin!.format(context)
                              : '--:--',
                        ),
                      ),
                    ),
                  ),
                ),
              ],
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
                  onPressed: _pickFecha,
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A90E2),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('Guardar cita'),
                onPressed: () {
                  if (motivoController.text.isEmpty ||
                      alergiasController.text.isEmpty ||
                      horaInicio == null ||
                      horaFin == null ||
                      fechaSeleccionada == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Completa todos los campos.'),
                      ),
                    );
                    return;
                  }
                  widget.onSave({
                    'motivo': motivoController.text,
                    'alergias': alergiasController.text,
                    'hora': horaInicio!.format(context),
                    'horaFin': horaFin!.format(context),
                    'fecha': fechaSeleccionada,
                    'doctorEmail': widget.doctorEmail,
                    'especialidad': widget.especialidad,
                  });
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
