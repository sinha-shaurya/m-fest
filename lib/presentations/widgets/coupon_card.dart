import 'package:aash_india/utils/date_formatter.dart';
import 'package:flutter/material.dart';

class CouponCard extends StatelessWidget {
  final int discountPercent;
  final String? id;
  final String title;
  final bool active;
  final String? buttonTitle;
  final Color? color;
  final String? subtitle;
  final VoidCallback? onTap;
  final int? price;
  final DateTime? validity;
  const CouponCard({
    required this.title,
    this.subtitle,
    this.onTap,
    this.buttonTitle,
    this.id,
    this.price,
    this.color,
    this.validity,
    this.active = true,
    required this.discountPercent,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final Color cardColor =
        active ? (color ?? Color(0xFF880E4F)) : Colors.grey.shade700;

    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        children: [
          Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: cardColor,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '$discountPercent%\nOFF',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: cardColor,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      subtitle ?? "ADMIT ONE",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(Icons.calendar_today,
                            color: Colors.black54, size: 16),
                        const SizedBox(width: 5),
                        Text(
                          formatValidityDate(validity ?? DateTime.now()),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        ElevatedButton.icon(
                          onPressed: onTap,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: cardColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          icon: Icon(Icons.remove_red_eye,
                              color: Colors.white, size: 18),
                          label: Text(
                            buttonTitle ?? 'view',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
              decoration: BoxDecoration(
                color: Colors.grey.shade700,
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: const Text(
                'Electronics',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
