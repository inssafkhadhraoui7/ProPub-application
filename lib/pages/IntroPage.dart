import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:perspro/components/button.dart';


class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 83, 161, 234),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(height: 25),

              //shop name
              Text(
                "Bienvenue chez",
                style: GoogleFonts.dmSerifDisplay(
                  fontSize: 25,
                  color: Colors.white,
                ),
              ),
              Text(
                "PRO PUB",
                style: GoogleFonts.dmSerifDisplay(
                  fontSize: 60,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 25),

              //icon
              Padding(
                padding: const EdgeInsets.all(50.0),
                child: Image.asset(
                  'lib/images/intro.png',
                ),
              ),

              //title
              Text(
                "A votre service!",
                style: GoogleFonts.dmSerifDisplay(
                  fontSize: 45,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 10),

              //subtitle
              Text(
                "Tirage , Impression , Reluire à chauds et Spirale dans le plus court temps possible",
                style: GoogleFonts.dmSerifDisplay(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 25),

              //get started button
              
              MyButton(
                text: "Commencer",
                onTap: () {
                  //go to menu page
                  Navigator.pushNamed(context, '/menupage');
                },
              )
            ]),
      ),
    );
  }
}
