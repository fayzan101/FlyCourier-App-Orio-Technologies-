import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FlyCourierBranding extends StatelessWidget {
  const FlyCourierBranding({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Main title - centered with respect to subtitle
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Text(
            'FLY Courier',
            style: GoogleFonts.montserrat(
              color: const Color(0xFF18136E),
              fontWeight: FontWeight.w900,
              fontSize: 16,
              letterSpacing: 1.0,
              height: 1.0,
            ),
          ),
        ),
        // Subtitle positioned right below
        Padding(
          padding: const EdgeInsets.only(left: 5.0),
          child: Text(
            'Success Driven',
            style: const TextStyle(
              color: Color(0xFF18136E),
              fontStyle: FontStyle.italic,
              fontSize: 18,
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
                width: 120,
                color: Colors.lightBlue,
              ),
            ),
            const SizedBox(height: 2),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Container(
                height: 2,
                width: 80,
                color: Colors.lightBlue,
              ),
            ),
          ],
        ),
      ],
    );
  }
} 