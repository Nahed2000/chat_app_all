
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'screen/auth/registration.dart';
import 'screen/auth/signin.dart';
import 'screen/auth/welcome.dart';
import 'screen/chat.dart';
import 'screen/lunch_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/lunch_screen',
      routes: {
        '/welcome_screen': (context) => const WelcomeScreen(),
        '/lunch_screen': (context) => const LunchScreen(),
        '/registration_screen': (context) => const RegistrationScreen(),
        '/signIn_screen': (context) => const SignInScreen(),
        '/chat_screen': (context) =>  ChatScreen(),
      },
    );
  }
}