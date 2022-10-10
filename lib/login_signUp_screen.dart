// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:login_project/constats.dart';
import 'package:login_project/home_page.dart';
import 'package:login_project/widgets/custom_button.dart';

bool itIsSignUp = false;
String? mainheading;
String? prefixText;
String? postfixText;

login() {
  print('loginfn');
  if (itIsSignUp == false) {
    mainheading = 'Login';
    prefixText = "don't have an account  ";
    postfixText = 'Sign Up';
  } else {
    mainheading = 'Sign Up';
    prefixText = "if you have an account  ";
    postfixText = 'Login';
  }
}

class LoginSignupScreen extends StatefulWidget {
  const LoginSignupScreen({Key? key}) : super(key: key);

  @override
  State<LoginSignupScreen> createState() => _LoginSignupScreenState();
}

class _LoginSignupScreenState extends State<LoginSignupScreen> {
  TextEditingController usernamectr = TextEditingController();
  TextEditingController passwordctr = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    login();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.white, Colors.blue],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
        ),
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 150,
              ),
              text_usable(heading: mainheading!),
              SizedBox(
                height: 60,
              ),
              textfield_Usable(
                  labelText: 'Username',
                  icon: Icon(Icons.person),
                  txtctr: usernamectr,
                  ispassword: false),
              SizedBox(
                height: 30,
              ),
              textfield_Usable(
                  labelText: 'Password',
                  icon: Icon(Icons.password),
                  txtctr: passwordctr,
                  ispassword: true),
              SizedBox(
                height: 30,
              ),
              button_usable(
                  label: mainheading!,
                  context: context,
                  email: usernamectr,
                  password: passwordctr),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(prefixText!,
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          itIsSignUp = !itIsSignUp;
                          login();
                        });
                        print(itIsSignUp.toString());
                      },
                      child: Text(postfixText!,
                          style: TextStyle(color: Colors.red, fontSize: 20))),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                child: CircleAvatar(
                  foregroundImage: AssetImage('assets/googleicon.png'),
                  backgroundColor: Colors.white10,
                ),
                onTap: () {
                  signInWithGoogle(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget text_usable({
  required String heading,
}) {
  return Text(
    heading,
    style: GoogleFonts.bebasNeue(
        fontSize: 40, fontWeight: FontWeight.bold, letterSpacing: 10),
  );
}

Widget textfield_Usable(
    {required String labelText,
    required Icon icon,
    required TextEditingController txtctr,
    required bool ispassword}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
          color: Colors.grey[200], borderRadius: BorderRadius.circular(30)),
      child: TextFormField(
        obscureText: ispassword,
        controller: txtctr,
        decoration: InputDecoration(
          prefixIcon: icon,
          border: InputBorder.none,
          labelText: labelText,
        ),
      ),
    ),
  );
}

Widget button_usable(
    {required String label,
    required BuildContext context,
    required TextEditingController email,
    required TextEditingController password}) {
  return CustomButton(
    label: label,
    email: email,
    password: password,
  );
}
signInWithGoogle( BuildContext context) async {
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  Constants.email=googleUser?.email;
  print(Constants.email);
  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  // Once signed in, return the UserCredential
  await FirebaseAuth.instance.signInWithCredential(credential).then((value) => Navigator.push(context, MaterialPageRoute(
    builder: (context) {
      return HomePage();
    },
  )));
}
