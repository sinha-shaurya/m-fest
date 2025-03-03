import 'package:aash_india/presentations/widgets/confirmation_dialog.dart';
import 'package:aash_india/utils/date_formatter.dart';
import 'package:flutter/material.dart';

class CouponCard extends StatelessWidget {
  final int discountPercent;
  final String? id;
  final String title;
  final String? category;
  final bool active;
  final String? buttonTitle;
  final Color? color;
  final VoidCallback? onTap;
  final VoidCallback? onCancel;
  final int? price;
  final DateTime? validity;
  final String? address;
  const CouponCard({
    required this.title,
    this.onTap,
    this.onCancel,
    this.buttonTitle,
    this.category,
    this.id,
    this.price,
    this.color,
    this.address,
    this.validity,
    this.active = true,
    required this.discountPercent,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final Color cardColor =
        active ? (color ?? Color(0xFF344e41)) : Colors.grey.shade700;

    return Container(
      margin: const EdgeInsets.all(12.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
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
                    SizedBox(
                      height: 25,
                    ),
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: cardColor,
                      ),
                    ),
                    address != null
                        ? Text(
                            address!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade800,
                            ),
                          )
                        : const SizedBox(height: 0),
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
                        active
                            ? TextButton(
                                onPressed: () => showConfirmationDialog(context,
                                    title:
                                        'Do you really want to remove this coupon?',
                                    onConfirm: onCancel,
                                    confirmText: 'remove'),
                                child: Text(
                                  'remove',
                                  style: TextStyle(
                                    color: Color(0xFF344e41),
                                  ),
                                ),
                              )
                            : const SizedBox(),
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
              child: Text(
                category ?? "",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: category != null ? 12 : 0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
