import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:async';

class GraphicsPage extends StatefulWidget {
  const GraphicsPage({super.key});

  @override
  State<GraphicsPage> createState() => _GraphicsPageState();
}

class _GraphicsPageState extends State<GraphicsPage> {
  late Future<Map<String, Map<String, int>>> citasPorDiaFuture;
  late Future<Map<String, int>> citasEstadoFuture;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    citasPorDiaFuture = _fetchCitasPorDia(user?.email ?? '');
    citasEstadoFuture = _fetchCitasPorEstado(user?.email ?? '');
  }

  Future<Map<String, Map<String, int>>> _fetchCitasPorDia(
    String doctorEmail,
  ) async {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day);
    final end = start.add(const Duration(days: 7));
    // Inicializa los mapas para programadas y canceladas
    final Map<String, int> programadas = {};
    final Map<String, int> canceladas = {};
    for (int i = 0; i <= 7; i++) {
      final date = start.add(Duration(days: i));
      final key =
          "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}";
      programadas[key] = 0;
      canceladas[key] = 0;
    }
    // Citas programadas
    final snapshot = await FirebaseFirestore.instance
        .collection('citas')
        .where('emailDoctor', isEqualTo: doctorEmail)
        .get();
    for (var doc in snapshot.docs) {
      final data = doc.data();
      if (data['fecha'] is Timestamp) {
        final d = (data['fecha'] as Timestamp).toDate();
        final dDay = DateTime(d.year, d.month, d.day);
        if (dDay.isBefore(start) || dDay.isAfter(end)) continue;
        final key =
            "${dDay.day.toString().padLeft(2, '0')}/${dDay.month.toString().padLeft(2, '0')}";
        if (programadas.containsKey(key)) {
          programadas[key] = (programadas[key] ?? 0) + 1;
        }
      }
    }
    // Citas canceladas
    final snapshotCanceladas = await FirebaseFirestore.instance
        .collection('citas canceladas')
        .where('emailDoctor', isEqualTo: doctorEmail)
        .get();
    for (var doc in snapshotCanceladas.docs) {
      final data = doc.data();
      if (data['fecha'] is Timestamp) {
        final d = (data['fecha'] as Timestamp).toDate();
        final dDay = DateTime(d.year, d.month, d.day);
        if (dDay.isBefore(start) || dDay.isAfter(end)) continue;
        final key =
            "${dDay.day.toString().padLeft(2, '0')}/${dDay.month.toString().padLeft(2, '0')}";
        if (canceladas.containsKey(key)) {
          canceladas[key] = (canceladas[key] ?? 0) + 1;
        }
      }
    }
    return {'programadas': programadas, 'canceladas': canceladas};
  }

  Future<Map<String, int>> _fetchCitasPorEstado(String doctorEmail) async {
    // Suma completadas y canceladas de ambas colecciones
    int completadas = 0;
    int canceladas = 0;
    // Citas activas
    final snapshot = await FirebaseFirestore.instance
        .collection('citas')
        .where('emailDoctor', isEqualTo: doctorEmail)
        .get();
    for (var doc in snapshot.docs) {
      final data = doc.data();
      final estado = (data['estado'] ?? 'completada').toString();
      if (estado == 'cancelada') {
        canceladas++;
      } else {
        completadas++;
      }
    }
    // Citas canceladas
    final snapshotCanceladas = await FirebaseFirestore.instance
        .collection('citas canceladas')
        .where('emailDoctor', isEqualTo: doctorEmail)
        .get();
    canceladas += snapshotCanceladas.docs.length;
    return {'Completadas': completadas, 'Canceladas': canceladas};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estadísticas de Citas'),
        backgroundColor: const Color(0xFF4A90E2),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Citas programadas por día (hoy y próximos 7 días)',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 12),
              FutureBuilder<Map<String, Map<String, int>>>(
                future: citasPorDiaFuture,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final data = snapshot.data!;
                  final programadas = data['programadas']!;
                  final canceladas = data['canceladas']!;
                  final keys = programadas.keys.toList();
                  final maxY =
                      [
                        ...programadas.values,
                        ...canceladas.values,
                      ].fold<int>(1, (prev, e) => e > prev ? e : prev) +
                      1;
                  return SizedBox(
                    height: 220,
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: maxY.toDouble(),
                        barTouchData: BarTouchData(enabled: true),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: true),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                final idx = value.toInt();
                                if (idx < 0 || idx >= keys.length)
                                  return const SizedBox.shrink();
                                return Text(
                                  keys[idx],
                                  style: const TextStyle(fontSize: 10),
                                );
                              },
                              reservedSize: 32,
                            ),
                          ),
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        barGroups: List.generate(
                          keys.length,
                          (idx) => BarChartGroupData(
                            x: idx,
                            barRods: [
                              BarChartRodData(
                                toY: programadas[keys[idx]]!.toDouble(),
                                color: const Color(0xFF4A90E2),
                                width: 14,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              BarChartRodData(
                                toY: canceladas[keys[idx]]!.toDouble(),
                                color: Colors.red,
                                width: 14,
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 32),
              const Text(
                'Citas completadas vs canceladas',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 12),
              FutureBuilder<Map<String, int>>(
                future: citasEstadoFuture,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final data = snapshot.data!;
                  final total = data.values.fold(0, (a, b) => a + b);
                  if (total == 0) {
                    return const Text('No hay datos de citas.');
                  }
                  return SizedBox(
                    height: 220,
                    child: PieChart(
                      PieChartData(
                        sections: [
                          PieChartSectionData(
                            value: data['Completadas']!.toDouble(),
                            color: Colors.green,
                            title: 'Completadas',
                            radius: 60,
                            titleStyle: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          PieChartSectionData(
                            value: data['Canceladas']!.toDouble(),
                            color: Colors.red,
                            title: 'Canceladas',
                            radius: 60,
                            titleStyle: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                        sectionsSpace: 4,
                        centerSpaceRadius: 40,
                        pieTouchData: PieTouchData(enabled: true),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              const Text(
                'Leyenda:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: const [
                  Icon(Icons.square, color: Color(0xFF4A90E2)),
                  SizedBox(width: 6),
                  Text('Mes (barra)'),
                  SizedBox(width: 16),
                  Icon(Icons.circle, color: Colors.green),
                  SizedBox(width: 6),
                  Text('Completadas'),
                  SizedBox(width: 16),
                  Icon(Icons.circle, color: Colors.red),
                  SizedBox(width: 6),
                  Text('Canceladas'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
