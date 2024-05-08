import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DemandPage extends StatefulWidget {
  const DemandPage({Key? key}) : super(key: key);

  @override
  _BookingState createState() => _BookingState();
}

class _BookingState extends State<DemandPage> {
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerDate = TextEditingController();
  final TextEditingController _controllerTemps = TextEditingController();
  final TextEditingController _controllerNm = TextEditingController();
  final TextEditingController _controllerDescription = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  bool isLoading = false;
  double _uploadProgress = 0.0;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _controllerDate.text = _selectedDate!.toString();
      });
    }
  }

  void _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
        _controllerTemps.text = _selectedTime!.format(context);
      });
    }
  }

  Future<void> _uploadFile() async {
    setState(() {
      isLoading = true;
      _uploadProgress = 0.0;
    });

    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      PlatformFile file = result.files.first;
      Reference ref =
          _storage.ref().child('documents/${DateTime.now()}_${file.name}');

      UploadTask uploadTask = ref.putFile(File(file.path!));

      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        setState(() {
          _uploadProgress = snapshot.bytesTransferred / snapshot.totalBytes;
        });
      });

      try {
        await uploadTask;
        String downloadURL = await ref.getDownloadURL();
        print('Fichier téléchargé $downloadURL');
      } catch (e) {
        print('Erreur téléchargement de fichier: $e');
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _saveFormDataToFirebase() async {
    try {
      await _firestore.collection('demandes').add({
        'name': _controllerName.text,
        'date': _controllerDate.text,
        'temps': _controllerTemps.text,
        'phoneNumber': _controllerNm.text,
        'description': _controllerDescription.text,
      });
      _showNotification('Demande envoyée avec succès!');
    } catch (e) {
      _showNotification('Erreur lors de l\'envoi de la demande.');
      print('Error: $e');
    }
  }

  Future<void> _uploadFormData() async {
    try {
      if (_areFieldsFilled()) {
        String documentId = ''; // Use the ID of the existing document

        await _firestore.collection('demandes').doc(documentId).update({
          'name': _controllerName.text,
          'date': _controllerDate.text,
          'temps': _controllerTemps.text,
          'phoneNumber': _controllerNm.text,
          'description': _controllerDescription.text,
        });

        _showNotification('Données modifiées avec succès!');
        Navigator.pushNamed(context, '/paymentview');
      } else {
        _showNotification('Veuillez remplir tous les champs.');
      }
    } catch (e) {
      _showNotification('Erreur lors de la modification des données.');
      print('Error: $e');
    }
  }

  bool _areFieldsFilled() {
    return _controllerName.text.isNotEmpty &&
        _controllerDate.text.isNotEmpty &&
        _controllerTemps.text.isNotEmpty &&
        _controllerNm.text.isNotEmpty &&
        _controllerDescription.text.isNotEmpty;
  }

  void _onPressedAction() {
    if (_areFieldsFilled()) {
      _saveFormDataToFirebase();
      Navigator.pushNamed(context, '/paymentview');
    } else {
      _showNotification("Veuillez remplir tous les champs.");
    }
  }

  void _showNotification(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
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
          "Envoi du Demande",
          style: TextStyle(color: Colors.black),
        ),
        actions: [],
      ),
      key: _scaffoldKey,
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          FormContainerWidget(
            controller: _controllerName,
            hintText: "Nom et prénom",
          ),
          const SizedBox(height: 24),
          FormContainerWidget(
            controller: _controllerDate,
            hintText: "Date",
            readOnly: true,
            onTap: () {
              _selectDate(context);
            },
          ),
          const SizedBox(height: 24),
          FormContainerWidget(
            controller: _controllerTemps,
            hintText: "Temps",
            readOnly: true,
            onTap: () {
              _selectTime(context);
            },
          ),
          const SizedBox(height: 24),
          FormContainerWidget(
            controller: _controllerNm,
            hintText: "Numéro de téléphone",
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
          ),
          const SizedBox(height: 24),
          FormContainerWidget(
            controller: _controllerDescription,
            hintText: "Description",
          ),
          const SizedBox(height: 24),
          Center(
            child: isLoading
                ? Column(
                    children: [
                      LinearProgressIndicator(
                        value: _uploadProgress,
                        minHeight: 10,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'En cours: ${(100 * _uploadProgress).toStringAsFixed(2)}%',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  )
                : ElevatedButton(
                    onPressed: _uploadFile,
                    child: Text("Telecharger fichier"),
                  ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: _onPressedAction,
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all<Size>(
                    Size(70, 30),
                  ),
                ),
                child: Text("Envoyer"),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_areFieldsFilled()) {
                    _uploadFormData();
                    Navigator.pushNamed(context, '/paymentview');
                  } else {
                    _showNotification("Veuillez remplir tous les champs.");
                  }
                },
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all<Size>(
                    Size(70, 30),
                  ),
                ),
                child: Text("Modifier"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class FormContainerWidget extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool readOnly;
  final VoidCallback? onTap;
  final TextInputType keyboardType;
  final List<TextInputFormatter> inputFormatters;

  const FormContainerWidget({
    Key? key,
    required this.controller,
    required this.hintText,
    this.readOnly = false,
    this.onTap,
    this.keyboardType = TextInputType.text,
    this.inputFormatters = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(),
      ),
    );
  }
}
