import 'package:aash_india/core/constants/theme.dart';
import 'package:flutter/material.dart';

class CategoryItem extends StatelessWidget {
  final String name;
  final IconData icon;
  final bool isActive;

  const CategoryItem(
      {super.key,
      this.isActive = false,
      required this.name,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      padding: const EdgeInsets.all(10),
      width: 125,
      decoration: BoxDecoration(
        color: isActive ? AppColors.primaryColor : Colors.white,
        borderRadius: BorderRadius.circular(6),
        border:
            Border.all(color: isActive ? Colors.white : Colors.grey.shade400),
      ),
      child: Row(
        children: [
          Icon(icon,
              color: isActive ? Colors.white : appTheme(context).primaryColor),
          const SizedBox(width: 5),
          Text(name,
              style: TextStyle(
                  color:
                      isActive ? Colors.white : appTheme(context).primaryColor,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
