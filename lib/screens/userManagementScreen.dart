import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserManagementScreen extends StatelessWidget {
  const UserManagementScreen({super.key});

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
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('usuarios').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final users = snapshot.data?.docs ?? [];
          if (users.isEmpty) {
            return const Center(child: Text('No hay usuarios registrados.'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: users.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final user = users[index];
              final data = user.data();
              final isDoctor = data['esDoctor'] == true;
              final isAdmin = data['admin'] == true;
              return Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(
                        isDoctor ? Icons.medical_services : Icons.person,
                        color: isDoctor ? Colors.green : Colors.grey,
                      ),
                      title: Text(
                        data['nombre']?.toString().isNotEmpty == true
                            ? data['nombre']
                            : data['email'] ?? 'Sin nombre',
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Email: ${data['email'] ?? ''}'),
                          Text('Doctor: ${isDoctor ? 'Sí' : 'No'}'),
                          if (isAdmin)
                            const Text(
                              'Administrador',
                              style: TextStyle(
                                color: Colors.amber,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                        ],
                      ),
                      trailing: isAdmin
                          ? null
                          : Switch(
                              value: isDoctor,
                              activeColor: Colors.green,
                              onChanged: (val) async {
                                await FirebaseFirestore.instance
                                    .collection('usuarios')
                                    .doc(user.id)
                                    .update({'esDoctor': val});
                              },
                            ),
                    ),
                    if (isDoctor && !isAdmin)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Row(
                          children: [
                            const Text(
                              'Especialidad:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: DropdownButton<String>(
                                value: data['especialidad'] ?? 'cardiologia',
                                items: const [
                                  DropdownMenuItem(
                                    value: 'cardiologia',
                                    child: Text('Cardiología'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'neurologia',
                                    child: Text('Neurología'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'pediatria',
                                    child: Text('Pediatría'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'podologia',
                                    child: Text('Podología'),
                                  ),
                                ],
                                onChanged: (val) async {
                                  if (val != null) {
                                    await FirebaseFirestore.instance
                                        .collection('usuarios')
                                        .doc(user.id)
                                        .update({'especialidad': val});
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
