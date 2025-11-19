import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Usuario no autenticado')),
      );
    }

    // Streams para indicadores
    final totalCitasStream = FirebaseFirestore.instance
        .collection('citas')
        .where('emailDoctor', isEqualTo: user.email)
        .snapshots();

    final upcomingCitasStream = FirebaseFirestore.instance
        .collection('citas')
        .where('emailDoctor', isEqualTo: user.email)
        .snapshots();

    final pacientesUnicosStream = FirebaseFirestore.instance
        .collection('citas')
        .where('emailDoctor', isEqualTo: user.email)
        .snapshots()
        .map((snap) => snap.docs.map((d) => d['pacienteId']).toSet().length);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Médico'),
        backgroundColor: const Color(0xFF4A90E2),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8),
            Row(
              children: const [
                Icon(Icons.medical_services, color: Color(0xFF4A90E2)),
                SizedBox(width: 8),
                Text(
                  'Resumen',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Tarjetas con StreamBuilder
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 1.3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: [
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: StreamBuilder<QuerySnapshot>(
                        stream: totalCitasStream,
                        builder: (context, snapshot) {
                          final total = snapshot.data?.docs.length ?? 0;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.calendar_today,
                                size: 28,
                                color: Color(0xFF4A90E2),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Total de citas',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                total.toString(),
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),

                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: StreamBuilder<QuerySnapshot>(
                        stream: upcomingCitasStream,
                        builder: (context, snapshot) {
                          final upcomingCount = snapshot.data?.docs.length ?? 0;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.schedule,
                                size: 28,
                                color: Colors.orange,
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Próximas citas',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                upcomingCount.toString(),
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),

                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: StreamBuilder<int>(
                        stream: pacientesUnicosStream,
                        builder: (context, snapshot) {
                          final totalPac = snapshot.data ?? 0;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.person,
                                size: 28,
                                color: Colors.green,
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Pacientes (con cita)',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                totalPac.toString(),
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),

                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Icon(
                            Icons.insert_chart,
                            size: 28,
                            color: Colors.purple,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Actividad',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Ver detalles',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
