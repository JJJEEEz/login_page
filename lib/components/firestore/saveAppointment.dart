import 'package:cloud_firestore/cloud_firestore.dart';

/// Crea una nueva cita en la colección 'citas' de Firestore.
Future<void> saveAppointment({
  required String emailPaciente,
  required String emailDoctor,
  required DateTime fecha,
  required String hora,
  required String motivo,
  required String alergias,
  String? estado, // Ejemplo: 'pendiente', 'confirmada', 'cancelada'
  String? notas, // Notas adicionales
  String? tipoConsulta, // Ejemplo: 'presencial', 'virtual'
}) async {
  final data = <String, dynamic>{
    'emailPaciente': emailPaciente,
    'emailDoctor': emailDoctor,
    'fecha': Timestamp.fromDate(fecha),
    'hora': hora,
    'motivo': motivo,
    'alergias': alergias,
    'estado': estado ?? 'pendiente',
    'notas': notas ?? '',
    'tipoConsulta': tipoConsulta ?? 'presencial',
    'fechaCreacion': FieldValue.serverTimestamp(),
  };

  await FirebaseFirestore.instance.collection('citas').add(data);
}
