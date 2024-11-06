import 'package:aash_india/core/constants/theme.dart';
import 'package:flutter/material.dart';

class ShopCard extends StatelessWidget {
  final String shopName;
  final String city;
  final String state;
  final VoidCallback onTap;

  const ShopCard({
    super.key,
    required this.shopName,
    required this.city,
    required this.state,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      tileColor: Colors.white,
      title: Text(shopName),
      subtitle: Text('$city,$state'),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: Colors.pink.shade50,
        ),
        child: Icon(
          Icons.store,
          size: 32,
          color: AppColors.primaryColor,
        ),
      ),
    );
  }
}
