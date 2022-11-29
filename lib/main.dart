
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:login_project/constats.dart';
import 'package:login_project/screen/login_signUp_screen.dart';
import 'package:login_project/screen/users_list_screen.dart';

void main() async {
  WidgetsFlutterBinding();
  await Firebase.initializeApp();
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
   MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // fn();
            // print(Constants.user);
            // print('${snapshot.data!.uid},,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,');
            Constants.email=snapshot.data!.email;
            Constants.photoUrl=snapshot.data!.photoURL??Constants.photoUrl;
            Constants.username=snapshot.data!.displayName??Constants.name;
            Constants.uid=snapshot.data!.uid;
            return UsersListScreen();
          } else {
            return LoginSignupScreen();
          }
        },
      ),
    );
  }

}
