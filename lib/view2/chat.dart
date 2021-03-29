import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalproj/helper/constants.dart';
import 'package:finalproj/services/database.dart';
import 'package:flutter/material.dart';

import 'chatpage.dart';

class Chat extends StatefulWidget {
  final String chatRoomId, userName;
  final List userDetail;
  Chat({this.chatRoomId, this.userName, this.userDetail});

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  Stream<QuerySnapshot> chats;
  TextEditingController messageEditingController = new TextEditingController();
  Widget chatMessages() {
    return StreamBuilder(
      stream: chats,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                reverse: true,
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  return MessageTile(
                    message: snapshot.data.documents[index].data["message"],
                    sendByMe: Constants.myName ==
                        snapshot.data.documents[index].data["sendBy"],
                  );
                })
            : Container();
      },
    );
  }

  addMessage() {
    if (messageEditingController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "sendBy": Constants.myName,
        "message": messageEditingController.text,
        'time': FieldValue.serverTimestamp(),
      };

      DatabaseMethods().addMessage(widget.chatRoomId, chatMessageMap);

      setState(() {
        messageEditingController.text = "";
      });
    }
  }

  @override
  void initState() {
    DatabaseMethods().getChats(widget.chatRoomId).then((val) {
      setState(() {
        chats = val;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: AppBar(
          elevation: 5,
          backgroundColor: Colors.blueGrey[900],
          leading: Container(
            child: IconButton(
                padding: new EdgeInsets.only(top: 13, left: 5),
                icon: Icon(Icons.arrow_left),
                iconSize: 50.0,
                color: Colors.yellow[500],
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => homepage()));
                }),
          ),
          title: Container(
            padding: new EdgeInsets.only(top: 18, left: 0),
            child: Text(widget.userName),
          ),
          actions: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 12, right: 12),
              child: CircleAvatar(
                radius: 25,
                backgroundColor: Colors.yellow[500],
                child: CircleAvatar(
                    radius: 24,
                    backgroundImage: NetworkImage(
                        Constants.myDp == widget.userDetail[2]
                            ? widget.userDetail[3]
                            : widget.userDetail[2])),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: Colors.black12,
        child: Column(
          children: [
            Expanded(
                child: Container(
                    padding: EdgeInsets.only(bottom: 7),
                    color: Colors.blueGrey[900],
                    child: chatMessages())),
            Container(
              decoration: new BoxDecoration(boxShadow: [
                BoxShadow(
                  color: Colors.black54,
                  blurRadius: 5.0,
                  spreadRadius: 1.0,
                )
              ]),
              alignment: Alignment.bottomCenter,
              width: MediaQuery.of(context).size.width,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                color: Colors.blueGrey[900],
                child: Row(
                  children: [
                    Expanded(
                        child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                      child: Container(
                        padding: EdgeInsets.only(left: 10),
                        color: Colors.grey[600],
                        child: TextField(
                          controller: messageEditingController,
                          decoration: InputDecoration(
                              hintText: "Message...",
                              hintStyle: TextStyle(
                                color: Colors.white60,
                                fontSize: 16,
                              ),
                              border: InputBorder.none),
                        ),
                      ),
                    )),
                    SizedBox(
                      width: 16,
                    ),
                    GestureDetector(
                      onTap: () {
                        addMessage();
                      },
                      child: Container(
                        child: Icon(
                          Icons.send,
                          color: Colors.yellow[600],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool sendByMe;

  MessageTile({@required this.message, @required this.sendByMe});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 3,
          bottom: 3,
          left: sendByMe ? 20 : 15,
          right: sendByMe ? 15 : 20),
      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin:
            sendByMe ? EdgeInsets.only(left: 30) : EdgeInsets.only(right: 30),
        padding: EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
        decoration: BoxDecoration(
          color: sendByMe ? Colors.yellow[600] : Colors.white,
          borderRadius: sendByMe
              ? BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                  bottomLeft: Radius.circular(18))
              : BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                  bottomRight: Radius.circular(18)),
        ),
        child: Text(message,
            textAlign: TextAlign.start,
            style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontFamily: 'OverpassRegular')),
      ),
    );
  }
}
