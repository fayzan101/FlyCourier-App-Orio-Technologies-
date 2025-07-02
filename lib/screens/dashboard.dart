import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'forgot_password.dart';
import 'login_screen.dart';
import '../services/user_service.dart';
import 'Pickup.dart';
import 'arrival.dart';
import 'profile_screen.dart';
import 'sidebar_menu.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:get/get.dart';
import '../Utils/Colors/color_resources.dart';
import '../Utils/custom_snackbar.dart';
import 'dart:async';
import '../controllers/dashboard_card_controller.dart';

class DashboardScreen extends StatefulWidget {
  final bool showLoginSuccess;
  DashboardScreen({Key? key, this.showLoginSuccess = false}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final DashboardCardController cardController = Get.put(DashboardCardController());
  String userName = 'User';

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  void _loadUserName() async {
    final userInfo = await UserService.getUserInfo();
    if (userInfo['emp_name'] != null && userInfo['emp_name']!.isNotEmpty) {
      setState(() {
        userName = userInfo['emp_name']!;
      });
    } else {
      final user = await UserService.getUser();
      if (user != null) {
        setState(() {
          userName = user.fullName;
        });
      }
    }
  }

  void _showMenuModal(BuildContext context) {
    Get.to(() => SidebarScreen(
      userName: userName,
      onLogout: () => _showLogoutSheet(context),
      onResetPassword: () {
        Get.to(() => const ForgotPasswordScreen());
      },
      onProfile: () {
        Get.to(() => const ProfileScreen());
      },
    ));
  }

  void _showLogoutSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return _LogoutSheet(
          onNo: () => Get.back(),
          onYes: () async {
            await UserService.logout();
            Get.delete<DashboardCardController>();
            Get.offAll(() => const LoginScreen());
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.showLoginSuccess) {
      Future.delayed(Duration(milliseconds: 300), () {
        customSnackBar('Success', 'Login successful!');
      });
    }
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        extendBody: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          surfaceTintColor: Colors.white,
          scrolledUnderElevation: 1,
          automaticallyImplyLeading: false,
          title: const SafeArea(child: _FlyCourierBranding()),
          actions: [
            IconButton(
              icon: const Icon(Icons.menu, color: Colors.black, size: 28),
              onPressed: () => _showMenuModal(context),
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8, top: 8),
                    child: Text(
                      'Dashboard',
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(
                      'Here is the list of operational process',
                      style: GoogleFonts.poppins(
                        color: Color(0xFF7B7B7B),
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Obx(() => GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20,
                      childAspectRatio: 1.15,
                      children: [
                        if (cardController.showPickup.value)
                          GestureDetector(
                            onTap: () {
                              Get.to(() => const PickupScreen());
                            },
                            child: _DashboardCard(icon: Icons.local_shipping, label: 'Pickup'),
                          ),
                        if (cardController.showArrival.value)
                          GestureDetector(
                            onTap: () {
                              Get.to(() => const ArrivalScreen());
                            },
                            child: _DashboardCard(icon: Icons.inventory_2, label: 'Arrival'),
                          ),
                        if (cardController.showManifest.value)
                          _DashboardCard(icon: Icons.list_alt, label: 'Manifest'),
                        if (cardController.showDeManifest.value)
                          _DashboardCard(icon: Icons.assignment_return, label: 'De Manifest'),
                        if (cardController.showCreateSheet.value)
                          _DashboardCard(icon: Icons.create, label: 'Create Sheet'),
                        if (cardController.showDelivery.value)
                          _DashboardCard(icon: Icons.delivery_dining, label: 'Delivery'),
                        if (cardController.showTracking.value)
                          _DashboardCard(icon: Icons.track_changes, label: 'Tracking'),
                        if (cardController.showReport.value)
                          _DashboardCard(icon: Icons.bar_chart, label: 'Report'),
                      ],
                    )),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
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
      padding: EdgeInsets.fromLTRB(24, 32, 24, 32 + MediaQuery.of(context).viewPadding.bottom),
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