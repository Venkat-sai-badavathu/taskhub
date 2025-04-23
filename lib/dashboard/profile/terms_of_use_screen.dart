import 'package:flutter/material.dart';

class TermsOfUseScreen extends StatelessWidget {
  const TermsOfUseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Terms of Use',
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
              'Effective Date: January 1, 2023',
              style: TextStyle(color: Color(0xFF6C7A89), fontSize: 12),
            ),
            const SizedBox(height: 24),
            const Text(
              '1. Acceptance of Terms',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'By accessing or using TaskHub, you agree to be bound by these Terms. '
              'If you disagree with any part, you may not access the service.',
              style: TextStyle(color: Colors.white70, height: 1.5),
            ),
            const SizedBox(height: 24),
            const Text(
              '2. User Responsibilities',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'You agree to:\n\n'
              '- Provide accurate account information\n'
              '- Maintain password confidentiality\n'
              '- Not use the service for illegal purposes\n'
              '- Not attempt to disrupt service operations',
              style: TextStyle(color: Colors.white70, height: 1.5),
            ),
            const SizedBox(height: 24),
            const Text(
              '3. Intellectual Property',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'The TaskHub application and its original content, features, and functionality '
              'are owned by us and protected by international copyright laws.',
              style: TextStyle(color: Colors.white70, height: 1.5),
            ),
            const SizedBox(height: 24),
            const Text(
              '4. Limitation of Liability',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'TaskHub shall not be liable for any indirect, incidental, special, '
              'consequential or punitive damages resulting from your use of the service.',
              style: TextStyle(color: Colors.white70, height: 1.5),
            ),
            const SizedBox(height: 24),
            const Text(
              '5. Governing Law',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'These Terms shall be governed by the laws of the State of California, '
              'without regard to its conflict of law provisions.',
              style: TextStyle(color: Colors.white70, height: 1.5),
            ),
            const SizedBox(height: 40),
            Center(
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'I AGREE',
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
