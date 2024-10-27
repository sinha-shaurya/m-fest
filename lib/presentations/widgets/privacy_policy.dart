import 'package:aash_india/core/constants/theme.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Terms & Policy'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Privacy Policy',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              "This privacy statement applies to your use of any products, services, content, features, technologies, or functions, and all related websites, mobile apps, mobile sites or other online platform or applications offered to you by us (collectively the 'Services/Platform'). We collect, use, and share personal information to help the Quikr and its affiliate websites work and to keep it safe (details below). Quikr India Private Limited, acting itself and through its subsidiaries, is the data controller of your personal information collected. This policy is effective 16/02/2021.Information posted on Quikr is obviously publicly available. Our servers are located in Mumbai, India. Therefore, if you choose to provide us with personal information, you are consenting to the transfer and storage of that information on our servers.\n 1. What data do we collect about you?\n1.1. Data provided through direct interactions",
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 16),
            Text(
              'Data Collection',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'We collect data to improve our services and user experience.',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 16),
            RichText(
              text: TextSpan(
                text: 'For more information, visit our ',
                style: TextStyle(color: Colors.black, fontSize: 14),
                children: [
                  TextSpan(
                    text: 'Help Center',
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        // Open link
                      },
                  ),
                  TextSpan(text: ' or '),
                  TextSpan(
                    text: 'Contact Us',
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        // Open link
                      },
                  ),
                  TextSpan(text: ' for support.'),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Close'),
        ),
      ],
    );
  }
}
