import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalproj/helper/constants.dart';
import 'package:finalproj/helper/helperfunction.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DatabaseMethods {
  Future<void> addUserInfo(userData, String nam) async {
    Firestore.instance.collection("users").add(userData).catchError((e) {
      print(e.toString());
    });
    Firestore.instance
        .collection("stories")
        .document(nam)
        .setData({'full_name': "fullName"});
    Firestore.instance
        .collection("stories")
        .document(nam)
        .updateData({'full_name': FieldValue.delete()});
  }

  Future<void> addPost(postData) async {
    await Firestore.instance.collection("posts").add(postData).catchError((e) {
      print(e.toString());
    });
  }

  Future<void> addStory(postData) async {
    await Firestore.instance
        .collection("stories")
        .document(Constants.myName)
        .updateData(postData);
  }

  Future getUserInfo(String email) async {
    return Firestore.instance
        .collection("users")
        .where("userEmail", isEqualTo: email)
        .getDocuments()
        .catchError((e) {
      print(e.toString());
    });
  }

  Future getUserInfo2(String myName) async {
    QuerySnapshot dataDoc = await Firestore.instance
        .collection("users")
        .where("userName", isEqualTo: myName)
        .getDocuments();
    Constants.documentId = dataDoc.documents[0].documentID;
    Constants.following = dataDoc.documents[0].data["Users"];
    Constants.hashtags = dataDoc.documents[0].data["hashtags"];
    Constants.wallPaper = dataDoc.documents[0].data["wallpaper"];
    Constants.realName = dataDoc.documents[0].data["RealName"];
    return dataDoc;
  }

  Future getStories1() async {
    List<dynamic> finalList = new List<dynamic>();
    for (int i = 0; i < Constants.following.length; i++) {
      try {
        await DatabaseMethods()
            .getStories2(Constants.following[i])
            .then((snapshots) {
          finalList.addAll(snapshots.data.values.toList());
        });
      } catch (e) {}
    }
    return finalList;
  }

  Future getStories2(String following) async {
    return Firestore.instance.collection("stories").document(following).get();
  }

  getPosts() {
    Stream<QuerySnapshot> user = null;
    if (!Constants.hashtags.isEmpty) {
      user = Firestore.instance
          .collection("posts")
          .orderBy("time", descending: true)
          .where("tag", whereIn: Constants.hashtags)
          .snapshots();
    }
    return user;
  }

  Future searchByName(String searchField) {
    return Firestore.instance
        .collection("users")
        .where('userName', isEqualTo: searchField)
        .getDocuments();
  }

  Future<bool> addChatRoom(chatRoom, chatRoomId) {
    Firestore.instance
        .collection("chatRoom")
        .document(chatRoomId)
        .setData(chatRoom)
        .catchError((e) {
      print(e);
    });
  }

  Future getChats(String chatRoomId) async {
    return Firestore.instance
        .collection("chatRoom")
        .document(chatRoomId)
        .collection("chats")
        .orderBy('time', descending: true)
        .snapshots();
  }

  Future<void> addMessage(String chatRoomId, chatMessageData) {
    Firestore.instance
        .collection("chatRoom")
        .document(chatRoomId)
        .collection("chats")
        .add(chatMessageData)
        .catchError((e) {
      print(e.toString());
    });
  }

  Future getUserChats(String itIsMyName) async {
    return await Firestore.instance
        .collection("chatRoom")
        .where('users', arrayContains: itIsMyName)
        .snapshots();
  }

  Future removeLike(var a) async {
    await Firestore.instance
        .collection("posts")
        .document(a.documentID)
        .updateData({
      "likes": FieldValue.arrayRemove([Constants.myName])
    });
  }

  Future addLike(var a) async {
    await Firestore.instance
        .collection("posts")
        .document(a.documentID)
        .updateData({
      "likes": FieldValue.arrayUnion([Constants.myName])
    });
  }

  Future addTag(String a, String b) async {
    await Firestore.instance
        .collection("users")
        .document(Constants.documentId)
        .updateData({
      "hashtags": FieldValue.arrayUnion([a])
    });
    await Firestore.instance
        .collection("TagsList")
        .document(b)
        .updateData(<String, dynamic>{"followers": FieldValue.increment(1)});
  }

  Future removeTag(String a, String b) async {
    await Firestore.instance
        .collection("users")
        .document(Constants.documentId)
        .updateData({
      "hashtags": FieldValue.arrayRemove([a])
    }).then((value) => Firestore.instance
            .collection("TagsList")
            .document(b)
            .updateData(
                <String, dynamic>{"followers": FieldValue.increment(-1)}));
  }

  Future myPosts() async {
    QuerySnapshot posts = await Firestore.instance
        .collection("posts")
        .orderBy('time', descending: true)
        .where("author", isEqualTo: Constants.myName)
        .getDocuments();
    return posts;
  }

  Future tagList() async {
    QuerySnapshot tags = await Firestore.instance
        .collection("TagsList")
        .orderBy('followers', descending: true)
        .getDocuments();
    return tags;
  }

  updateProfileImage(bool pro, String mage) async {
    Firestore.instance
        .collection("users")
        .document(Constants.documentId)
        .updateData({"Displaypic": mage});
    HelperFunctions.saveUserImageSharedPreference(mage);
    Constants.myDp = mage;
    print("\n\n\n\n" + Constants.myDp);
  }

  updateWallImage(bool pro, String mage) async {
    Firestore.instance
        .collection("users")
        .document(Constants.documentId)
        .updateData({"wallpaper": mage});
    Constants.wallPaper = mage;
  }

  checkifExist(String nam) async {
    var a = await Firestore.instance
        .collection("users")
        .where('userName', isEqualTo: nam)
        .getDocuments();
    return a.documents.isEmpty.toString();
  }

  addFriend(String userName) async {
    Firestore.instance
        .collection("users")
        .document(Constants.documentId)
        .updateData({
      "Users": FieldValue.arrayUnion([userName])
    });
    QuerySnapshot dataDoc = await Firestore.instance
        .collection("users")
        .where("userName", isEqualTo: userName)
        .getDocuments();
    var documentId = dataDoc.documents[0].documentID;
    Firestore.instance.collection("users").document(documentId).updateData({
      "Users": FieldValue.arrayUnion([Constants.myName])
    });
  }
}
