import 'package:flutter/material.dart';

class TextFieldUsable extends StatelessWidget {
  TextFieldUsable(
      {Key? key,
      required String this.labelText,
      required IconData this.icon,
      required TextEditingController this.txtctr,
      required bool this.ispassword})
      : super(key: key);
  String labelText;
  IconData icon;
  TextEditingController txtctr;
  bool ispassword;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width*.9,
      height: size.height * 0.04,
      decoration: BoxDecoration(
        // color: Colors.grey[200],
        // borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(icon,color: Colors.grey[500]),
          Container(
            width: size.width*.7,
            height: size.height * 0.05,
            child: TextField(
              obscureText: ispassword,
              controller: txtctr,
              decoration: InputDecoration(
                hintStyle: TextStyle(color: Colors.grey[500],fontWeight: FontWeight.w500),
                hintText: labelText,
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey[400]!)),
                border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey[400]!)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
