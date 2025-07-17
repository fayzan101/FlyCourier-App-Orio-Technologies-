import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'profile_screen.dart';

class SidebarScreen extends StatelessWidget {
  final String userName;
  final VoidCallback onProfile;
  final VoidCallback onResetPassword;
  final VoidCallback onLogout;

  const SidebarScreen({
    Key? key,
    required this.userName,
    required this.onProfile,
    required this.onResetPassword,
    required this.onLogout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const darkBlue = Color(0xFF18136E);
    final width = MediaQuery.of(context).size.width;
    final hour = DateTime.now().hour;
    String greeting;
    if (hour < 12) {
      greeting = 'Good Morning';
    } else if (hour < 17) {
      greeting = 'Good Afternoon';
    } else {
      greeting = 'Good Evening';
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
          elevation: 0,
          automaticallyImplyLeading: false,
          title: const SizedBox.shrink(),
          actions: [
            IconButton(
              icon: const Icon(Icons.close, color: Colors.black, size: 28),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
        body: SafeArea(
          bottom: true,
          child: Padding(
            padding: EdgeInsets.fromLTRB(width * 0.04, width * 0.02, width * 0.04, width * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Top content
                Column(
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
                          padding: EdgeInsets.all(width * 0.03),
                          child: const Icon(Icons.person, color: darkBlue, size: 32),
                        ),
                        SizedBox(width: width * 0.03),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            userName.isEmpty || userName == 'Loading...'
                              ? Row(
                                  children: [
                                    SizedBox(
                                      width: width * 0.045,
                                      height: width * 0.045,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    ),
                                    SizedBox(width: width * 0.02),
                                    Text('Loading...', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: width * 0.045, color: darkBlue)),
                                  ],
                                )
                              : Text(
                                  'Hi, ' + userName.split(' ').map((part) => part.isNotEmpty ? part[0].toUpperCase() + part.substring(1).toLowerCase() : '').join(' '),
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                    fontSize: width * 0.045,
                                    color: darkBlue,
                                  ),
                                ),
                            SizedBox(height: width * 0.005),
                            Text(
                              greeting,
                              style: GoogleFonts.poppins(
                                color: Colors.black54,
                                fontSize: width * 0.035,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: width * 0.02),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.person, color: darkBlue),
                      title: Text('Profile', style: GoogleFonts.poppins(color: darkBlue, fontSize: width * 0.04)),
                      onTap: onProfile,
                      contentPadding: EdgeInsets.zero,
                    ),
                    SizedBox(height: width * 0.00005),
                    ListTile(
                      leading: const Icon(Icons.logout, color: darkBlue),
                      title: Text('Logout', style: GoogleFonts.poppins(color: darkBlue, fontSize: width * 0.04)),
                      onTap: onLogout,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ],
                ),
                // Bottom app version text
                SafeArea(
                  top: false,
                  left: false,
                  right: false,
                  bottom: true,
                  child: Center(
                    child: Text(
                      'App Version - V2.00',
                      style: GoogleFonts.poppins(color: Colors.black54, fontSize: width * 0.033),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 