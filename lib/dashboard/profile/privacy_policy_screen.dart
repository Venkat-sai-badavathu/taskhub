import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Privacy Policy',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Last Updated: January 1, 2023',
              style: TextStyle(color: Color(0xFF6C7A89), fontSize: 12),
            ),
            const SizedBox(height: 24),
            const Text(
              '1. Information We Collect',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'We collect information you provide directly when you use TaskHub. This includes:\n\n'
              '- Account information (email)\n'
              '- Task data you create\n'
              '- Usage data and preferences',
              style: TextStyle(color: Colors.white70, height: 1.5),
            ),
            const SizedBox(height: 24),
            const Text(
              '2. How We Use Your Information',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Your information is used to:\n\n'
              '- Provide and maintain our service\n'
              '- Improve user experience\n'
              '- Communicate with you\n'
              '- Ensure app security',
              style: TextStyle(color: Colors.white70, height: 1.5),
            ),
            const SizedBox(height: 24),
            const Text(
              '3. Data Security',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'We implement industry-standard security measures including:\n\n'
              '- Encryption of data in transit\n'
              '- Secure server infrastructure\n'
              '- Regular security audits\n\n'
              'However, no method of electronic transmission is 100% secure.',
              style: TextStyle(color: Colors.white70, height: 1.5),
            ),
            const SizedBox(height: 24),
            const Text(
              '4. Changes to This Policy',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'We may update this policy periodically. We will notify you of changes by updating the "Last Updated" date.',
              style: TextStyle(color: Colors.white70, height: 1.5),
            ),
            const SizedBox(height: 40),
            Center(
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'I UNDERSTAND',
                  style: TextStyle(color: Color(0xFFFF0B55), fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
