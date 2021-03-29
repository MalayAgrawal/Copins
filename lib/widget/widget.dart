import 'package:flutter/material.dart';

InputDecoration textFieldInputDecoration(String hintText) {
  return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.white60),
      focusedBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
      enabledBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)));
}

TextStyle simpleTextStyle() {
  return TextStyle(color: Colors.white, fontSize: 18);
}

TextStyle simpleTextStyle1() {
  return TextStyle(color: Colors.black87, fontSize: 18);
}

Widget loader2() {
  return Scaffold(
    body: Container(
      decoration: BoxDecoration(color: Colors.blueGrey[900]),
      child: Column(
        children: [
          SizedBox(
            height: 130,
          ),
          Center(
            child: Image(
              height: 400,
              width: 400,
              image: AssetImage("assets/images/loading2.gif"),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Text(
            "Loading...",
            style: TextStyle(
                color: Colors.yellow[500].withOpacity(0.7),
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                fontSize: 23),
          ),
        ],
      ),
    ),
  );
}

Widget loader1() {
  return Scaffold(
    body: SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(color: Colors.blueGrey[900]),
        child: Column(
          children: [
            SizedBox(
              height: 150,
            ),
            Center(
              child: Image(
                height: 350,
                width: 300,
                image: AssetImage("assets/images/loading1.gif"),
              ),
            ),
            Text(
              "Searching...",
              style: TextStyle(
                  color: Colors.yellow[500].withOpacity(0.7),
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  fontSize: 22),
            ),
            SizedBox(
              height: 500,
            ),
          ],
        ),
      ),
    ),
  );
}
