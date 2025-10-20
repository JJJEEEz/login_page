# DoctorAppointmentApp 🏥

## Descripción
DoctorAppointmentApp es una aplicación móvil desarrollada en Flutter que facilita la gestión de citas médicas, permitiendo a los usuarios conectarse con profesionales de la salud de manera eficiente y segura.

## Características Principales ✨

### 1. **Autenticación de Usuarios**
- Login con correo electrónico y contraseña
- Creación de nuevas cuentas
- Recuperación de contraseña
- Autenticación segura con Firebase Auth
- Persistencia de sesión

### 2. **Pantalla Principal (Home)**
- Mensaje de bienvenida personalizado con nombre de usuario
- Búsqueda de especialistas y servicios
- Dos widgets principales:
  - **Agendar una Cita**: Para programar consultas médicas
  - **Consejos Médicos**: Recomendaciones para dolores leves
- Lista de 5 especialidades médicas:
  - Cardiología
  - Neurología
  - Pediatría
  - Oftalmología
  - Dermatología
- Sección de doctores destacados con calificaciones
- Navegación mediante barra inferior

### 3. **Pantalla de Mensajes**
- Interfaz de mensajería (en desarrollo)
- Vista previa de conversaciones con doctores
- Indicadores de mensajes no leídos
- Botón flotante para nuevo mensaje

### 4. **Pantalla de Configuración**
- **Perfil**: Gestión de información personal
- **Privacidad**: Políticas de privacidad y protección de datos
- **Sobre Nosotros**: Información de la aplicación
- **Cerrar Sesión**: Funcional con confirmación

### 5. **Pantalla de Perfil**
- Formulario editable con:
  - Nombre completo
  - Edad
  - Lugar de nacimiento
  - Padecimientos o condiciones médicas
- Guardado en Firebase Firestore
- Carga automática de datos guardados

## Estructura del Proyecto 📁

```
lib/
├── main.dart                    # Punto de entrada, configuración de rutas
├── firebase_options.dart        # Configuración de Firebase
└── screens/                     # Todas las pantallas de la app
    ├── login_screen.dart        # Pantalla de autenticación
    ├── home_screen.dart         # Pantalla principal
    ├── messages_screen.dart     # Pantalla de mensajes
    ├── settings_screen.dart     # Pantalla de configuración
    ├── profile_screen.dart      # Pantalla de perfil de usuario
    ├── privacy_screen.dart      # Información de privacidad
    └── about_screen.dart        # Información de la app
```

## Firebase - Colecciones de Firestore 🔥

### 1. Colección `usuarios`
Almacena la información personal de cada usuario.

**Estructura:**
```javascript
{
  "email": "usuario@ejemplo.com",
  "nombre": "Juan Pérez",
  "edad": 30,
  "lugarNacimiento": "Ciudad de México",
  "padecimientos": "Hipertensión",
  "fechaActualizacion": Timestamp
}
```

### 2. Colección `citas`
Guarda todas las citas programadas.

**Estructura (propuesta):**
```javascript
{
  "pacienteId": "uid_usuario",
  "medicoId": "uid_medico",
  "fecha": "2025-10-21",
  "hora": "10:00",
  "especialidad": "Cardiología",
  "motivoConsulta": "Revisión general",
  "estado": "programada", // programada, completada, cancelada
  "fechaCreacion": Timestamp
}
```

### 3. Colección `disponibilidad_medicos`
Controla la disponibilidad de horarios de los médicos.

**Estructura (propuesta):**
```javascript
{
  "medicoId": "uid_medico",
  "fecha": "2025-10-21",
  "horaInicio": "09:00",
  "horaFin": "10:00",
  "estaDisponible": true,
  "especialidad": "Cardiología"
}
```

## Tecnologías Utilizadas 🛠️

- **Flutter**: Framework de desarrollo multiplataforma
- **Firebase Authentication**: Autenticación de usuarios
- **Cloud Firestore**: Base de datos NoSQL en tiempo real
- **Material Design 3**: Sistema de diseño moderno

## Dependencias 📦

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  firebase_core: ^2.32.0
  firebase_auth: ^4.20.0
  cloud_firestore: ^4.17.0
```

## Instalación 🚀

### Prerrequisitos
- Flutter SDK instalado
- Android Studio / VS Code con extensiones de Flutter
- Cuenta de Firebase configurada

### Pasos de Instalación

1. **Clonar el repositorio**
```bash
git clone https://github.com/tuusuario/doctor-appointment-app.git
cd doctor-appointment-app
```

2. **Instalar dependencias**
```bash
flutter pub get
```

3. **Configurar Firebase**
```bash
flutterfire configure --project=tu-proyecto-firebase
```

4. **Ejecutar la aplicación**
```bash
flutter run
```

## Configuración de Firebase 🔐

### 1. Crear proyecto en Firebase Console
1. Ir a [Firebase Console](https://console.firebase.google.com/)
2. Crear un nuevo proyecto
3. Agregar aplicación Android/iOS

### 2. Habilitar Firebase Authentication
1. En Firebase Console, ir a Authentication
2. Habilitar método de inicio de sesión "Email/Password"

### 3. Configurar Cloud Firestore
1. En Firebase Console, ir a Firestore Database
2. Crear base de datos en modo de producción
3. Configurar reglas de seguridad:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Regla para usuarios
    match /usuarios/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Regla para citas
    match /citas/{citaId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null;
    }
    
    // Regla para disponibilidad de médicos
    match /disponibilidad_medicos/{disponibilidadId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null;
    }
  }
}
```

## Capturas de Pantalla 📸

### Pantalla de Login
- Formulario de inicio de sesión
- Opción de crear cuenta nueva
- Recuperación de contraseña

### Pantalla Principal
- Mensaje de bienvenida personalizado
- Widgets de servicios principales
- Lista de especialistas
- Doctores destacados
- Barra de navegación inferior

### Pantalla de Perfil
- Formulario editable
- Información médica personalizada
- Guardado en Cloud Firestore

### Pantalla de Configuración
- Opciones de cuenta
- Privacidad
- Información de la app
- Cerrar sesión

## Funcionalidades Pendientes 🔄

- [ ] Sistema completo de agendamiento de citas
- [ ] Chat en tiempo real con doctores
- [ ] Notificaciones push
- [ ] Historial de citas médicas
- [ ] Sistema de calificaciones
- [ ] Integración con pasarelas de pago
- [ ] Videollamadas con doctores
- [ ] Exportación de historial médico en PDF

## Mejoras Futuras 🚧

- Implementar tests unitarios y de integración
- Añadir modo oscuro
- Soporte multiidioma (español/inglés)
- Optimización de rendimiento
- Accesibilidad mejorada
- Integración con wearables

## Autor ✍️

**Tu Nombre**
- Email: tu.email@ejemplo.com
- Universidad: [Tu Universidad]
- Asignatura: [Nombre de la Asignatura]
- Cuatrimestre: [Número]
- Grupo: [Letra/Número]

## Referencias 📚

1. [Flutter Documentation](https://docs.flutter.dev)
2. [Firebase Authentication Docs](https://firebase.google.com/docs/auth)
3. [Cloud Firestore Documentation](https://firebase.google.com/docs/firestore)
4. [Material Design 3](https://m3.material.io/)
5. [Flutter Firebase Codelab](https://firebase.google.com/codelabs/firebase-get-to-know-flutter)

## Licencia 📄

Este proyecto fue desarrollado con fines educativos como parte de la Actividad #6.

---

**Nota**: Este es un proyecto académico desarrollado para demostrar la integración de Flutter con Firebase y la implementación de flujos de navegación en aplicaciones móviles.
