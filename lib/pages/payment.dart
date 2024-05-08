import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:perspro/global/toast.dart';

class PaymentView extends StatefulWidget {
  @override
  _PaymentViewState createState() => _PaymentViewState();
}

class _PaymentViewState extends State<PaymentView> {
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController expiryController = TextEditingController();
  TextEditingController cvvController = TextEditingController();
  double amount = 0.0;

  void processPayment() {
    if (cardNumberController.text.isNotEmpty &&
        expiryController.text.isNotEmpty &&
        cvvController.text.isNotEmpty) {
      print('Processing payment of ...');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Success du paiement"),
            content: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    "Le paiement a été effectué avec succès! 😀",
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.pushNamed(context, "/authscreen");
                  showToast(message: "Successfully signed out");
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Erreur"),
            content: Text(
              "Veuillez remplir tous les champs pour effectuer le paiement.",
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  trigerNotification() {
    AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: 10,
            channelKey: 'basic_channel',
            title: 'Pubpro',
            body:
                'Votre demande a été envoyé avec succès en attendant la validation de la part de bureau de service'));
  }

  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> Notification() async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    print('Token: $fCMToken');
  }

  @override
  Widget build(BuildContext context) {
    AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'basic_channel',
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic tests',
        ),
      ],
      debug: true,
    );

    void initState() {
      AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
        if (isAllowed) {
          AwesomeNotifications().requestPermissionToSendNotifications();
        }
      });
      super.initState();
    }

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 152, 194, 245),
      appBar: AppBar(
        title: Text('Paiement'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Entrer les détails de la carte :',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Image.asset(
                    'lib/images/visa_card.png', // Replace with Visa card image path
                    height: 100, // Adjust the height as needed
                  ),
                ),
                SizedBox(width: 20),
                Center(
                  child: Image.asset(
                    'lib/images/mastercard.png', // Replace with Mastercard image path
                    height: 100, // Adjust the height as needed
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.0),
            TextFormField(
              controller: cardNumberController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Numéro de carte',
              ),
            ),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: expiryController,
                    keyboardType: TextInputType.datetime,
                    decoration: InputDecoration(
                      labelText: 'Date expiration (MM/YY)',
                    ),
                  ),
                ),
                SizedBox(width: 10.0),
                Expanded(
                  flex: 1,
                  child: TextFormField(
                    controller: cvvController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'CVV',
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            Text(
              'Prix :',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0),
            Text(
              'Le prix à payer est 1.5 DT',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20.0),
            Expanded(
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    processPayment();
                    Notification();
                    trigerNotification();
                  },
                  child: Text(
                    'Payer',
                    style: TextStyle(fontSize: 25),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
