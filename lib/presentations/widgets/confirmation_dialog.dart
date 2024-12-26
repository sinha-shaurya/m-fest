import 'package:flutter/material.dart';

void showConfirmationDialog(BuildContext context,
    {required String title,
    VoidCallback? onConfirm,
    required String confirmText,
    String? desc}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          title,
          style: TextStyle(
            color: Color(0xFF344e41),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        content: Text(
          desc ?? '',
          style: TextStyle(
            color: Colors.grey.shade800,
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.grey.shade800,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              if (onConfirm != null) {
                onConfirm();
              }
              Navigator.of(context).pop();
            },
            child: Text(
              confirmText,
              style: TextStyle(
                color: Color(0xFF344e41),
              ),
            ),
          ),
        ],
      );
    },
  );
}
