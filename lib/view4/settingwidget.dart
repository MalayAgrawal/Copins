import 'package:finalproj/helper/authenticate.dart';
import 'package:finalproj/services/database.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:finalproj/helper/constants.dart';
import 'package:finalproj/helper/helperfunction.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

File _image;
String imgUrl;
bool propic = false, pro = false;

@override
class setingEdit extends StatefulWidget {
  @override
  _setingEditState createState() => _setingEditState();
}

class _setingEditState extends State<setingEdit> {
  upImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  database() async {
    String fileName = basename(_image.path);
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(fileName);

    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);

    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;

    imgUrl = await firebaseStorageRef.getDownloadURL();
    DatabaseMethods().updateProfileImage(pro, imgUrl);
  }

  database2() async {
    String fileName = basename(_image.path);
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(fileName);

    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);

    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;

    imgUrl = await firebaseStorageRef.getDownloadURL();
    DatabaseMethods().updateWallImage(pro, imgUrl);
  }

  backtoup() {
    setState(() {
      _image = null;
      pro = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey[900],
      child: _image != null && pro == true
          ? Column(
              children: [
                Spacer(),
                Container(
                  child: Align(
                    alignment: Alignment.center,
                    child: (_image != null)
                        ? Image.file(_image)
                        : Image.asset("assets/images/profile.jpg"),
                  ),
                ),
                SizedBox(
                  height: 100,
                ),
                GestureDetector(
                    onTap: () {
                      database();
                      backtoup();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      padding: EdgeInsets.only(top: 6),
                      height: 40,
                      width: 300,
                      child: Text("submit",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 20, color: Colors.yellow[500])),
                    )),
                SizedBox(
                  height: 30,
                ),
                GestureDetector(
                    onTap: () {
                      backtoup();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      padding: EdgeInsets.only(top: 6),
                      height: 40,
                      width: 300,
                      child: Text("back",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 20, color: Colors.yellow[500])),
                    )),
                Spacer()
              ],
            )
          : _image != null && pro == false
              ? Column(
                  children: [
                    Spacer(),
                    Container(
                      child: Align(
                        alignment: Alignment.center,
                        child: (_image != null)
                            ? Image.file(_image)
                            : Image.asset("assets/images/profile.jpg"),
                      ),
                    ),
                    SizedBox(
                      height: 100,
                    ),
                    GestureDetector(
                        onTap: () {
                          database2();
                          backtoup();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.black12,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30))),
                          padding: EdgeInsets.only(top: 6),
                          height: 40,
                          width: 300,
                          child: Text("Submit",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 20, color: Colors.yellow[500])),
                        )),
                    GestureDetector(
                        onTap: () {
                          backtoup();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.black12,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30))),
                          padding: EdgeInsets.only(top: 6),
                          height: 40,
                          width: 300,
                          child: Text("Back",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 20, color: Colors.yellow[500])),
                        )),
                    Spacer(),
                  ],
                )
              : Column(
                  children: [
                    Spacer(),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      padding: EdgeInsets.only(top: 6),
                      height: 40,
                      width: 300,
                      child: GestureDetector(
                          onTap: () {
                            pro = true;
                            upImage();
                          },
                          child: Text(
                            "Update Profile Pic",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20, color: Colors.yellow[500]),
                          )),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      padding: EdgeInsets.only(top: 6),
                      height: 40,
                      width: 300,
                      child: GestureDetector(
                          onTap: () {
                            pro = false;
                            upImage();
                          },
                          child: Text(
                            "Update Wallpaper",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20, color: Colors.yellow[500]),
                          )),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      padding: EdgeInsets.only(top: 6),
                      height: 40,
                      width: 300,
                      child: GestureDetector(
                          onTap: () {
                            print("logout");
                            HelperFunctions.saveUserLoggedInSharedPreference(
                                false);
                            HelperFunctions.saveUserNameSharedPreference(null);
                            HelperFunctions.saveUserEmailSharedPreference(null);
                            HelperFunctions.saveUserImageSharedPreference(null);
                            Constants.myDp = null;
                            Constants.documentId = null;
                            Constants.following = null;
                            Constants.myName = null;
                            Constants.wallPaper = null;
                            Constants.hashtags = null;
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Authenticate()));
                          },
                          child: Text(
                            "LogOut",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20, color: Colors.yellow[500]),
                          )),
                    ),
                    Spacer(),
                  ],
                ),
    );
  }
}
