// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:login_project/login_signUp_screen.dart';

import 'constats.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController chattxt = TextEditingController();
  List<String> chats = [];
  int i = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              radius: 10,
              backgroundColor: Colors.white54,
              // Container(
              //   decoration: BoxDecoration(color: Colors.white30,shape: BoxShape.circle,),
              child: Icon(Icons.person, color: Colors.black87),
            ),
          ),
          title: Text('User one'),
          actions: [
            IconButton(
                onPressed: () {
                  GoogleSignIn().signOut();
                  FirebaseAuth.instance.signOut().then((value) {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) {
                        return LoginSignupScreen();
                      },
                    ));
                  });
                },
                icon: Icon(Icons.logout))
          ],
          elevation: 0,
          backgroundColor: Colors.blue),
      body: Column(
        children: [
          Expanded(child: bodyPart(chats)),
          Container(
            height: 65,
            decoration: BoxDecoration(
              color: Colors.blue[200],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: TextField(
                controller: chattxt,
                decoration: InputDecoration(
                  fillColor: Colors.white30,
                  filled: true,
                  hintText: 'Message',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  prefixIcon: Icon(Icons.chat, color: Colors.black54),
                  suffixIcon: IconButton(
                      onPressed: () {
                        print('send icon pressed');

                        FirebaseFirestore.instance.collection('message').add({
                          'userName': Constants.email,
                          'message': chattxt.text,
                          'time': DateTime.now().toString()
                        });

                        setState(() {
                          chats.add(chattxt.text);
                          chattxt.text = '';
                        });
                        print(chats);
                      },
                      icon: Icon(
                        Icons.send,
                        color: Colors.black54,
                      )),
                ),
              ),
            ),
          )
        ],
      ),
      backgroundColor: Colors.blue[200],
    );
  }
}

Widget bodyPart(List chats) {
  return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('message').snapshots(),
      builder: (context, snapshot) {

        if(snapshot.data!=null) {
          var temp3=snapshot.data!.docs;
          temp3.sort(
                (b,a) {
              // return a.data()['time'].compareTo(b.data()['time']);
                  var _first=DateTime.parse(a.data()['time']);
                  var _second=DateTime.parse(b.data()['time']);
                  return _first.compareTo(_second);
            },
          );
          return ListView.separated(
            reverse: true,
            separatorBuilder: (context, index) {
              return SizedBox(
                height: 5,
              );
            },
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              print(snapshot.data!.docs[index].data()['time']);

              var temp = snapshot.data!.docs;
              String? user = temp3[index].data()['userName'];
              print('user is $user');
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  ' ${temp3[index].data()['message']} ',
                  textAlign:
                      user == Constants.email ? TextAlign.end : TextAlign.start,
                  style: GoogleFonts.notoSans(
                    backgroundColor: Colors.white30,
                    height: 1.3,
                    fontSize: 20,
                  ),
                ),
              );
            },
          );
        }else{
          return Text(snapshot.error.toString());
        }
      });
}
