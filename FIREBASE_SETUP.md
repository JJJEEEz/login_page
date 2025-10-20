# Guía de Configuración de Firebase para DoctorAppointmentApp

## Paso 1: Configurar Firebase Console

### 1.1 Crear Proyecto Firebase
1. Ve a [Firebase Console](https://console.firebase.google.com/)
2. Haz clic en "Agregar proyecto"
3. Nombra tu proyecto (ej: "doctor-appointment-app")
4. Acepta los términos y crea el proyecto

### 1.2 Agregar Aplicación Android
1. En la consola de Firebase, haz clic en el ícono de Android
2. Ingresa el nombre del paquete: `com.example.login`
3. Descarga el archivo `google-services.json`
4. Coloca el archivo en: `android/app/google-services.json`

### 1.3 Agregar Aplicación iOS (opcional)
1. Haz clic en el ícono de iOS
2. Ingresa el Bundle ID: `com.example.login`
3. Descarga el archivo `GoogleService-Info.plist`
4. Coloca el archivo en: `ios/Runner/GoogleService-Info.plist`

## Paso 2: Habilitar Firebase Authentication

1. En Firebase Console, ve a **Authentication**
2. Haz clic en "Comenzar"
3. En la pestaña "Sign-in method", habilita:
   - ✅ **Correo electrónico/Contraseña**
4. Guarda los cambios

## Paso 3: Configurar Cloud Firestore

### 3.1 Crear Base de Datos
1. En Firebase Console, ve a **Firestore Database**
2. Haz clic en "Crear base de datos"
3. Selecciona "Comenzar en modo de producción"
4. Elige la ubicación (preferiblemente la más cercana)
5. Haz clic en "Habilitar"

### 3.2 Configurar Reglas de Seguridad
En la pestaña "Reglas", reemplaza el contenido con:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Permitir lectura y escritura solo si el usuario está autenticado
    match /{document=**} {
      allow read, write: if request.auth != null;
    }
    
    // Reglas específicas para usuarios
    match /usuarios/{userId} {
      // El usuario solo puede leer/escribir su propio documento
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Reglas para citas
    match /citas/{citaId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null;
      allow update, delete: if request.auth != null && 
                              (resource.data.pacienteId == request.auth.uid || 
                               resource.data.medicoId == request.auth.uid);
    }
    
    // Reglas para disponibilidad de médicos
    match /disponibilidad_medicos/{disponibilidadId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null;
    }
  }
}
```

Haz clic en "Publicar"

### 3.3 Crear Colecciones Iniciales

#### Colección: `usuarios`
Estructura de documento:
```json
{
  "email": "string",
  "nombre": "string",
  "edad": number,
  "lugarNacimiento": "string",
  "padecimientos": "string",
  "fechaActualizacion": timestamp
}
```

#### Colección: `citas`
Estructura de documento:
```json
{
  "pacienteId": "string (uid)",
  "medicoId": "string (uid)",
  "fecha": "string (YYYY-MM-DD)",
  "hora": "string (HH:MM)",
  "especialidad": "string",
  "motivoConsulta": "string",
  "estado": "string (programada|completada|cancelada)",
  "fechaCreacion": timestamp
}
```

#### Colección: `disponibilidad_medicos`
Estructura de documento:
```json
{
  "medicoId": "string (uid)",
  "fecha": "string (YYYY-MM-DD)",
  "horaInicio": "string (HH:MM)",
  "horaFin": "string (HH:MM)",
  "estaDisponible": boolean,
  "especialidad": "string"
}
```

## Paso 4: Configurar Firebase en Flutter

### 4.1 Instalar FlutterFire CLI
```bash
dart pub global activate flutterfire_cli
```

### 4.2 Configurar Firebase en el Proyecto
```bash
flutterfire configure --project=tu-proyecto-firebase
```

Esto generará automáticamente el archivo `firebase_options.dart`

### 4.3 Verificar Dependencias en pubspec.yaml
```yaml
dependencies:
  firebase_core: ^2.32.0
  firebase_auth: ^4.20.0
  cloud_firestore: ^4.17.0
```

### 4.4 Instalar Dependencias
```bash
flutter pub get
```

## Paso 5: Configuración Android Adicional

### 5.1 Modificar android/build.gradle
Agrega en la sección `dependencies`:
```gradle
classpath 'com.google.gms:google-services:4.4.0'
```

### 5.2 Modificar android/app/build.gradle
Al final del archivo, agrega:
```gradle
apply plugin: 'com.google.gms.google-services'
```

## Paso 6: Probar la Aplicación

### 6.1 Crear un Usuario de Prueba
1. Ejecuta la app: `flutter run`
2. Haz clic en "Crear una cuenta nueva"
3. Ingresa:
   - Email: `test@ejemplo.com`
   - Contraseña: `123456` (mínimo 6 caracteres)

### 6.2 Verificar en Firebase Console
1. Ve a **Authentication** → Pestaña "Users"
2. Deberías ver el usuario creado
3. Ve a **Firestore Database**
4. Completa el perfil en la app
5. Verifica que se cree un documento en la colección `usuarios`

## Solución de Problemas Comunes

### Error: "Default FirebaseApp is not initialized"
- Asegúrate de que `firebase_options.dart` existe
- Verifica que `main.dart` tenga: `await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);`

### Error: "google-services.json not found"
- Descarga el archivo desde Firebase Console
- Colócalo en `android/app/google-services.json`
- Ejecuta `flutter clean` y `flutter pub get`

### Error de permisos en Firestore
- Revisa las reglas de seguridad en Firebase Console
- Para desarrollo, puedes usar reglas más permisivas temporalmente:
```javascript
allow read, write: if request.auth != null;
```

### Error de compilación en Android
- Asegúrate de tener las siguientes versiones mínimas en `android/app/build.gradle`:
```gradle
minSdkVersion 21
compileSdkVersion 34
targetSdkVersion 34
```

## Datos de Prueba para Firestore

### Crear Médicos de Ejemplo
Puedes agregar manualmente en Firestore Console:

Colección: `medicos`
```json
{
  "nombre": "Dr. Juan Pérez",
  "especialidad": "Cardiología",
  "email": "juan.perez@hospital.com",
  "telefono": "+52 55 1234 5678",
  "calificacion": 4.9,
  "numeroResenas": 127,
  "disponible": true
}
```

### Crear Disponibilidad de Ejemplo
```json
{
  "medicoId": "uid_del_medico",
  "fecha": "2025-10-25",
  "horaInicio": "09:00",
  "horaFin": "10:00",
  "estaDisponible": true,
  "especialidad": "Cardiología"
}
```

## Comandos Útiles

```bash
# Limpiar el proyecto
flutter clean

# Obtener dependencias
flutter pub get

# Reconfigurar Firebase
flutterfire configure

# Ver logs de Android
flutter logs

# Ejecutar en modo debug
flutter run

# Construir APK
flutter build apk

# Construir release
flutter build apk --release
```

## Recursos Adicionales

- [Documentación de FlutterFire](https://firebase.flutter.dev/)
- [Firebase Authentication](https://firebase.google.com/docs/auth)
- [Cloud Firestore](https://firebase.google.com/docs/firestore)
- [Firebase Console](https://console.firebase.google.com/)

---

**Nota**: Este proyecto está configurado para usar Firebase en modo de producción con reglas de seguridad adecuadas. Asegúrate de mantener tus credenciales seguras y nunca compartas archivos de configuración sensibles públicamente.
