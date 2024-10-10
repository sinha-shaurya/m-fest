import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SponsorPage extends StatelessWidget {
  const SponsorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Featured Sponsors',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _buildSponsorBanner(
              title: 'ABC Insurance',
              description: 'Get the best deals on insurance now!',
              logoPath: 'https://licindia.in/o/lic-theme/images/lic_logo.png',
              url: 'https://www.abcinsurance.com',
            ),
            const SizedBox(height: 20),
            _buildSponsorBanner(
              title: 'DEF Insurance',
              description: 'Get the best deals on insurance now!',
              logoPath:
                  'https://cdn.prod.website-files.com/6145f7156a1337613524d548/63f4a8e8e3b73c67a201716d_logo__Bajaj.png',
              url: 'https://www.abcinsurance.com',
            ),
            const SizedBox(height: 20),
            _buildSponsorBanner(
              title: 'Health Insurance',
              description: 'Get the best deals on insurance now!',
              logoPath:
                  'https://1finance.co.in/magazine/wp-content/uploads/2023/06/16404392_tp212-socialmedia-02-1-scaled.jpg',
              url: 'https://www.abcinsurance.com',
            ),
            const SizedBox(height: 20),
            // Add more sponsors here if needed
          ],
        ),
      ),
    );
  }

  Widget _buildSponsorBanner({
    required String title,
    required String description,
    required String logoPath,
    required String url,
  }) {
    return GestureDetector(
      onTap: () {
        _launchURL(url);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(width: 0.5, color: Colors.grey.shade300),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 6,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                logoPath,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }
}
