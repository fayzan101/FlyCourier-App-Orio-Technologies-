import 'package:flutter/material.dart';
import 'forgot_password.dart';
import 'login_screen.dart';
import '../services/user_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String userName = 'User';

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  void _loadUserName() async {
    final user = await UserService.getUser();
    if (user != null && mounted) {
      setState(() {
        userName = user.fullName;
      });
    }
  }

  void _showMenuModal(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      pageBuilder: (context, anim1, anim2) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: Colors.white,
            body: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
                  child: _SidebarMenu(
                    userName: userName,
                    onLogout: () => _showLogoutSheet(context),
                    onResetPassword: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()),
                      );
                    },
                    onProfile: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const ProfileScreen()),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showLogoutSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return _LogoutSheet(
          onNo: () => Navigator.of(context).pop(),
          onYes: () async {
            await UserService.logout();
            if (mounted) {
              Navigator.of(context).pop(); // close sheet
              Navigator.of(context).pop(); // close sidebar
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const _FlyCourierBranding(),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.black, size: 28),
            onPressed: () => _showMenuModal(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Dashboard',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Here is the list of operational process',
              style: TextStyle(
                color: Color(0xFF7B7B7B),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _DashboardCard(
                    icon: Icons.local_shipping,
                    label: 'Pickup',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _DashboardCard(
                    icon: Icons.inventory_2,
                    label: 'Arrival',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SidebarMenu extends StatelessWidget {
  final String userName;
  final VoidCallback onLogout;
  final VoidCallback onResetPassword;
  final VoidCallback onProfile;
  const _SidebarMenu({
    required this.userName,
    required this.onLogout, 
    required this.onResetPassword, 
    required this.onProfile
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF3F3F3),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(12),
              child: const Icon(Icons.person, color: Color(0xFF18136E), size: 32),
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
                    color: Colors.black,
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
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.person, color: Color(0xFF18136E)),
          title: const Text('Profile', style: TextStyle(color: Colors.black, fontSize: 16)),
          onTap: onProfile,
          contentPadding: EdgeInsets.zero,
        ),
        ListTile(
          leading: const Icon(Icons.lock_outline, color: Color(0xFF18136E)),
          title: const Text('Reset Password', style: TextStyle(color: Colors.black, fontSize: 16)),
          onTap: onResetPassword,
          contentPadding: EdgeInsets.zero,
        ),
        ListTile(
          leading: const Icon(Icons.logout, color: Color(0xFF18136E)),
          title: const Text('Logout', style: TextStyle(color: Colors.black, fontSize: 16)),
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
    );
  }
}

class _LogoutSheet extends StatelessWidget {
  final VoidCallback onNo;
  final VoidCallback onYes;
  const _LogoutSheet({required this.onNo, required this.onYes});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFFFFE6EC),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.logout, color: Color(0xFFD72660), size: 48),
          ),
          const SizedBox(height: 24),
          const Text(
            'Are you Sure',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'You want to logout',
            style: TextStyle(
              color: Color(0xFF7B7B7B),
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: const Color(0xFFF3F3F3),
                    side: BorderSide.none,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: onNo,
                  child: const Text('No', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF18136E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: onYes,
                  child: const Text('Yes', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FlyCourierBranding extends StatelessWidget {
  const _FlyCourierBranding();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Main title - centered with respect to subtitle
        Padding(
          padding: const EdgeInsets.only(left: 9.0),
          child: Text(
            'FLY Courier',
            style: TextStyle(
              color: Color(0xFF18136E),
              fontWeight: FontWeight.w900,
              fontSize: 16,
              letterSpacing: 1.2,
              fontFamily: 'Arial',
              height: 1.0,
            ),
          ),
        ),
        // Subtitle positioned right below
        Padding(
          padding: const EdgeInsets.only(left: 5.0),
          child: Text(
            'Success Driven',
            style: TextStyle(
              color: Color(0xFF18136E),
              fontStyle: FontStyle.italic,
              fontSize: 16,
              fontWeight: FontWeight.w400,
              fontFamily: 'Arial',
              height: 1.0,
            ),
          ),
        ),
        const SizedBox(height: 4),
        // Two blue lines positioned below the text
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: Container(
                height: 2,
                width: 100,
                color: Colors.lightBlue,
              ),
            ),
            const SizedBox(height: 2),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Container(
                height: 2,
                width: 70,
                color: Colors.lightBlue,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final IconData icon;
  final String label;
  const _DashboardCard({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      decoration: BoxDecoration(
        color: const Color(0xFFF3F3F3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: Color(0xFF18136E)),
          const SizedBox(height: 12),
          Text(
            label,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String fullName = '';
  String email = '';
  String phoneNumber = '';
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
        email = user.email;
        phoneNumber = user.phoneNumber;
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