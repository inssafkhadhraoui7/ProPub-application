import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:perspro/components/button.dart';
import '../models/biblio.dart';

class Bibliopre extends StatelessWidget {
  final Biblio biblio;
  const Bibliopre({
    super.key,
    required this.biblio,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
      ),
      margin: const EdgeInsets.only(left: 25),
      padding: const EdgeInsets.all(25),
      child: Column(
        children: [
          //image

          Image.asset(
            biblio.imagePath,
            height: 120,
          ),

          //text
          Text(
            biblio.name,
            style: GoogleFonts.dmSerifDisplay(fontSize: 20),
          ),

          //adress
          Text(
            biblio.adress,
            style: GoogleFonts.dmSerifDisplay(fontSize: 15),
          ),

          //status
          Text(
            biblio.status,
            style: GoogleFonts.dmSerifDisplay(fontSize: 15),
          ),

          SizedBox(
            height: 15,
          ),

          MyButton(
              text: "Faire une demande",
              onTap: () {
                //go demande form
                Navigator.pushNamed(context, '/authscreen');
              }),
        ],
      ),
    );
  }
}
