
import 'package:bubble/bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:login_project/screen/login_signUp_screen.dart';

import '../constats.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen(
      {Key? key,
      required this.frdPhotoUrl,
      required this.frdUsername,
      required this.endUser})
      : super(key: key);
  String frdPhotoUrl;
  String frdUsername;
  var endUser;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController chattxt = TextEditingController();
  List<String> chats = [];
  int i = 0;
  String uid = '';
  String email = '';
  String phtourl = '';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
          toolbarHeight: size.height * .08,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(30),
              // bottomLeft: Radius.circular(30),
            ),
          ),
          leadingWidth: size.width * .22,
          leading: Row(
            children: [
              // SizedBox(
              //   width: size.width * .008,
              // ),
              IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  )),
              CircleAvatar(
                radius: 18,
                backgroundColor: Colors.white54,
                foregroundImage: NetworkImage(widget.frdPhotoUrl ?? 'no photo'),
              ),
            ],
          ),
          title: Text(widget.frdUsername ?? 'no username',
              style: TextStyle(color: Colors.black)),
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
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('message')
                    .doc('${Constants.uid}')
                    .collection('${widget.endUser['uid']}')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: SizedBox(
                        width: size.width * .1,
                        height: size.width * .1,
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  } else {
                    var userchat = snapshot.data!.docs;
                    return StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('message')
                            .doc('${widget.endUser['uid']}')
                            .collection('${Constants.uid}')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            var enduserchat = snapshot.data!.docs;
                            List chatList = new List.from(userchat)
                              ..addAll(enduserchat);
                            chatList.sort(
                              (b, a) {
                                var _first = DateTime.parse(a.data()['time']);
                                var _second = DateTime.parse(b.data()['time']);
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
                              itemCount: chatList.length,
                              itemBuilder: (context, index) {
                                String? user = Constants.uid;
                                // print(
                                //     '${user}.............................it is user');
                                // (
                                //     '${widget.endUser['uid']}.............................it is enduser');
                                return Bubble(
                                  color: user == chatList[index].data()['uid']
                                      ? Colors.indigo[400]
                                      : Colors.white,
                                  margin: BubbleEdges.only(top: 10),
                                  alignment:
                                      user == chatList[index].data()['uid']
                                          ? Alignment.topRight
                                          : Alignment.topLeft,
                                  nip: user == chatList[index].data()['uid']
                                      ? BubbleNip.rightBottom
                                      : BubbleNip.leftBottom,
                                  child: Text(
                                    '${chatList[index].data()['message']}',
                                    style: GoogleFonts.notoSans(
                                      height: 1.3,
                                      fontSize: 20,
                                      color:
                                          user == chatList[index].data()['uid']
                                              ? Colors.white
                                              : Colors.black,
                                    ),
                                  ),
                                );
                              },
                            );
                          } else {
                            return Text('');
                          }
                        });
                  }
                }),
          ),
          SizedBox(
            height: size.height * .005,
          ),
          //chat typing area
          Container(
            height: size.height * .1,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                // topRight: Radius.circular(30),
              ),
            ),
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * .05),
                child: Container(
                  padding: EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(30)),
                  child: TextField(
                    cursorColor: Colors.grey[500],
                    controller: chattxt,
                    decoration: InputDecoration(
                      hintText: 'Type here...',
                      hintStyle: TextStyle(
                          color: Colors.grey[500], fontWeight: FontWeight.w400),
                      border: InputBorder.none,
                      suffixIcon: IconButton(
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection('message')
                              .doc('${Constants.uid}')
                              .collection('${widget.endUser['uid']}')
                              .add({
                            'userName': Constants.email,
                            'uid': Constants.uid,
                            'message': chattxt.text,
                            'time': DateTime.now().toString(),
                          });

                          setState(() {
                            chats.add(chattxt.text);
                            chattxt.text = '';
                          });
                        },
                        icon: Icon(
                          Icons.send,
                          color: Colors.grey[500],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
