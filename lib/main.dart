import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:perspro/firebase_options.dart';
import 'package:perspro/pages/connecter.dart';
import 'package:perspro/pages/register.dart';
import 'pages/IntroPage.dart';
import 'pages/demandeform.dart';
import 'pages/menupage.dart';
import 'pages/payment.dart';

Future<void> main() async {
  
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: IntroPage(),
        routes: {
          '/IntroPage': (context) => const IntroPage(),
          '/menupage': (context) => const Menupage(),
          '/demandeform': (context) => const DemandPage(),
          '/paymentview': (context) => PaymentView(),
          '/authscreen': (context) => AuthScreen(),
          '/register':(context) => SignUpPage(),
        });
  }
}
