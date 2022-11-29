// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:login_project/constats.dart';

import 'package:login_project/screen/users_list_screen.dart';
import 'package:login_project/widgets/custom_button.dart';
import 'package:login_project/widgets/textfield_usable.dart';
import 'package:lottie/lottie.dart';

bool itIsSignUp = false;
String? mainheading;
String? prefixText;
String? postfixText;

login() {
  if (itIsSignUp == false) {
    mainheading = 'Login';
    prefixText = "Don't have an account?  ";
    postfixText = 'Register';
  } else {
    mainheading = 'Sign Up';
    prefixText = ""
        "Already have an account?  ";
    postfixText = 'Login';
  }
}

class LoginSignupScreen extends StatefulWidget {
  const LoginSignupScreen({Key? key}) : super(key: key);

  @override
  State<LoginSignupScreen> createState() => _LoginSignupScreenState();
}

class _LoginSignupScreenState extends State<LoginSignupScreen> {
  TextEditingController emailctr = TextEditingController();
  TextEditingController passwordctr = TextEditingController();
  TextEditingController usernamectr = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    login();
    super.initState();
  }

  final ImagePicker _picker = ImagePicker();
  File? imageFile;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: size.height,
        width: size.width,
        decoration: BoxDecoration(color: Colors.white),
        child: Stack(
          children: [
            itIsSignUp
                ? Align(
                    alignment: Alignment(-.9, -.8),
                    child: InkWell(
                      onTap: () {
                        imagePick(size);
                      },
                      child: CircleAvatar(
                        radius: 24,
                        foregroundImage:
                            imageFile==null?AssetImage('assets/images/blank-profile.png'):
                                FileImage(imageFile!)as ImageProvider,
                      ),
                    ))
                : SizedBox(),
            Column(
              children: [
                Lottie.asset(
                    height: size.height * .35,
                    'assets/animation/chat_animation.json'),
                Text(
                  mainheading!,
                  style: GoogleFonts.bebasNeue(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 10),
                ),
                SizedBox(
                  height: size.height * 0.05,
                ),
                TextFieldUsable(
                    labelText: 'Email ID',
                    icon: Icons.alternate_email,
                    txtctr: emailctr,
                    ispassword: false),
                SizedBox(
                  height: size.height * 0.037,
                ),
                TextFieldUsable(
                    labelText: 'Password',
                    icon: Icons.lock_open_rounded,
                    txtctr: passwordctr,
                    ispassword: true),
                SizedBox(
                  height: size.height * 0.037,
                ),
                itIsSignUp
                    ? TextFieldUsable(
                        labelText: 'User Name',
                        icon: Icons.person,
                        txtctr: usernamectr,
                        ispassword: false)
                    : Align(
                        alignment: AlignmentDirectional.topEnd,
                        child: SizedBox(
                          height: size.height * .02,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: size.width * .07),
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(
                                  color: Colors.blue[800],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                          ),
                        ),
                      ),
                SizedBox(
                  height: size.height * 0.025,
                ),
                CustomButton(
                  label: mainheading!,
                  email: emailctr,
                  password: passwordctr,
                  username: usernamectr,
                  photo: imageFile,
                ),
                SizedBox(
                  height: size.height * 0.025,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * .08),
                  child: Row(
                    children: [
                      Expanded(
                          child: Divider(
                        color: Colors.grey[400],
                        thickness: 1,
                      )),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: size.width * .06),
                        child: Text('OR',
                            style: TextStyle(
                                color: Colors.grey[500],
                                fontWeight: FontWeight.w500)),
                      ),
                      Expanded(
                          child: Divider(
                        color: Colors.grey[400],
                        thickness: 1,
                      ))
                    ],
                  ),
                ),
                SizedBox(
                  height: size.height * 0.03,
                ),
                InkWell(
                  onTap: () {
                    signInWithGoogle(context);
                  },
                  child: Container(
                    width: size.width * .85,
                    height: size.height * .055,
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: size.width * .25,
                          child: Center(
                            child: CircleAvatar(
                              foregroundImage:
                                  AssetImage('assets/images/googleicon.png'),
                              backgroundColor: Colors.white10,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: size.width * .03),
                            child: Text(
                              'Login with Google',
                              style: TextStyle(
                                  color: Colors.grey[500],
                                  fontWeight: FontWeight.w500,
                                  fontSize: 17),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.0374,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(prefixText!,
                        style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 16,
                            fontWeight: FontWeight.w500)),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          itIsSignUp = !itIsSignUp;
                          login();
                        });
                      },
                      child: Text(
                        postfixText!,
                        style: TextStyle(
                            color: Colors.blue[800],
                            fontSize: 17,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
  void imagePick(Size size){
    SnackBar snackBar = SnackBar(
        backgroundColor: Colors.grey[200],
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(
              onTap: () async{
                // print('object');
                var photo = await _picker.pickImage(source: ImageSource.camera);
                setState(() {
                  if (photo != null) {
                    imageFile = File(photo.path);
                  }
                });
              },
              child: Container(
                height: size.height * .05,
                width: size.width*.25,
                decoration: BoxDecoration(
                    color: Colors.blue[500],
                    borderRadius: BorderRadius.circular(8)),
                child: Center(
                  child: Text('Camera', style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w500, fontSize: 16),),
                ),
              ),
            ),
            InkWell(
              onTap: () async{
                final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                setState(() {
                  if (image != null) {
                    imageFile = File(image.path);
                  }
                });
              },
              child: Container(
                height: size.height * .05,
                width: size.width*.25,
                decoration: BoxDecoration(
                    color: Colors.blue[500],
                    borderRadius: BorderRadius.circular(8)),
                child: Center(
                  child: Text('Gallery', style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w500, fontSize: 16),),
                ),
              ),
            )
          ],
        ));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    // var file= await Ima
  }
}



Future<UserCredential> signInWithGoogle(BuildContext context) async {
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  // Constants.email=googleUser?.email;
  final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  // Once signed in, return the UserCredential
  UserCredential usercred = await FirebaseAuth.instance
      .signInWithCredential(credential)
      .then((value) async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) {
          return UsersListScreen();
        },
      ),
    );

    return value;
  });
  Constants.email = usercred.user!.email;
  Constants.photoUrl = usercred.user!.photoURL;
  Constants.uid = usercred.user!.uid;
  Constants.username = usercred.user!.displayName;

  var dataFire = await FirebaseFirestore.instance.collection("Users").get();
  var usersList = dataFire.docs;
  bool newUser = true;
  for (int i = 0; i < usersList.length; i++) {
    // print(usersList[i]['email']);
    if (Constants.email == usersList[i]['email']) {
      newUser = false;
    }
  }
  if (newUser == true) {
    FirebaseFirestore.instance.collection("Users").add({
      'email': Constants.email,
      'photoUrl': Constants.photoUrl,
      'uid': Constants.uid,
      'username': Constants.username
    });
  }
  return usercred;
}
