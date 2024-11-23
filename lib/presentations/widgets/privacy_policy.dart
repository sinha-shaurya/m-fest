import 'package:flutter/material.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Privacy Policy',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Last updated: November 13, 2024',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            SizedBox(height: 16),
            Text(
              "This Privacy Policy describes Our policies and procedures on the collection, use and disclosure of Your information when You use the Service and tells You about Your privacy rights and how the law protects You. We use Your Personal data to provide and improve the Service. By using the Service, You agree to the collection and use of information in accordance with this Privacy Policy.",
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 16),
            Text(
              'Interpretation and Definitions',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Interpretation\nThe words of which the initial letter is capitalized have meanings defined under the following conditions. The following definitions shall have the same meaning regardless of whether they appear in singular or in plural.',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 16),
            _buildDefinitions(),
            SizedBox(height: 16),
            _buildDataCollection(),
            SizedBox(height: 16),
            _buildUseOfPersonalData(),
            SizedBox(height: 16),
            _buildRetentionAndTransfer(),
            SizedBox(height: 16),
            _buildSecurityAndChildren(),
            SizedBox(height: 16),
            _buildLinksAndChanges(),
            SizedBox(height: 16),
            _buildContactInfo(),
          ],
        ),
      ),
      actionsPadding: const EdgeInsets.all(12),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Close'),
        ),
      ],
    );
  }

  Widget _buildDefinitions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Definitions\nFor the purposes of this Privacy Policy:',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        SizedBox(height: 8),
        Text(
          '- **Account** means a unique account created for You to access our Service or parts of our Service.\n'
          '- **Affiliate** means an entity that controls, is controlled by or is under common control with a party.\n'
          '- **Application** refers to mfest, the software program provided by the Company.\n'
          '- **Company** refers to AASH INDIA, located at 121, Hira Place, Dakbunglow Road, Patna-800001.\n'
          '- **Country** refers to Bihar, India.\n'
          '- **Device** means any device that can access the Service such as a computer or mobile device.\n'
          '- **Personal Data** is any information that relates to an identified or identifiable individual.\n'
          '- **Service** refers to the Application.\n'
          '- **Service Provider** means any natural or legal person who processes data on behalf of the Company.\n'
          '- **Third-party Social Media Service** refers to any website through which a User can log in to use the Service.\n'
          '- **Usage Data** refers to data collected automatically when using the Service.\n'
          '- **You** means the individual accessing or using the Service.',
          style: TextStyle(fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildDataCollection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Collecting and Using Your Personal Data',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        SizedBox(height: 8),
        Text(
          'Types of Data Collected\nWhile using Our Service, We may ask You to provide Us with certain personally identifiable information that can be used to contact or identify You. This may include:\n- Email address\n- First name and last name\n- Phone number\n- Address, State, Province, ZIP/Postal code, City',
          style: TextStyle(fontSize: 14),
        ),
        SizedBox(height: 8),
        Text(
          'Usage Data\nUsage Data is collected automatically when using the Service. This may include information such as Your Device\'s IP address, browser type, pages visited, time and date of visit, and other diagnostic data.',
          style: TextStyle(fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildUseOfPersonalData() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Use of Your Personal Data',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        SizedBox(height: 8),
        Text(
          'The Company may use Personal Data for various purposes including:\n- To provide and maintain our Service.\n- To manage Your Account.\n- To contact You via email or phone regarding updates or offers.',
          style: TextStyle(fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildRetentionAndTransfer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Retention of Your Personal Data',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        SizedBox(height: 8),
        Text(
          'The Company will retain Your Personal Data only for as long as necessary for the purposes set out in this Privacy Policy.',
          style: TextStyle(fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildSecurityAndChildren() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Security of Your Personal Data',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        SizedBox(height: 8),
        Text(
          'The security of Your Personal Data is important to Us; however, no method of transmission over the Internet is completely secure.',
          style: TextStyle(fontSize: 14),
        ),
        SizedBox(height: 16),
        Text(
          "Children's Privacy\nOur Service does not address anyone under the age of 13. We do not knowingly collect personally identifiable information from anyone under this age.",
          style: TextStyle(fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildLinksAndChanges() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Links to Other Websites',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        SizedBox(height: 8),
        Text(
          "Our Service may contain links to other websites that are not operated by Us. We have no control over these sites.",
          style: TextStyle(fontSize: 14),
        ),
        SizedBox(height: 16),
        Text(
          "Changes to this Privacy Policy\nWe may update Our Privacy Policy from time to time. We will notify You of any changes by posting it on this page.",
          style: TextStyle(fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildContactInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Contact Us',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'If you have any questions about this Privacy Policy, you can contact us:\n'
          '- By email : ms@aashindia.com\n'
          '- By phone number : +91-9334196884\n'
          '- By mail : AASH INDIA,\n121 Hira Place,\nDakbunglow Road,\nPatna - PIN800001',
          style: TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}
