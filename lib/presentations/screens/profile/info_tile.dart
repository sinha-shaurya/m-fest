import 'package:flutter/material.dart';

class InfoTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  const InfoTile(
      {required this.icon,
      required this.label,
      required this.value,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon),
          title: Text(
            label,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
          ),
          trailing: SizedBox(
            width: 150,
            child: Text(
              value,
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ),
        const Divider(),
      ],
    );
  }
}
