import 'package:flutter/material.dart';
import '../services/user_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String fullName = '';
  String password = '';
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    final user = await UserService.getUser();
    if (user != null && mounted) {
      setState(() {
        fullName = user.fullName;
        password = user.password;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text('Profile Page', style: TextStyle(color: Colors.black)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            const Text('Name', style: TextStyle(fontSize: 14)),
            const SizedBox(height: 4),
            TextFormField(
              enabled: false,
              initialValue: fullName,
              decoration: const InputDecoration(
                filled: true,
                fillColor: Color(0xFFF3F3F3),
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Designation', style: TextStyle(fontSize: 14)),
            const SizedBox(height: 4),
            TextFormField(
              enabled: false,
              initialValue: 'Driver',
              decoration: const InputDecoration(
                filled: true,
                fillColor: Color(0xFFF3F3F3),
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
              ),
            ),
            const SizedBox(height: 16),
            const Text('City', style: TextStyle(fontSize: 14)),
            const SizedBox(height: 4),
            TextFormField(
              enabled: false,
              initialValue: 'KHI',
              decoration: const InputDecoration(
                filled: true,
                fillColor: Color(0xFFF3F3F3),
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Station', style: TextStyle(fontSize: 14)),
            const SizedBox(height: 4),
            TextFormField(
              enabled: false,
              initialValue: 'Karachi',
              decoration: const InputDecoration(
                filled: true,
                fillColor: Color(0xFFF3F3F3),
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Password', style: TextStyle(fontSize: 14)),
            const SizedBox(height: 4),
            TextFormField(
              enabled: false,
              initialValue: password,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFF3F3F3),
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                suffixIcon: IconButton(
                  icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 