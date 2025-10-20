# Documentación del Proyecto - DoctorAppointmentApp
## Actividad #6: Navegación entre pantallas

---

## 📱 Pantallas Implementadas

### 1. Pantalla de Login (Login Screen)

**Archivo:** `lib/screens/login_screen.dart`

#### Elementos Implementados:
- ✅ Campo de correo electrónico con validación
- ✅ Campo de contraseña con opción de mostrar/ocultar
- ✅ Botón "¿Olvidaste tu contraseña?" (funcional)
- ✅ Botón "Crear una cuenta nueva" (funcional)
- ✅ Botón "Iniciar sesión" (funcional)

#### Funcionalidad:
- Autenticación con Firebase Authentication
- Validación de formato de correo electrónico
- Validación de longitud de contraseña (mínimo 6 caracteres)
- Recuperación de contraseña por correo electrónico
- Creación de nuevas cuentas de usuario
- Navegación automática a Home después del login exitoso
- Manejo de errores con mensajes descriptivos

#### Diseño:
- Tema médico con icono de hospital
- Colores azules profesionales (#4A90E2)
- Campos con bordes redondeados
- Indicador de carga durante procesamiento
- Interfaz responsiva y moderna

---

### 2. Pantalla Principal (Home Screen)

**Archivo:** `lib/screens/home_screen.dart`

#### Elementos Implementados:

**Barra Superior:**
- Logo/título de la aplicación
- Icono de notificaciones

**Mensaje de Bienvenida:**
- ✅ "¡Hola, [Nombre de Usuario]! ¿En qué podemos ayudarte?"
- Extrae el nombre del email del usuario autenticado

**Widgets de Servicios:**
1. ✅ **Agendar una Cita**
   - Icono de calendario
   - Color azul (#4A90E2)
   - Al hacer clic muestra mensaje (preparado para implementación futura)

2. ✅ **Consejos Médicos**
   - Icono de salud
   - Color verde (#66BB6A)
   - Abre modal con consejos para dolores leves:
     * Dolor de cabeza
     * Resfriado común
     * Dolor muscular
     * Fiebre leve
     * Dolor de estómago

**Lista de Especialistas:**
- ✅ Cardiología (icono de corazón, color rojo)
- ✅ Neurología (icono de cerebro, color morado)
- ✅ Pediatría (icono de niño, color naranja)
- ✅ Oftalmología (icono de ojo, color azul)
- ✅ Dermatología (icono de cara, color rosa)

**Doctores Destacados:**
- Lista de 3 doctores con:
  * Nombre del doctor
  * Especialidad
  * Calificación (estrellas)
  * Número de reseñas
  * Botón de navegación

**Barra de Navegación Inferior:**
- ✅ Inicio (activa por defecto)
- ✅ Mensajes
- ✅ Configuración

#### Diseño:
- Header con degradado azul
- Barra de búsqueda
- Cards con sombras suaves
- Scroll vertical fluido
- Íconos personalizados por especialidad

---

### 3. Pantalla de Mensajes (Messages Screen)

**Archivo:** `lib/screens/messages_screen.dart`

#### Elementos Implementados:
- Lista de conversaciones con:
  * Avatar del contacto
  * Nombre del doctor/centro
  * Último mensaje
  * Hora/fecha del mensaje
  * Indicador de mensajes no leídos
- Botón flotante para nuevo mensaje
- Mensaje informativo: "Funcionalidad próximamente"

#### Diseño:
- Lista con cards para cada conversación
- Badges circulares para mensajes no leídos
- Icono de búsqueda en la barra superior
- Estilo consistente con el resto de la app

**Nota:** Esta pantalla no es funcional (como se requiere en las instrucciones), pero tiene la interfaz lista para implementación futura.

---

### 4. Pantalla de Configuración (Settings Screen)

**Archivo:** `lib/screens/settings_screen.dart`

#### Elementos Implementados:

**Información del Usuario:**
- Avatar circular
- Nombre extraído del email
- Email completo

**Sección "Cuenta":**
- ✅ **Perfil**
  * Icono: persona
  * Descripción: "Edita tu información personal"
  * Navega a ProfileScreen
  * ✅ FUNCIONAL

**Sección "Preferencias":**
- ✅ **Privacidad**
  * Icono: candado
  * Descripción: "Configuración de privacidad"
  * Navega a PrivacyScreen
  * ✅ FUNCIONAL

- ✅ **Sobre Nosotros**
  * Icono: información
  * Descripción: "Información de la aplicación"
  * Navega a AboutScreen
  * ✅ FUNCIONAL

**Sección "Sesión":**
- ✅ **Cerrar Sesión**
  * Icono: salir (color rojo)
  * Descripción: "Salir de tu cuenta"
  * Muestra diálogo de confirmación
  * Cierra sesión con Firebase Auth
  * Navega de vuelta al Login
  * ✅ COMPLETAMENTE FUNCIONAL

**Footer:**
- Número de versión (1.0.0)

#### Diseño:
- Cards separadas por sección
- Íconos con fondos de color suave
- Flechas de navegación a la derecha
- Diálogo de confirmación para logout

---

### 5. Pantalla de Perfil (Profile Screen)

**Archivo:** `lib/screens/profile_screen.dart`

#### Formulario Implementado:
- ✅ **Nombre completo**
  * Validación: campo requerido
  * Placeholder: "Ej: Juan Pérez García"

- ✅ **Edad**
  * Validación: número válido (0-120)
  * Teclado numérico
  * Placeholder: "Ej: 25"

- ✅ **Lugar de nacimiento**
  * Validación: campo requerido
  * Placeholder: "Ej: Ciudad de México"

- ✅ **Padecimientos o condiciones médicas**
  * Campo de texto multilínea (4 líneas)
  * Opcional
  * Placeholder: "Describe cualquier condición médica relevante..."

#### Funcionalidad:
- ✅ Carga automática de datos guardados desde Firestore
- ✅ Validación completa del formulario
- ✅ Guardado en Firebase Firestore
- ✅ Indicador de carga durante guardado
- ✅ Mensajes de éxito/error
- ✅ Actualización con timestamp

#### Integración con Firebase:
```javascript
Colección: usuarios/{userId}
{
  "email": "usuario@ejemplo.com",
  "nombre": "Juan Pérez",
  "edad": 25,
  "lugarNacimiento": "Ciudad de México",
  "padecimientos": "Ninguno",
  "fechaActualizacion": Timestamp
}
```

#### Diseño:
- Avatar circular con botón de cámara
- Campos con íconos descriptivos
- Botón "Guardar Cambios" destacado
- Mensaje informativo sobre el uso de datos

---

### 6. Pantalla de Privacidad (Privacy Screen)

**Archivo:** `lib/screens/privacy_screen.dart`

#### Contenido Informativo:

**Secciones:**
1. **Política de Privacidad**
   - Compromiso con la protección de datos

2. **Información que Recopilamos**
   - Información de cuenta
   - Datos personales
   - Información médica
   - Datos de citas

3. **Uso de la Información**
   - Propósitos del uso de datos
   - Mejora de servicios
   - Comunicación médica

4. **Protección de Datos**
   - Encriptación
   - Autenticación segura
   - Acceso restringido

5. **Compartir Información**
   - Con quién se comparte
   - Casos específicos

6. **Tus Derechos**
   - Acceso a información
   - Corrección de datos
   - Eliminación de datos
   - Exportación de información

7. **Contacto**
   - Email y teléfono de contacto

#### Diseño:
- Cards organizadas por sección
- Íconos descriptivos
- Texto bien estructurado
- Banner de última actualización

---

### 7. Pantalla Sobre Nosotros (About Screen)

**Archivo:** `lib/screens/about_screen.dart`

#### Contenido Informativo:

**Secciones:**
1. **Logo y Versión**
   - Icono de hospital grande
   - Nombre de la app
   - Número de versión

2. **¿Quiénes Somos?**
   - Descripción de la aplicación
   - Misión

3. **Nuestra Misión**
   - Objetivos de la plataforma

4. **Nuestra Visión**
   - Aspiraciones futuras

5. **Valores**
   - Accesibilidad
   - Confianza
   - Innovación
   - Calidad
   - Empatía

6. **Características**
   - Lista de funcionalidades

7. **Nuestro Equipo**
   - Descripción del equipo

8. **Contáctanos**
   - Email, teléfono, sitio web
   - Íconos de redes sociales

#### Diseño:
- Logo centralizado
- Cards organizadas
- Íconos temáticos
- Sección de contacto destacada
- Footer con copyright

---

## 🔥 Integración con Firebase

### Firebase Authentication
- Login con email/contraseña
- Registro de nuevos usuarios
- Recuperación de contraseña
- Persistencia de sesión
- Cierre de sesión

### Cloud Firestore

#### Colección: `usuarios`
**Propósito:** Almacenar información personal de usuarios

**Campos:**
- `email`: String - Correo del usuario
- `nombre`: String - Nombre completo
- `edad`: Number - Edad del usuario
- `lugarNacimiento`: String - Lugar de nacimiento
- `padecimientos`: String - Condiciones médicas
- `fechaActualizacion`: Timestamp - Última actualización

**Operaciones:**
- ✅ Lectura al cargar perfil
- ✅ Escritura al guardar perfil
- ✅ Actualización con merge

#### Colección: `citas` (Preparada para uso futuro)
**Propósito:** Gestionar citas médicas

**Campos propuestos:**
- `pacienteId`: String (UID)
- `medicoId`: String (UID)
- `fecha`: String (YYYY-MM-DD)
- `hora`: String (HH:MM)
- `especialidad`: String
- `motivoConsulta`: String
- `estado`: String (programada/completada/cancelada)
- `fechaCreacion`: Timestamp

#### Colección: `disponibilidad_medicos` (Preparada para uso futuro)
**Propósito:** Controlar horarios disponibles

**Campos propuestos:**
- `medicoId`: String (UID)
- `fecha`: String (YYYY-MM-DD)
- `horaInicio`: String (HH:MM)
- `horaFin`: String (HH:MM)
- `estaDisponible`: Boolean
- `especialidad`: String

---

## 🎨 Diseño y Estilo

### Paleta de Colores
- **Primario:** #4A90E2 (Azul médico)
- **Secundario:** #66BB6A (Verde salud)
- **Error:** #F44336 (Rojo)
- **Fondo:** #FAFAFA (Gris claro)
- **Cards:** #FFFFFF (Blanco)

### Tipografía
- **Títulos:** Bold, 18-32px
- **Subtítulos:** SemiBold, 14-16px
- **Cuerpo:** Regular, 12-14px

### Componentes
- Bordes redondeados (12px)
- Sombras suaves
- Íconos Material Design
- Espaciado consistente (16-24px)

---

## 📊 Flujo de Navegación

```
LoginScreen
    ↓ (después de login exitoso)
HomeScreen
    ├── Tab 1: HomeContent
    ├── Tab 2: MessagesScreen
    └── Tab 3: SettingsScreen
                    ├── ProfileScreen
                    │       └── Firebase Firestore
                    ├── PrivacyScreen
                    ├── AboutScreen
                    └── Logout → LoginScreen
```

---

## ✅ Cumplimiento de Requisitos

### Pantallas (4 requeridas)
1. ✅ Login del usuario
2. ✅ Pantalla principal (Home)
3. ✅ Pantalla de mensajes
4. ✅ Pantalla de configuración

### Elementos de Login (5 requeridos)
1. ✅ Campo para correo electrónico
2. ✅ Campo para contraseña
3. ✅ Botón "Olvidó su contraseña"
4. ✅ Botón "Crear una cuenta nueva"
5. ✅ Botón "Iniciar sesión"

### Pantalla Principal
- ✅ Mensaje de bienvenida: "¡Hola, [Nombre]! ¿En qué podemos ayudarte?"
- ✅ Widget "Agendar una Cita"
- ✅ Widget "Consejos médicos"
- ✅ Lista de 5 especialistas
- ✅ Sección de doctores
- ✅ Barra de navegación inferior (Inicio, Mensajes, Configuración)

### Pantalla de Mensajes
- ✅ Interfaz creada
- ✅ No funcional (como se requiere)

### Pantalla de Configuración
- ✅ Perfil (con formulario funcional)
- ✅ Privacidad (con texto informativo)
- ✅ Sobre Nosotros (con texto informativo)
- ✅ Logout (completamente funcional)

### Firebase
- ✅ Firebase Authentication configurado
- ✅ Cloud Firestore configurado
- ✅ Colección `usuarios` implementada y funcional
- ✅ Colecciones `citas` y `disponibilidad_medicos` documentadas

---

## 🚀 Instrucciones de Ejecución

1. **Clonar/Abrir proyecto**
```bash
cd "c:\Users\usuario\Desktop\Proyectos\Flutter\apps mobiles\login\login"
```

2. **Instalar dependencias**
```bash
flutter pub get
```

3. **Configurar Firebase** (si no está configurado)
```bash
flutterfire configure --project=tu-proyecto-firebase
```

4. **Ejecutar la aplicación**
```bash
flutter run
```

5. **Crear usuario de prueba**
- Email: `test@ejemplo.com`
- Contraseña: `123456`

---

## 📸 Capturas de Pantalla Sugeridas para el Documento PDF

### Para cada pantalla incluir:
1. **Vista completa de la pantalla**
2. **Elementos clave resaltados**
3. **Funcionalidad en acción**

### Capturas recomendadas:

**Login Screen:**
- Pantalla completa
- Validación de campos
- Creación de cuenta
- Recuperación de contraseña

**Home Screen:**
- Vista completa con bienvenida
- Widgets de servicios
- Lista de especialistas
- Doctores destacados
- Modal de consejos médicos

**Messages Screen:**
- Vista completa
- Lista de conversaciones

**Settings Screen:**
- Vista completa
- Cada sección expandida

**Profile Screen:**
- Formulario vacío
- Formulario llenado
- Guardado exitoso en Firestore

**Privacy Screen:**
- Vista completa scrolleada

**About Screen:**
- Vista completa scrolleada

**Firebase Console:**
- Authentication con usuarios
- Firestore con colección usuarios
- Reglas de seguridad

---

## 💡 Conclusión

Se ha implementado exitosamente una aplicación completa de citas médicas con:
- ✅ 4 pantallas principales funcionales
- ✅ Navegación fluida entre pantallas
- ✅ Integración completa con Firebase (Auth + Firestore)
- ✅ Diseño moderno y profesional inspirado en apps médicas
- ✅ Código limpio y bien estructurado
- ✅ Documentación completa

La aplicación cumple con todos los requisitos de la Actividad #6 y está lista para ser presentada.

---

**Fecha de entrega:** [Tu fecha]
**Estudiante:** [Tu nombre]
**Grupo:** [Tu grupo]
**Cuatrimestre:** [Tu cuatrimestre]
