import 'package:flutter/material.dart';

class CategoryItem extends StatelessWidget {
  final String name;
  final IconData icon;
  final bool isActive;
  final VoidCallback? onTap;
  const CategoryItem(
      {super.key,
      this.onTap,
      this.isActive = false,
      required this.name,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        width: 125,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isActive
                ? [
                    Color(0xFFa7c957),
                    Color(0xFF386641),
                  ]
                : [Colors.white, Colors.white],
          ),
          borderRadius: BorderRadius.circular(100),
          border:
              Border.all(color: isActive ? Colors.white : Colors.grey.shade400),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              name,
              style: TextStyle(
                color: isActive ? Colors.white : Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
