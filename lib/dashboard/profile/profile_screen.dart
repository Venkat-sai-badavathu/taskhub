import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:taskhub/auth/auth_service.dart';
import 'package:taskhub/dashboard/dashboard_screen.dart';
import 'package:taskhub/dashboard/profile/privacy_policy_screen.dart';
import 'package:taskhub/dashboard/profile/terms_of_use_screen.dart';
import 'package:taskhub/dashboard/tasks/tasks_screen.dart';
import 'package:taskhub/dashboard/timer/timer_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await canLaunchUrl(uri)) {
      throw Exception('Could not launch $url');
    }
    await launchUrl(uri);
  }

  Future<void> _logout(BuildContext context) async {
    try {
      // Sign out from Supabase
      await Supabase.instance.client.auth.signOut();

      // Navigate to login screen and clear navigation stack
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/login', // Make sure you have this route defined
        (route) => false, // Remove all routes
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logout failed: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Profile', style: TextStyle(color: Colors.white)),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            color: const Color(0xFF1A1A1A),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundColor: Color(0xFF333333),
                    child: Icon(Icons.person, size: 40, color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user?.email ?? 'No email',
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    user?.createdAt != null
                        ? 'Member since ${DateTime.parse(user!.createdAt!).toLocal().toString().split(' ')[0]}'
                        : '',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'SETTINGS',
              style: TextStyle(
                color: Color(0xFF6C7A89),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Card(
            color: const Color(0xFF1A1A1A),
            child: Column(
              children: [
                _buildListTile(
                  icon: Icons.privacy_tip,
                  title: 'Privacy Policy',
                  onTap:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PrivacyPolicyScreen(),
                        ),
                      ),
                ),
                const Divider(color: Color(0xFF333333)),
                _buildListTile(
                  icon: Icons.description,
                  title: 'Terms of Use',
                  onTap:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const TermsOfUseScreen(),
                        ),
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'ACCOUNT',
              style: TextStyle(
                color: Color(0xFF6C7A89),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Card(
            color: const Color(0xFF1A1A1A),
            child: _buildListTile(
              icon: Icons.logout,
              title: 'Log Out',
              iconColor: const Color(0xFFFF0B55),
              textColor: const Color(0xFFFF0B55),
              onTap: () => _showLogoutDialog(context),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    Color? iconColor,
    Color? textColor,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor ?? const Color(0xFF6C7A89)),
      title: Text(title, style: TextStyle(color: textColor ?? Colors.white)),
      trailing: const Icon(Icons.chevron_right, color: Color(0xFF6C7A89)),
      onTap: onTap,
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: const Color(0xFF1A1A1A),
            title: const Text('Log Out', style: TextStyle(color: Colors.white)),
            content: const Text(
              'Are you sure you want to log out?',
              style: TextStyle(color: Colors.white70),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Color(0xFF6C7A89)),
                ),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context); // Close the dialog
                  await _logout(context); // Perform logout
                },
                child: const Text(
                  'Log Out',
                  style: TextStyle(color: Color(0xFFFF0B55)),
                ),
              ),
            ],
          ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 3,
      onTap: (index) {
        if (index == 3) return;

        final screens = [
          const DashboardScreen(),
          const TasksScreen(),
          const TimerScreen(),
        ];

        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => screens[index],
            transitionDuration: Duration.zero,
          ),
        );
      },
      backgroundColor: Colors.black,
      selectedItemColor: const Color(0xFFFF0B55),
      unselectedItemColor: const Color(0xFF6C7A89),
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          label: 'Today',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.task), label: 'Tasks'),
        BottomNavigationBarItem(icon: Icon(Icons.timer), label: 'Timer'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }
}
