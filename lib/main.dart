import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:senior_project/firebase_options.dart';
import 'phone_verification_page.dart';
import '_LandingPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '_SplashPage.dart';
import '_Chatbot.dart';
import '_BookingScreenState.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await dotenv.load(fileName: "K.env");
  final prefs = await SharedPreferences.getInstance();
  final hasSeenLanding = prefs.getBool('seenLandingPage') ?? false;
  runApp(MyApp(hasSeenLanding: hasSeenLanding));
}

class MyApp extends StatelessWidget {
  final bool hasSeenLanding;
  const MyApp({super.key, required this.hasSeenLanding});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      routes: {
        '/landing': (context) => const LandingPage(),
        '/phoneVerification': (context) => const PhoneVerificationPage(),
        '/chatbot': (context) => const ChatbotPage(),
        '/booking': (context) {
          final args = ModalRoute
              .of(context)!
              .settings
              .arguments as Map<String, dynamic>?;
          return BookingScreen(
            service: args?['service'],
            date: args?['date'],
            time: args?['time'],
          );
        },
      });
  }
}
