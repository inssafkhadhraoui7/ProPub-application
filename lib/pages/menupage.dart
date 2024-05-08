import 'package:flutter/material.dart';
import 'package:perspro/components/bibliopre.dart';
import 'package:perspro/models/biblio.dart';

class Menupage extends StatefulWidget {
  const Menupage({Key? key}) : super(key: key);

  @override
  State<Menupage> createState() => _MenupageState();
}

class _MenupageState extends State<Menupage> {
  String searchText = '';

  List<Biblio> listbureaux = [
    Biblio(
      name: "Ennasr",
      adress: "cité ennassim borj louzir Ariana",
      status: "disponible",
      imagePath: "lib/images/ennasr.jpeg",
    ),
    Biblio(
      name: "MedInfo",
      adress: "jara Gabes",
      status: "non disponible",
      imagePath: "lib/images/Gabes.jpeg",
    ),
    Biblio(
      name: "QuadriCopie",
      adress: "el mahres sfax",
      status: "disponible",
      imagePath: "lib/images/QuadriCopie.jpeg",
    ),
    Biblio(
      name: "MesPhotocopies",
      adress: "Rue el biaa el manzel Gabes",
      status: "disponible",
      imagePath: "lib/images/MesPhotocopies.jpg",
    ),
  ];

  List<Biblio> get filteredList {
    return listbureaux.where((biblio) {
      return biblio.name.toLowerCase().contains(searchText.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 152, 194, 245),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Icon(
          Icons.menu,
          color: Colors.white,
        ),
        title: Text(
          "Accueil",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ... Autres widgets ...
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 25),
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Message
                Text(
                  "Profitez de nos services",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                const SizedBox(
                  height: 20,
                ),
                // Image
                // Add your image widget here
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
              decoration: InputDecoration(
                hintText: "Rechercher",
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(20),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(20),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),

          SizedBox(height: 35),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Text(
              "Listes des bureaux de services",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 25, 25, 25),
                fontSize: 20,
              ),
            ),
          ),

          SizedBox(height: 25),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (var biblio in filteredList)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Bibliopre(biblio: biblio),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
