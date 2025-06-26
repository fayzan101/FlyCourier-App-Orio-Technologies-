import 'package:flutter/material.dart';

class SidebarMenu extends StatelessWidget {
  final String userName;
  final VoidCallback onProfile;
  final VoidCallback onResetPassword;
  final VoidCallback onLogout;
  final VoidCallback onClose;

  const SidebarMenu({
    Key? key,
    required this.userName,
    required this.onProfile,
    required this.onResetPassword,
    required this.onLogout,
    required this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const darkBlue = Color(0xFF18136E);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F3F3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: const Icon(Icons.person, color: darkBlue, size: 32),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hi, $userName',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: darkBlue,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Good Morning',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.black, size: 28),
                        onPressed: onClose,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.person, color: darkBlue),
                    title: const Text('Profile', style: TextStyle(color: darkBlue, fontSize: 16)),
                    onTap: onProfile,
                    contentPadding: EdgeInsets.zero,
                  ),
                  ListTile(
                    leading: const Icon(Icons.lock_outline, color: darkBlue),
                    title: const Text('Reset Password', style: TextStyle(color: darkBlue, fontSize: 16)),
                    onTap: onResetPassword,
                    contentPadding: EdgeInsets.zero,
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout, color: darkBlue),
                    title: const Text('Logout', style: TextStyle(color: darkBlue, fontSize: 16)),
                    onTap: onLogout,
                    contentPadding: EdgeInsets.zero,
                  ),
                  const Spacer(),
                  const Center(
                    child: Text(
                      'App Version - V2.00',
                      style: TextStyle(color: Colors.black54, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 