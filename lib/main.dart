import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_nic/screens/dashboard_screen.dart';
import 'package:firebase_nic/screens/login_screen.dart';
import 'package:flutter/material.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: 'AIzaSyAr_MQ6gKRmIyRQcsJVu0LszfMLDkHAzL0',
        appId: '1:489265812753:android:6547a7d4d418a0c124e8b0',
        messagingSenderId: '489265812753',
        projectId: 'fir-nic-28287',
        storageBucket: 'fir-nic-28287.appspot.com',

    ),

  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(centerTitle: true,color: Colors.teal,titleTextStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20)),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:  (FirebaseAuth.instance.currentUser != null && FirebaseAuth.instance.currentUser!.emailVerified)

          ? const DashboardScreen()

          : const LoginScreen(),
    );

  }
}



