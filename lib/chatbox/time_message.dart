import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Chattime extends StatelessWidget {
  final String time;
  final String date;
  const Chattime({
    super.key,
    required this.time,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          time,
          style: GoogleFonts.abel(
              fontSize: 10,
              color: Colors.grey),
        ),
        SizedBox(width: 3,),
        Text(
          date,
          style: GoogleFonts.abel(
              fontSize: 10,
              color: Colors.grey),
        ),
      ],
    );
  }
}

