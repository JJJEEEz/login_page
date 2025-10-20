# Solución de Problemas - Error de Conexión Firestore

## ✅ Soluciones Implementadas

### 1. Manejo Mejorado de Errores Offline
**Archivo:** `lib/screens/profile_screen.dart`

Se agregó:
- Detección específica de error `unavailable` (sin conexión)
- UI con mensaje claro de error
- Botón "Reintentar" para volver a cargar datos
- Uso de `Source.serverAndCache` para intentar cache primero

### 2. Permisos de Android
**Archivo:** `android/app/src/main/AndroidManifest.xml`

Se agregaron los permisos necesarios:
```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
```

### 3. Configuración de Persistencia Firestore
**Archivo:** `lib/main.dart`

Se habilitó persistencia offline:
```dart
FirebaseFirestore.instance.settings = const Settings(
  persistenceEnabled: true,
  cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
);
```

## 🔍 Pasos para Solucionar el Error

### Si ejecutas en Android:

1. **Reconstruir la aplicación**
```bash
flutter clean
flutter pub get
flutter run
```

2. **Verificar conexión de red**
   - Asegúrate de que el emulador/dispositivo tenga acceso a Internet
   - Si usas emulador, verifica que la red del emulador esté activa
   - Prueba abrir el navegador en el dispositivo

3. **Verificar Firebase Console**
   - Ve a [Firebase Console](https://console.firebase.google.com/)
   - Verifica que Firestore esté habilitado
   - Revisa las reglas de seguridad

### Si ejecutas en Web (Chrome/Edge):

**IMPORTANTE:** La persistencia offline NO funciona igual en web. Debes:

1. **Habilitar modo persistente en navegador**
   - Abre DevTools (F12)
   - Ve a Application → Storage
   - Verifica que IndexedDB esté habilitado

2. **Ejecutar con flag específico**
```bash
flutter run -d chrome --web-browser-flag "--disable-web-security"
```

3. **Verificar configuración CORS**
   - Firebase web requiere configuración CORS adecuada
   - Verifica que el dominio esté autorizado en Firebase Console

### Configuración de Reglas de Firestore

Asegúrate de tener estas reglas en Firebase Console → Firestore → Reglas:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Permitir lectura/escritura si el usuario está autenticado
    match /usuarios/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    match /citas/{citaId} {
      allow read, write: if request.auth != null;
    }
    
    match /disponibilidad_medicos/{disponibilidadId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null;
    }
  }
}
```

## 🛠️ Solución de Problemas Específicos

### Error: "client is offline"

**Causa:** El dispositivo no puede conectarse a Firebase

**Soluciones:**
1. Verifica conexión a Internet
2. Si usas emulador:
   - Android: Settings → Network → Mobile data ON
   - iOS: Settings → Mobile Data → ON
3. Revisa firewall/antivirus que bloquee conexiones
4. Si usas proxy, configúralo en el emulador

### Error: "permission-denied"

**Causa:** Las reglas de Firestore bloquean el acceso

**Soluciones:**
1. Verifica que el usuario esté autenticado
2. Revisa las reglas en Firebase Console
3. Para desarrollo temporal, usa:
```javascript
allow read, write: if request.auth != null;
```

### Error: "Failed to get document"

**Causa:** Problema de red o documento no existe

**Soluciones:**
1. Verifica que el documento exista en Firestore Console
2. Usa el botón "Reintentar" en la app
3. Cierra y vuelve a abrir la app
4. Haz logout/login nuevamente

## 📱 Comandos Útiles

### Limpiar y reconstruir
```bash
flutter clean
flutter pub get
flutter run
```

### Ejecutar en dispositivo específico
```bash
# Listar dispositivos
flutter devices

# Ejecutar en Android
flutter run -d <device_id>

# Ejecutar en web
flutter run -d chrome
```

### Ver logs detallados
```bash
flutter run --verbose
```

### Verificar configuración Firebase
```bash
flutterfire configure
```

## 🔄 Flujo de Datos con Cache

Ahora la app funciona así:

1. **Primera carga:** Intenta obtener datos del servidor
2. **Éxito:** Guarda en cache local
3. **Sin conexión:** Usa datos del cache si existen
4. **Error:** Muestra mensaje con botón "Reintentar"
5. **Usuario hace clic en Reintentar:** Vuelve a intentar cargar

## ✅ Checklist de Verificación

Antes de ejecutar, asegúrate de:

- [ ] Firebase está configurado (`firebase_options.dart` existe)
- [ ] Firestore está habilitado en Firebase Console
- [ ] Reglas de seguridad están configuradas
- [ ] AndroidManifest.xml tiene permisos de Internet
- [ ] Has ejecutado `flutter clean` y `flutter pub get`
- [ ] El dispositivo/emulador tiene conexión a Internet
- [ ] Usuario está autenticado (ha hecho login)

## 🎯 Resultado Esperado

Después de aplicar estas soluciones:

1. ✅ La app puede cargar datos con conexión
2. ✅ La app usa cache cuando está offline
3. ✅ Muestra mensaje claro si no hay conexión
4. ✅ Permite reintentar carga de datos
5. ✅ No crashea por falta de conexión

## 📞 Contacto de Soporte

Si el problema persiste:
1. Revisa los logs completos: `flutter logs`
2. Verifica Firebase Console → Authentication y Firestore
3. Prueba crear un nuevo usuario
4. Verifica que `google-services.json` esté en `android/app/`

---

**Nota:** La app ahora maneja elegantemente los errores de conexión y permite trabajar offline con datos cacheados.
