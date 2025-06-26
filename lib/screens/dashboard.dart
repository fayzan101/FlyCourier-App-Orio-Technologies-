import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

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
            onPressed: () {},
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