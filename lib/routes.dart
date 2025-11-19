import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/appointment_screen.dart';
import 'screens/messages_screen2.dart';
import 'screens/settings_screen.dart';
import 'screens/register_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/dashboard_page.dart';
import 'screens/graphics_page.dart';

// Agrega aquí cualquier pantalla adicional que requiera rutas nombradas

class AppRoutes {
  static const String home = '/';
  static const String appointments = '/appointments';
  static const String messages = '/messages';
  static const String settings = '/settings';
  static const String register = '/register';
  static const String profile = '/profile';
  static const String dashboard = '/dashboard';
  static const String graphics = '/graphics';

  static Route<dynamic>? onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case appointments:
        return MaterialPageRoute(builder: (_) => const AppointmentScreen());
      case messages:
        return MaterialPageRoute(builder: (_) => const MessagesScreen2());
      case settings:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case dashboard:
        return MaterialPageRoute(builder: (_) => const DashboardPage());
      case graphics:
        return MaterialPageRoute(builder: (_) => const GraphicsPage());
      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Ruta no encontrada'))),
        );
    }
  }

  static Map<String, WidgetBuilder> get routes => {
    home: (_) => const HomeScreen(),
    appointments: (_) => const AppointmentScreen(),
    messages: (_) => const MessagesScreen2(),
    settings: (_) => const SettingsScreen(),
    register: (_) => const RegisterScreen(),
    profile: (_) => const ProfileScreen(),
    dashboard: (_) => const DashboardPage(),
    graphics: (_) => const GraphicsPage(),
  };
}
