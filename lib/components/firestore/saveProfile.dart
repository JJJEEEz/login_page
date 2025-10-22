import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Guarda o actualiza el perfil del usuario en Firestore.
/// [profileData] debe contener los campos a guardar (nombre, edad, telefono, genero, lugarNacimiento, padecimientos).
/// Si [esDoctor] es distinto de null, se asigna ese valor (solo para registro).
Future<void> saveProfile({
  required String nombre,
  required String edad,
  required String telefono,
  required String genero,
  required String lugarNacimiento,
  required String padecimientos,
  bool? esDoctor,
  String? especialista,
}) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) throw Exception('Usuario no autenticado');

  final data = <String, dynamic>{
    'email': user.email,
    'nombre': nombre,
    'edad': edad,
    'telefono': telefono,
    'genero': genero,
    'lugarNacimiento': lugarNacimiento,
    'padecimientos': padecimientos,
    'fechaActualizacion': FieldValue.serverTimestamp(),
  };
  if (esDoctor != null) {
    data['esDoctor'] = esDoctor;
  }
  if (especialista != null) {
    data['especialista'] = especialista;
  }

  await FirebaseFirestore.instance
      .collection('usuarios')
      .doc(user.uid)
      .set(data, SetOptions(merge: true));
}
