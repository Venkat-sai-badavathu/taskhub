import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dashboard/dashboard_screen.dart';
import 'app/theme.dart';
import 'auth/auth_service.dart';
import 'auth/login_screen.dart';
import 'auth/signup_screen.dart';
import 'dashboard/tasks/tasks_screen.dart';
import 'dashboard/timer/timer_screen.dart';
import 'dashboard/profile/profile_screen.dart';
import 'dashboard/profile/privacy_policy_screen.dart';
import 'dashboard/profile/terms_of_use_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Show loading screen immediately while initializing
  runApp(
    MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(color: Color(0xFFFF0B55)),
              const SizedBox(height: 20),
              Image.asset('assets/logo.png', height: 100),
              const SizedBox(height: 20),
              const Text(
                'Initializing TaskHub...',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  await _initializeApp();
}

Future<void> _initializeApp() async {
  try {
    // Initialize Supabase with your credentials
    await Supabase.initialize(
      url: 'https://pltrynjiugrhfuszxcuc.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBsdHJ5bmppdWdyaGZ1c3p4Y3VjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDUxNDA5MDQsImV4cCI6MjA2MDcxNjkwNH0.ioW_NpAGHEb7tXMueUMTJ7odywKBKMFqNX9AFeuPD40',
      authOptions: const FlutterAuthClientOptions(
        authFlowType: AuthFlowType.pkce,
      ),
    ).timeout(const Duration(seconds: 10));

    // Start the app with providers
    runApp(
      MultiProvider(
        providers: [ChangeNotifierProvider(create: (_) => AuthService())],
        child: const TaskHubApp(),
      ),
    );
  } on TimeoutException {
    _showErrorScreen('Connection timeout. Please check your internet.');
  } catch (e) {
    _showErrorScreen(
      'Initialization failed',
      details: e.toString().replaceFirst('Exception: ', ''),
    );
  }
}

void _showErrorScreen(String message, {String details = ''}) {
  runApp(
    MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Color(0xFFFF0B55),
                  size: 50,
                ),
                const SizedBox(height: 20),
                Text(
                  message,
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                if (details.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Text(
                    details,
                    style: const TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
                const SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF0B55),
                  ),
                  onPressed: () => main(),
                  child: const Text(
                    'Try Again',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

class TaskHubApp extends StatelessWidget {
  const TaskHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TaskHub',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const _AuthWrapper(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/tasks': (context) => const TasksScreen(),
        '/timer': (context) => const TimerScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/privacy': (context) => const PrivacyPolicyScreen(),
        '/terms': (context) => const TermsOfUseScreen(),
      },
      onGenerateRoute: (settings) {
        // Handle any undefined routes
        return MaterialPageRoute(
          builder:
              (context) => Scaffold(
                backgroundColor: Colors.black,
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Color(0xFFFF0B55),
                        size: 50,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Page not found\n${settings.name}',
                        style: const TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF0B55),
                        ),
                        onPressed: () => Navigator.pushNamed(context, '/'),
                        child: const Text(
                          'Go Home',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
        );
      },
    );
  }
}

class _AuthWrapper extends StatelessWidget {
  const _AuthWrapper();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return StreamBuilder<AuthState>(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        // Loading state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: CircularProgressIndicator(color: Color(0xFFFF0B55)),
            ),
          );
        }

        // Error state
        if (snapshot.hasError) {
          return Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          );
        }

        // Auth decision
        return authService.isLoggedIn
            ? const DashboardScreen()
            : const LoginScreen();
      },
    );
  }
}
