import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:login_project/screen/users_list_screen.dart';

import '../constats.dart';

class CustomButton extends StatelessWidget {
  CustomButton(
      {Key? key,
      required this.label,
      required this.email,
      required this.username,
      required this.password,required this.photo})
      : super(key: key);
  String label;
  TextEditingController email;
  TextEditingController password;
  TextEditingController username;
  File? photo;
  String imageurl='https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png';
  bool isClickable=true;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return InkWell(
      onTap: isClickable==true?() async {
        isClickable=false;
        FocusScope.of(context).unfocus();
        if (label == 'Login') {
          // print('login success');
          try{
            await FirebaseAuth.instance
                .signInWithEmailAndPassword(email: email.text, password: password.text)
                .then((value) {
              Constants.email = value.user!.email;
              Constants.uid = value.user!.uid;
              Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) {
                  return UsersListScreen();
                },
              ));
            });
          }catch(e){
            String errors = e.toString();
            List<String> word_l = errors.split(" ");
            String error = word_l.sublist(1,word_l.length).join(" ");
            // print(error);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
            // print("${e.toString()}.............................it is error");
            // print(e.message);
          }
        } else {
          // print('sign up success');
          try{
            await FirebaseAuth.instance
                .createUserWithEmailAndPassword(email: email.text, password: password.text)
                .then((value)async {
                  if(photo!=null) {
                final imageStorage = FirebaseStorage.instance
                    .ref()
                    .child('${value.user!.email}');
                await imageStorage.putFile(photo!);
                imageurl=await imageStorage.getDownloadURL();
                // print(imageurl);

              }
              Constants.email = value.user!.email;
              Constants.photoUrl = imageurl;
              Constants.uid = value.user!.uid;
              Constants.username = username.text;

              FirebaseFirestore.instance.collection("Users").add({
                'email': Constants.email,
                'photoUrl': Constants.photoUrl,
                'uid': Constants.uid,
                'username': Constants.username
              });
              await Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) {
                  return UsersListScreen();
                },
              ));
            });
          }catch (e){
            String errors = e.toString();
            List<String> word_l = errors.split(" ");
            String error = word_l.sublist(1,word_l.length).join(" ");
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
          }
        }
        isClickable=true;
      }:null,
      child: Container(
        width: size.width * .85,
        height: size.height * .055,
        decoration: BoxDecoration(
            color: Colors.blue[500], borderRadius: BorderRadius.circular(10)),
        child: Center(
            child: Text(
          label,
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w500, fontSize: 17),
        )),
      ),
    );
  }
}
