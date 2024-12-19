import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Chatbubble extends StatelessWidget {
  final String message;
  const Chatbubble({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(12, 7, 12, 7),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [Colors.red.shade400, Colors.yellow], // Red and Yellow gradient
          begin: Alignment.topLeft, // Start of the gradient
          end: Alignment.bottomRight, // End of the gradient
        ), // End of the gradient
      ),
      child: Text(
        message,
        style: GoogleFonts.abel(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
