import 'package:flutter/material.dart';

class HowItWorks extends StatelessWidget {
  const HowItWorks({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('How it works'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "1.As you download the app, you will get minimum 2 coupons by default.",
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 8),
            Text(
              "2.Enter the shop. Meet and the reception and show your coupon in the app.",
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 8),
            Text(
              "3.Discuss the service you want to avail and get the understanding about the discount available.",
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 8),
            Text(
              "4.Scan the QR code of Mfest available at the reception and click the start of service. This step is important to secure the coupon as it is available in limited no. You can attach mor than one coupon of the same store, if you have the same.",
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 8),
            Text(
              "5.Start the service / purchase of product and enjoy the same.",
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 8),
            Text(
              "6.Complete the service / purchase of product . Again Scan the same QR code ( which you scanned earlier ) and Mark the end of service.",
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 8),
            Text(
              "7.The reception will enter the various details which you have to accept and make the complete payment to the counter.",
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 8),
            Text(
              "8.As you accept and complete the payment , you will get addition of minimum 2 coupons in your coupons entitlement.",
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 8),
            Text(
              "9.You can transfer the coupons to your friends also by the method of app to app transfer.",
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 8),
            Text(
              "10.Its important to mention that Mfest does not take any payment and is not involved in any financial transaction. Raising of bills and Payment of bills is solely based  on your agreement with the store providing the service or product. ",
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 8),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF386641),
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 60),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            'Close',
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
