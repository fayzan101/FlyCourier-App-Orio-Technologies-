import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF181C70),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: 'FLY Courier',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 36,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Success Driven',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 24,
                color: Colors.white70,
                fontWeight: FontWeight.w400,
                fontFamily: 'Serif',
              ),
            ),
            const SizedBox(height: 8),
            // Two blue lines
            Column(
              children: [
                Container(
                  height: 4,
                  width: 210,
                  color: Color(0xFF2196F3),
                ),
                const SizedBox(height: 4),
                Container(
                  height: 4,
                  width: 160,
                  color: Color(0xFF2196F3),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}