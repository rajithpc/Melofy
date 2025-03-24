import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: true,
        title: const Text(
          'Privacy Policy',
          style: TextStyle(fontFamily: 'melofy-font'),
        ),
      ),
      body: Container(
        color: Colors.grey[900],
        child: const Padding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: SingleChildScrollView(
            child: Text(
              '''
      Privacy Policy
      
      Effective Date: 01-04-2030
      
      Melofy ("we", "our", or "us") is committed to protecting your privacy. This Privacy Policy explains how we collect, use, and protect your information when you use our offline music player application, Melofy ("the App").
      
      Information We Collect
      Melofy does not collect, store, or transmit any personal information from users. The App operates entirely offline and only accesses music files stored locally on your device.
      
      Permissions We Require
      To provide core functionality, Melofy requires access to:
      - Read External Storage: This permission allows the App to access and display audio files stored on your device.
      
      How We Use Your Information
      The App solely uses permissions to:
      - Fetch and display music files stored on your device.
      - Play audio files as requested by you.
      
      No information is collected, shared, or stored by Melofy.
      
      Third-Party Services
      Melofy does not use any third-party services that collect user information.
      
      Security
      Since the App does not collect or transmit any data, your privacy and security are fully protected.
      
      Changes to This Privacy Policy
      We may update this Privacy Policy from time to time. Any changes will be reflected in this document. You are encouraged to review this Privacy Policy periodically.
      
      Contact Us
      If you have any questions or concerns about this Privacy Policy, please contact us at: rajithpc65@gmail.com
      
      By using Melofy, you agree to the terms outlined in this Privacy Policy.
            ''',
              style: TextStyle(
                  fontSize: 16, fontFamily: 'melofy-font', color: Colors.grey),
            ),
          ),
        ),
      ),
    );
  }
}
