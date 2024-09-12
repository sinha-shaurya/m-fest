import 'package:flutter/material.dart';

class FeaturedSlider extends StatelessWidget {
  const FeaturedSlider({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (context, index) {
          return Container(
            width: 250,
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              image: const DecorationImage(
                image: AssetImage('assets/featured_coupon.png'),
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }
}
