import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:login_project/constats.dart';
import 'package:login_project/screen/chat_screen.dart';

import 'login_signUp_screen.dart';

class UsersListScreen extends StatelessWidget {
  const UsersListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
          toolbarHeight: size.height * .08,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(30),
              // bottomLeft: Radius.circular(30),
            ),
          ),
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FutureBuilder(
                future: fn(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    print(snapshot.error);
                    return Text('no name...........');
                  } else {
                    return CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.white54,
                      foregroundImage:
                          NetworkImage(Constants.photoUrl ?? 'no photo'),
                    );
                  }
                }),
          ),
          title: FutureBuilder(
              future: fn(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SizedBox();
                } else if (snapshot.hasError) {
                  print(snapshot.error);
                  return Text('no name...........');
                } else {
                  return Text(
                    Constants.name ?? 'no name',
                    style: TextStyle(color: Colors.black),
                  );
                }
              }),
          actions: [
            IconButton(
                onPressed: () {
                  GoogleSignIn().signOut();
                  FirebaseAuth.instance.signOut().then((value) {
                    Constants.photoUrl = null;
                    Constants.name = null;
                    Constants.username = null;
                    Constants.email = null;
                    Constants.uid = null;
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) {
                        return LoginSignupScreen();
                      },
                    ));
                  });
                },
                icon: Icon(
                  Icons.logout,
                  color: Colors.black,
                ))
          ],
          elevation: 0,
          backgroundColor: Colors.white),
      body: Padding(
        padding: EdgeInsets.only(top: size.height * .01),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("Users").snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else {
              var usersList = snapshot.data!.docs;
              return ListView.separated(
                itemCount: usersList.length,
                itemBuilder: (context, index) {
                  if (Constants.uid != usersList[index]['uid']) {
                    return Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: size.width * .04),
                      child: Container(
                        height: size.height * .09,
                        // width: size.width*.5,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8)),
                        child: InkWell(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChatScreen(
                                        frdPhotoUrl: usersList[index]
                                            ['photoUrl'],
                                        frdUsername: usersList[index]
                                            ['username'],
                                        endUser: usersList[index],
                                      ))),
                          child: Container(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: size.width * .03),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.white,
                                      radius: 25,
                                      foregroundImage: NetworkImage(
                                          usersList[index]['photoUrl'])),
                                  SizedBox(width: size.width*.06,),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        usersList[index]['username'],
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16),
                                      ),
                                      // Text('')
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // child: ListTile(
                          //
                          //   title: Text(usersList[index]['username']),
                          //   leading: SizedBox(
                          //     child: CircleAvatar(
                          //       radius: 25,
                          //         foregroundImage:
                          //         NetworkImage(usersList[index]['photoUrl'])),
                          //   ),
                          // ),
                        ),
                      ),
                    );
                  } else {
                    return SizedBox();
                  }
                },
                separatorBuilder: (context, index) {
                  return SizedBox(
                    height: size.height * .01,
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }

  fn() async {
    var firebasedata =
        await FirebaseFirestore.instance.collection("Users").get();
    List user = firebasedata.docs;
    for (int i = 0; i < user.length; i++) {
      if (user[i]['email'] == Constants.email) {
        Constants.name = user[i]['username'];
        Constants.photoUrl = user[i]['photoUrl'];
      }
    }
    // print(user);
    return user;
  }
}
