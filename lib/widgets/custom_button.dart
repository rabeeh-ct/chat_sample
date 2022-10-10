import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_project/home_page.dart';

class CustomButton extends StatelessWidget {
   CustomButton({Key? key,
    required  this.label,
    required  this.email,
    required  this.password}) : super(key: key);
  String label;
  TextEditingController email;
  TextEditingController password;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(Colors.blue[100]),
            foregroundColor: MaterialStatePropertyAll(Colors.black54)),
        onPressed: () {
          if (label == 'Login') {
            print('login success');
            FirebaseAuth.instance
                .signInWithEmailAndPassword(email: email.text, password: password.text)
                .then((value) {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return HomePage();
                },
              ));
            });
          } else {
            print('sign up success');
            FirebaseAuth.instance
                .createUserWithEmailAndPassword(email: email.text, password: password.text)
                .then((value) {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return HomePage();
                },
              ));
            });

          }
        },
        child: Text(label));
  }
}
