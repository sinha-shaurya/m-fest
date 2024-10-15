import 'package:aash_india/utils/date_formatter.dart';
import 'package:flutter/material.dart';

class CouponCard extends StatelessWidget {
  final int discountPercent;
  final String title;
  final bool active;
  final Color? color;
  final String? subtitle;
  final int? price;
  final DateTime? validity;
  const CouponCard(
      {required this.title,
      this.subtitle,
      this.price,
      this.color,
      this.validity,
      this.active = true,
      required this.discountPercent,
      super.key});

  @override
  Widget build(BuildContext context) {
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
      child: Row(
        children: [
          Container(
            width: 80,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: active ? color ?? Color(0xFF880E4F) : Colors.grey.shade700,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                bottomLeft: Radius.circular(15),
              ),
            ),
            child: RotatedBox(
              quarterTurns: 3,
              child: Text(
                '$discountPercent% OFF\nDISCOUNT',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
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
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: active
                        ? color ?? Color(0xFF880E4F)
                        : Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          subtitle ?? "ADMIT ONE",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                        Text(
                          formatValidityDate(validity ?? DateTime.now()),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'valid till',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      decoration: BoxDecoration(
                        color: active
                            ? color ?? Color(0xFF880E4F)
                            : Colors.grey.shade700, // Maroon Color
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Text(
                        price != null ? '$price₹' : 'N/A',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
