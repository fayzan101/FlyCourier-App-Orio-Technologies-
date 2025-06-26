import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard.dart';
import 'services/user_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FLY Courier',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF181C70)),
        useMaterial3: true,
      ),
      home: const SplashToLogin(),
    );
  }
}

class SplashToLogin extends StatefulWidget {
  const SplashToLogin({Key? key}) : super(key: key);

  @override
  State<SplashToLogin> createState() => _SplashToLoginState();
}

class _SplashToLoginState extends State<SplashToLogin> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  void _checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      final isLoggedIn = await UserService.isLoggedIn();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => isLoggedIn ? const DashboardScreen() : const LoginScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const SplashScreen();
  }
}
