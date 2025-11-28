import 'package:flutter/material.dart';

class MenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const MenuTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: ListTile(
            leading: CircleAvatar(
              radius: 24,
              backgroundColor: const Color(0xFF1976D2).withOpacity(0.12),
              child: Icon(
                icon,
                size: 26,
                color: const Color(0xFF1976D2),
              ),
            ),

            title: Text(
              title,
              style: const TextStyle(
                color: Color(0xFF1976D2),
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),

            trailing: const Icon(
              Icons.chevron_right,
              color: Colors.grey,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }
}
