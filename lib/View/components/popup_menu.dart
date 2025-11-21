import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

Widget buildPopupMenu(BuildContext context) {
  return PopupMenuButton<String>(
    onSelected: (value) async {
      switch (value) {
        case 'inicio':
          Navigator.pushReplacementNamed(context, '/inicio');
          break;

        case 'pacientes':
          Navigator.pushNamed(context, '/pacientes');
          break;

        case 'agenda':
          Navigator.pushNamed(context, '/agenda');
          break;

        case 'anotacoes':
          Navigator.pushNamed(context, '/anotacoes');
          break;

        case 'chat':
          Navigator.pushNamed(context, '/chat');
          break;

        case 'sobre':
          Navigator.pushNamed(context, '/sobre');
          break;

        case 'logout':
          await FirebaseAuth.instance.signOut();
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/login',
            (route) => false,
          );
          break;
      }
    },
    itemBuilder: (context) => [
      PopupMenuItem(
        value: 'inicio',
        child: Row(
          children: const [
            Icon(Icons.home),
            SizedBox(width: 10),
            Text('Início'),
          ],
        ),
      ),
      PopupMenuItem(
        value: 'pacientes',
        child: Row(
          children: const [
            Icon(Icons.people),
            SizedBox(width: 10),
            Text('Pacientes'),
          ],
        ),
      ),
      PopupMenuItem(
        value: 'agenda',
        child: Row(
          children: const [
            Icon(Icons.calendar_month),
            SizedBox(width: 10),
            Text('Agenda'),
          ],
        ),
      ),
      PopupMenuItem(
        value: 'anotacoes',
        child: Row(
          children: const [
            Icon(Icons.edit_note),
            SizedBox(width: 10),
            Text('Anotações'),
          ],
        ),
      ),
      PopupMenuItem(
        value: 'chat',
        child: Row(
          children: const [
            Icon(Icons.chat_bubble_outline),
            SizedBox(width: 10),
            Text('Chat'),
          ],
        ),
      ),
      PopupMenuItem(
        value: 'sobre',
        child: Row(
          children: const [
            Icon(Icons.info_outline),
            SizedBox(width: 10),
            Text('Sobre'),
          ],
        ),
      ),
      const PopupMenuDivider(),
      PopupMenuItem(
        value: 'logout',
        child: Row(
          children: const [
            Icon(Icons.logout, color: Colors.red),
            SizedBox(width: 10),
            Text('Sair', style: TextStyle(color: Colors.red)),
          ],
        ),
      ),
    ],
  );
}
