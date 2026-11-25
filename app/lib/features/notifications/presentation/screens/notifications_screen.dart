import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const notifications = [
      ('Nouvelle demande disponible', 'Une nouvelle demande correspond à vos services.', Icons.assignment_outlined),
      ('Votre demande a été publiée', 'Les artisans de votre secteur peuvent maintenant vous répondre.', Icons.check_circle_outline),
      ('Nouveau message', 'Vous avez reçu un nouveau message dans une discussion.', Icons.chat_bubble_outline),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FC),
      appBar: AppBar(title: const Text('Notifications'), backgroundColor: Colors.white, elevation: 0),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: notifications.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final item = notifications[index];
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE2E8F0))),
            child: Row(children: [
              CircleAvatar(backgroundColor: const Color(0xFFEAF1FF), child: Icon(item.$3, color: const Color(0xFF1D55D9))),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(item.$1, style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF172033))),
                const SizedBox(height: 4),
                Text(item.$2, style: const TextStyle(color: Color(0xFF64748B))),
              ])),
              const SizedBox(width: 8),
              const Text('Récent', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
            ]),
          );
        },
      ),
    );
  }
}
