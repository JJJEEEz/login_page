import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'
    show
        Colors,
        Icons; // usamos algunos colores/icones de Material para los ejemplos
import 'dart:ui' show Color;

// --- CONSTANTES DE COLOR ---
// Asumimos que estas constantes se definen en routes.dart (o están disponibles aquí)
const Color kCorporatePrimaryColor = Color(0xFF005691); // Azul Oscuro
const Color kCorporateAccentColor = Color(0xFF14B8A6); // Teal/Cyan

class _MessageData {
  final String name;
  final String message;
  final String time;
  final bool isUnread;
  final IconData avatarIcon;
  final Color avatarColor;

  _MessageData({
    required this.name,
    required this.message,
    required this.time,
    required this.isUnread,
    required this.avatarIcon,
    required this.avatarColor,
  });
}

class MessagesScreen2 extends StatefulWidget {
  const MessagesScreen2({super.key});

  @override
  State<MessagesScreen2> createState() => _MessagesScreen2State();
}

class _MessagesScreen2State extends State<MessagesScreen2> {
  bool _showOnlyUnread = false;

  @override
  Widget build(BuildContext context) {
    // Definición de datos de ejemplo actualizados (nombres y mensajes más neutros)
    final List<_MessageData> messages = [
      _MessageData(
        name: 'Clínica Central',
        message: 'Tu cita ha sido confirmada para el 12/11 a las 10:00.',
        time: '1:45 PM',
        isUnread: true,
        avatarIcon: Icons.person,
        avatarColor: Colors.indigo,
      ),
      _MessageData(
        name: 'Soporte DoctorApp',
        message: 'Hemos actualizado tu perfil correctamente.',
        time: '11:30 AM',
        isUnread: false,
        avatarIcon: Icons.person,
        avatarColor: Colors.green,
      ),
      _MessageData(
        name: 'Laboratorio Salud',
        message: 'Tus resultados están listos en la sección Documentos.',
        time: 'Ayer',
        isUnread: true,
        avatarIcon: Icons.person,
        avatarColor: Colors.blueGrey,
      ),
      _MessageData(
        name: 'Dra. S. Reyes',
        message: 'Por favor completa el cuestionario previo a tu cita.',
        time: 'Ayer',
        isUnread: false,
        avatarIcon: Icons.person,
        avatarColor: Colors.blue,
      ),
      _MessageData(
        name: 'Recordatorios',
        message: 'No olvides tu vacunación programada.',
        time: '2d atrás',
        isUnread: false,
        avatarIcon: Icons.person,
        avatarColor: Colors.purple,
      ),
      _MessageData(
        name: 'Bienvenida',
        message: 'Bienvenido a DoctorApp — completa tu perfil para empezar.',
        time: '2d atrás',
        isUnread: false,
        avatarIcon: Icons.person,
        avatarColor: Colors.grey,
      ),
    ];

    // Filtra los mensajes si el switch está activado
    final filteredMessages = _showOnlyUnread
        ? messages.where((msg) => msg.isUnread).toList()
        : messages;

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: CupertinoColors.systemBackground,
        border: Border(bottom: BorderSide(color: kCorporatePrimaryColor)),
        // título en blanco para buen contraste
        middle: const Text(
          'Mensajes',
          style: TextStyle(
            color: kCorporatePrimaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        // Añadimos un switch para filtrar
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('No leídos', style: TextStyle(fontSize: 12)),
            const SizedBox(width: 4),
            CupertinoSwitch(
              value: _showOnlyUnread,
              activeTrackColor: kCorporateAccentColor,
              onChanged: (bool value) {
                setState(() {
                  _showOnlyUnread = value;
                });
              },
            ),
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: CupertinoSearchTextField(
                placeholder: 'Buscar en mensajes',
                onChanged: (value) {
                  // Lógica de búsqueda aquí
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredMessages.length,
                itemBuilder: (context, index) {
                  final msg = filteredMessages[index];
                  return _buildMessageTile(context, msg);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageTile(BuildContext context, _MessageData data) {
    // Implementamos un tile compatible con Cupertino que reusa los colores definidos
    return GestureDetector(
      onTap: () {
        // navegar a la conversación o abrir detalle
        showCupertinoModalPopup(
          context: context,
          builder: (ctx) => CupertinoActionSheet(
            title: Text(data.name),
            message: Text(data.message),
            actions: [
              CupertinoActionSheetAction(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cerrar'),
              ),
            ],
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: CupertinoColors.systemBackground.resolveFrom(context),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: data.avatarColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Center(
                child: Icon(
                  CupertinoIcons.person_crop_circle_fill,
                  size: 28,
                  color: CupertinoColors.systemGrey,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.name,
                    style: TextStyle(
                      fontWeight: data.isUnread
                          ? FontWeight.w600
                          : FontWeight.w400,
                      color: data.isUnread
                          ? kCorporatePrimaryColor
                          : CupertinoColors.label.resolveFrom(context),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    data.message,
                    style: TextStyle(
                      color: CupertinoColors.secondaryLabel.resolveFrom(
                        context,
                      ),
                      fontSize: 13,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  data.time,
                  style: TextStyle(
                    fontSize: 12,
                    color: data.isUnread
                        ? kCorporateAccentColor
                        : CupertinoColors.secondaryLabel.resolveFrom(context),
                    fontWeight: data.isUnread
                        ? FontWeight.w600
                        : FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 8),
                if (data.isUnread)
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: kCorporateAccentColor,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
