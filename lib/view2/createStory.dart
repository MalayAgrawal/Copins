import 'package:finalproj/view2/chatpage.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:io';
import 'package:finalproj/helper/constants.dart';
import 'package:finalproj/services/database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:finalproj/widget/widget.dart';
import 'package:image_picker/image_picker.dart';

class createStory extends StatefulWidget {
  @override
  _createStoryState createState() => _createStoryState();
}

class _createStoryState extends State<createStory> {
  File _image;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  uploadStory(BuildContext context) async {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => homepage()));
    String filename = basename(_image.path);
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(filename);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    String imgUrl = await firebaseStorageRef.getDownloadURL();
    var ti = DateTime.now();
    Map<String, dynamic> userDataMap = {
      Random().nextInt(999).toString(): [
        ti,
        imgUrl,
        Constants.myName,
        tagText.text
      ]
    };
    DatabaseMethods().addStory(userDataMap);
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
                          height: 380,
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
                  SizedBox(height: 80),
                  Form(
                    child: Column(
                      children: [
                        TextFormField(
                          controller: tagText,
                          validator: (val) {},
                          decoration: textFieldInputDecoration("tag"),
                        ),
                        SizedBox(
                          height: 30,
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
                            uploadStory(context);
                          },
                        )
                      ],
                    ),
                  ),
                ]))));
  }
}
