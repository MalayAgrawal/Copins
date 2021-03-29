import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalproj/helper/constants.dart';
import 'package:finalproj/services/database.dart';
import 'package:finalproj/view3/postspage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:finalproj/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class createPost extends StatefulWidget {
  @override
  _createPostState createState() => _createPostState();
}

class _createPostState extends State<createPost> {
  File _image;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  uploadPost(BuildContext context) async {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => mainHomepage()));
    String filename = basename(_image.path);
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(filename);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    String imgUrl = await firebaseStorageRef.getDownloadURL();
    Map<String, dynamic> userDataMap = {
      "dp": Constants.myDp,
      "caption": captionText.text,
      "tag": tagText.text,
      "img": imgUrl,
      "coments": ["default"],
      "likes": [Constants.myName],
      "author": Constants.myName,
      "time": FieldValue.serverTimestamp(),
    };
    DatabaseMethods().addPost(userDataMap);
    print("done");
  }

  TextEditingController captionText = new TextEditingController();
  TextEditingController tagText = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blueGrey[900],
        body: SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 0),
                child: Column(children: [
                  SizedBox(height: 100),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          getImage();
                        },
                        child: Container(
                          width: 300,
                          height: 300,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            color: Colors.grey[100],
                          ),
                          child: (_image != null)
                              ? Image.file(
                                  _image,
                                )
                              : Container(),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 100),
                  Form(
                    child: Column(
                      children: [
                        TextFormField(
                          controller: captionText,
                          decoration: textFieldInputDecoration("Caption"),
                          validator: (val) {},
                        ),
                        TextFormField(
                          controller: tagText,
                          validator: (val) {},
                          decoration: textFieldInputDecoration("tag"),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          child: Container(
                            padding: EdgeInsets.only(top: 3),
                            height: 30,
                            width: 100,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.white),
                            child: Text(
                              "Submit",
                              style: simpleTextStyle1(),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          onTap: () {
                            uploadPost(context);
                          },
                        )
                      ],
                    ),
                  ),
                ]))));
  }
}
