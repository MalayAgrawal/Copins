import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalproj/helper/constants.dart';
import 'package:finalproj/services/database.dart';
import 'package:finalproj/view2/chatpage.dart';
import 'package:finalproj/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:finalproj/view2/chat.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController searchEditingController = new TextEditingController();
  QuerySnapshot searchResultSnapshot;

  bool isLoading = false;
  bool haveUserSearched = false;

  initiateSearch() async {
    if (searchEditingController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      await databaseMethods
          .searchByName(searchEditingController.text)
          .then((snapshot) {
        searchResultSnapshot = snapshot;
        setState(() {
          isLoading = false;
          haveUserSearched = true;
        });
      });
    }
  }

  Widget userList() {
    return haveUserSearched
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchResultSnapshot.documents.length,
            itemBuilder: (context, index) {
              return userTile(
                searchResultSnapshot.documents[index].data["userName"],
                searchResultSnapshot.documents[index].data["userEmail"],
                searchResultSnapshot.documents[index].data["Displaypic"],
              );
            })
        : Container();
  }

  sendMessage(String userName, String displaypic) {
    DatabaseMethods().addFriend(userName);

    List<String> users = [
      Constants.myName,
      userName,
      Constants.myDp,
      displaypic
    ];

    if (userName != Constants.myName) {
      String chatRoomId = getChatRoomId(userName, Constants.myName);

      Map<String, dynamic> chatRoom = {
        "users": users,
        "chatRoomId": chatRoomId,
      };

      databaseMethods.addChatRoom(chatRoom, chatRoomId);

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Chat(
                    chatRoomId: chatRoomId,
                    userName: userName,
                    userDetail: users,
                  )));
    }
  }

  Widget userTile(String userName, String userEmail, String displaypic) {
    return Container(
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Container(
            height: 100,
            padding: EdgeInsets.only(top: 10, left: 5, right: 5),
            child: Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                CircleAvatar(
                  radius: 33,
                  backgroundColor: Colors.yellow[500],
                  child: CircleAvatar(
                    radius: 32,
                    backgroundImage: NetworkImage(displaypic),
                  ),
                ),
                SizedBox(
                  width: 12,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      userName,
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    Text(
                      userEmail,
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    )
                  ],
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    sendMessage(userName, displaypic);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                        color: Colors.yellow[500],
                        borderRadius: BorderRadius.circular(24)),
                    child: Text(
                      "Message",
                      style:
                          TextStyle(color: Colors.blueGrey[900], fontSize: 16),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? loader1()
        : Scaffold(
            backgroundColor: Colors.blueGrey[900],
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(80.0),
              child: AppBar(
                leading: Container(
                  child: IconButton(
                      padding: new EdgeInsets.only(top: 18, left: 5),
                      icon: Icon(Icons.arrow_left),
                      iconSize: 50.0,
                      color: Colors.yellow[500],
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => homepage()));
                      }),
                ),
                backgroundColor: Colors.blueGrey[900],
                title: Container(
                  padding: new EdgeInsets.only(top: 26, left: 0),
                  child: TextField(
                    controller: searchEditingController,
                    style: simpleTextStyle(),
                    decoration: InputDecoration(
                        hintText: "search username ...",
                        hintStyle: TextStyle(
                          color: Colors.white60,
                          fontSize: 17,
                        ),
                        border: InputBorder.none),
                  ),
                ),
                actions: <Widget>[
                  IconButton(
                    padding: new EdgeInsets.only(top: 18, right: 6),
                    icon: Icon(Icons.arrow_right),
                    iconSize: 50.0,
                    color: Colors.yellow[500],
                    onPressed: () {
                      initiateSearch();
                    },
                  ),
                ],
              ),
            ),
            body: SingleChildScrollView(
              child: Container(
                color: Colors.black26,
                child: Column(
                  children: [userList()],
                ),
              ),
            ),
          );
  }
}
