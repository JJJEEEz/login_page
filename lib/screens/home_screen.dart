import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'messages_screen2.dart';
import 'settings_screen.dart';
import 'appointment_screen.dart';
import '../components/doctor_detail_modal.dart';
import '../components/specialist_doctor_list_modal.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeContent(),
    const MessagesScreen2(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: const Color(0xFF4A90E2),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Mensajes'),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Configuración',
          ),
        ],
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  String _userName = 'Usuario';
  final Set<String> _dismissedDoctors =
      {}; // guarda doctores descartados por Dismissible

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final doc = await FirebaseFirestore.instance
            .collection('usuarios')
            .doc(user.uid)
            .get(const GetOptions(source: Source.serverAndCache));

        if (doc.exists && mounted) {
          final data = doc.data();
          if (data != null &&
              data['nombre'] != null &&
              data['nombre'].toString().isNotEmpty) {
            setState(() {
              _userName = data['nombre'];
            });
            return;
          }
        }
      } catch (e) {
        // Si hay error, usar fallback
        print('Error al cargar nombre: $e');
      }

      // Fallback: usar email sin dominio
      if (mounted) {
        setState(() {
          _userName = user.email?.split('@')[0] ?? 'Usuario';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A90E2),
        elevation: 0,
        title: const Text(
          'DoctorAppointmentApp',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: RefreshIndicator(
        displacement: 40,
        onRefresh: () async {
          // ejemplo simple: recargar nombre de usuario y mostrar snackbar
          setState(() {
            _dismissedDoctors.clear();
          });
          await _loadUserName();
          // asegurar que la UI refleje cualquier cambio del nombre
          if (mounted) setState(() {});
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Contenido actualizado')),
          );
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header con mensaje de bienvenida
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Color(0xFF4A90E2),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '¡Hola, $_userName!',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '¿En qué podemos ayudarte?',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                    const SizedBox(height: 20),

                    // Barra de búsqueda
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const TextField(
                        decoration: InputDecoration(
                          hintText: 'Buscar especialista o servicio...',
                          border: InputBorder.none,
                          icon: Icon(Icons.search, color: Colors.grey),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Servicios principales
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildServiceCard(
                        context,
                        icon: Icons.calendar_today,
                        title: 'Agendar una Cita',
                        color: const Color(0xFF4A90E2),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AppointmentScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildServiceCard(
                        context,
                        icon: Icons.health_and_safety,
                        title: 'Consejos Médicos',
                        color: const Color(0xFF66BB6A),
                        onTap: () {
                          _showMedicalTips(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Sección de Especialistas
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Especialistas',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              SizedBox(
                height: 120,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    _buildSpecialistCard(
                      icon: Icons.favorite,
                      name: 'Cardiología',
                      color: Colors.red[400]!,
                    ),
                    _buildSpecialistCard(
                      icon: Icons.psychology,
                      name: 'Neurología',
                      color: Colors.purple[400]!,
                    ),
                    _buildSpecialistCard(
                      icon: Icons.child_care,
                      name: 'Pediatría',
                      color: Colors.orange[400]!,
                    ),
                    _buildSpecialistCard(
                      icon: Icons.visibility,
                      name: 'Oftalmología',
                      color: Colors.blue[400]!,
                    ),
                    _buildSpecialistCard(
                      icon: Icons.face,
                      name: 'Dermatología',
                      color: Colors.pink[400]!,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Sección de Doctores Populares
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Doctores Destacados',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('usuarios')
                      .where('esDoctor', isEqualTo: true)
                      .limit(3)
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
                        child: Text('No hay doctores destacados.'),
                      );
                    }
                    return Column(
                      children: doctors.map((doc) {
                        final data = doc.data();
                        // si fue descartado previamente, no mostrarlo
                        if (_dismissedDoctors.contains(doc.id))
                          return const SizedBox.shrink();
                        return Column(
                          children: [
                            Dismissible(
                              key: Key(doc.id),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 20),
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.9),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                              onDismissed: (direction) {
                                setState(() {
                                  _dismissedDoctors.add(doc.id);
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      '${data['nombre'] ?? 'Doctor'} descartado',
                                    ),
                                    action: SnackBarAction(
                                      label: 'Deshacer',
                                      onPressed: () {
                                        setState(() {
                                          _dismissedDoctors.remove(doc.id);
                                        });
                                      },
                                    ),
                                  ),
                                );
                              },
                              child: InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(20),
                                      ),
                                    ),
                                    builder: (context) => DoctorDetailModal(
                                      doctorData: data,
                                      onSchedule: () {
                                        Navigator.pop(context);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                AppointmentScreen(),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                },
                                child: _buildDoctorCard(
                                  name:
                                      data['nombre'] ??
                                      data['email'] ??
                                      'Sin nombre',
                                  specialty:
                                      data['especialidad'] ??
                                      'Sin especialidad',
                                  rating: data['rating'] != null
                                      ? (data['rating'] as num).toDouble()
                                      : 0.0,
                                  reviews: data['reviews'] != null
                                      ? (data['reviews'] as num).toInt()
                                      : 0,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                          ],
                        );
                      }).toList(),
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServiceCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, size: 40, color: Colors.white),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecialistCard({
    required IconData icon,
    required String name,
    required Color color,
  }) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (context) => SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: SpecialistDoctorListModal(especialidad: name),
          ),
        );
      },
      child: Container(
        width: 120,
        margin: const EdgeInsets.only(right: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: Text(
                name,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDoctorCard({
    required String name,
    required String specialty,
    required double rating,
    required int reviews,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFF4A90E2).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.person, size: 32, color: Color(0xFF4A90E2)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  specialty,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star, size: 16, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(
                      '$rating ($reviews reseñas)',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showMedicalTips(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(24),
          child: ListView(
            controller: scrollController,
            children: [
              const Center(
                child: Icon(
                  Icons.health_and_safety,
                  size: 48,
                  color: Color(0xFF66BB6A),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Consejos Médicos',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              _buildTipCard(
                icon: Icons.water_drop,
                title: 'Dolor de cabeza',
                tip:
                    'Mantente hidratado, descansa en un lugar oscuro y silencioso. Si persiste, consulta a un médico.',
              ),
              _buildTipCard(
                icon: Icons.ac_unit,
                title: 'Resfriado común',
                tip:
                    'Descansa adecuadamente, bebe muchos líquidos y consume alimentos ricos en vitamina C.',
              ),
              _buildTipCard(
                icon: Icons.fitness_center,
                title: 'Dolor muscular',
                tip:
                    'Aplica hielo durante las primeras 48 horas, descansa el área afectada y mantén la zona elevada.',
              ),
              _buildTipCard(
                icon: Icons.local_fire_department,
                title: 'Fiebre leve',
                tip:
                    'Mantente hidratado, descansa y usa ropa ligera. Si supera los 38.5°C, consulta a un médico.',
              ),
              _buildTipCard(
                icon: Icons.restaurant,
                title: 'Dolor de estómago',
                tip:
                    'Come alimentos ligeros, evita lácteos y grasas. Si hay vómito persistente, busca atención médica.',
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange[300]!),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.orange[700],
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Si los síntomas persisten o empeoran, consulta a un profesional médico de inmediato.',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTipCard({
    required IconData icon,
    required String title,
    required String tip,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF66BB6A).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: const Color(0xFF66BB6A)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  tip,
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
