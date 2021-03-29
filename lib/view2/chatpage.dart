import 'package:finalproj/helper/constants.dart';
import 'package:finalproj/helper/helperfunction.dart';
import 'package:finalproj/services/database.dart';
import 'package:finalproj/view2/chat.dart';
import 'package:finalproj/view2/createStory.dart';
import 'package:finalproj/view2/search.dart';
import 'package:finalproj/view3/postspage.dart';
import 'package:finalproj/view4/profileview.dart';
import 'package:flutter/material.dart';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';

class homepage extends StatefulWidget {
  @override
  _homepageState createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  var storyList, loading = true;
  int currentIndex;
  Stream chatRooms;
  ScrollController _controller;
  bool wallpaper = true;

  Widget chatRoomsList() {
    return StreamBuilder(
      stream: chatRooms,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                controller: _controller,
                itemCount: snapshot.data.documents.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ChatRoomsTile(
                    userName: snapshot.data.documents[index].data['chatRoomId']
                        .toString()
                        .replaceAll("_", "")
                        .replaceAll(Constants.myName, ""),
                    chatRoomId:
                        snapshot.data.documents[index].data["chatRoomId"],
                    userDetail: snapshot.data.documents[index].data['users'],
                  );
                })
            : Container();
      },
    );
  }

  @override
  void initState() {
    getUserInfogetChats();
    _controller = ScrollController();
    _controller.addListener(() {
      if (_controller.offset > 50) wallpaper = false;
      if (_controller.offset < 50) wallpaper = true;
    });
    super.initState();
    currentIndex = 0;
  }

  void changePage(int index) {
    if (this.mounted)
      setState(() {
        currentIndex = index;
        if (index == 1) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => mainHomepage()));
        }
        if (index == 2) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => profileview()));
        }
      });
  }

  getUserInfogetChats() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    Constants.myDp = await HelperFunctions.getUserImageSharedPreference();
    await DatabaseMethods().getUserInfo2(Constants.myName);
    storyList = await DatabaseMethods().getStories1();
    DatabaseMethods().getUserChats(Constants.myName).then((snapshots) {
      if (this.mounted)
        setState(() {
          chatRooms = snapshots;
          loading = false;
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(65.0),
        child: AppBar(
          backgroundColor: Colors.blueGrey[900],
          leading: Container(
            padding: EdgeInsets.only(top: 5, left: 5),
            child: CircleAvatar(
                radius: 33,
                backgroundColor: Colors.yellow[500],
                child: CircleAvatar(
                  radius: 32,
                  backgroundImage: NetworkImage(Constants.myDp),
                )),
          ),
          title: Row(
            children: [
              Text(
                "Copin's",
                textAlign: TextAlign.center,
                style: (TextStyle(
                  color: Colors.yellow[700],
                  fontSize: 24,
                  fontFamily: 'Croissant One',
                )),
              ),
            ],
          ),
          actions: <Widget>[
            IconButton(
              padding: new EdgeInsets.only(right: 22),
              icon: Icon(Icons.camera),
              iconSize: 27.0,
              color: Colors.white,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => createStory()));
              },
            ),
            /*IconButton(
              padding: new EdgeInsets.only(right: 22),
              icon: Icon(Icons.notifications),
              iconSize: 27.0,
              color: Colors.white,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => mainHomepage()));
              },
            ),*/
          ],
        ),
      ),
      body: Container(
        color: Colors.blueGrey[900],
        child: Column(
          children: [
            SizedBox(
              height: 5,
            ),
            AnimatedContainer(
              color: Colors.black26,
              alignment: Alignment.topCenter,
              duration: const Duration(milliseconds: 150),
              height: wallpaper ? 290 : 0,
              child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  padding: EdgeInsets.only(bottom: 5, top: 5),
                  child: storyView()),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 50),
              height: wallpaper
                  ? MediaQuery.of(context).size.height - 300 - 65 - 75
                  : MediaQuery.of(context).size.height - 60 - 90,
              child: chatRoomsList(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Search()));
        },
        child: Icon(Icons.search),
        backgroundColor: Colors.blueGrey[900],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: BubbleBottomBar(
        backgroundColor: Colors.blueGrey[900],
        opacity: .2,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        elevation: 8,
        fabLocation: BubbleBottomBarFabLocation.end,
        hasNotch: true,
        hasInk: true,
        currentIndex: currentIndex,
        onTap: changePage,
        inkColor: Colors.blueGrey[900],
        items: <BubbleBottomBarItem>[
          BubbleBottomBarItem(
              backgroundColor: Colors.yellow[500],
              icon: Icon(
                Icons.dashboard,
                color: Colors.white,
              ),
              activeIcon: Icon(
                Icons.dashboard,
                color: Colors.yellow[500],
              ),
              title: Text("Home")),
          BubbleBottomBarItem(
              backgroundColor: Colors.deepPurple,
              icon: Icon(
                Icons.access_time,
                color: Colors.white,
              ),
              activeIcon: Icon(
                Icons.access_time,
                color: Colors.deepPurple,
              ),
              title: Text("Logs")),
          BubbleBottomBarItem(
              backgroundColor: Colors.indigo,
              icon: Icon(
                Icons.folder_open,
                color: Colors.white,
              ),
              activeIcon: Icon(
                Icons.folder_open,
                color: Colors.indigo,
              ),
              title: Text("Folders")),
        ],
      ),
    );
  }

  Widget storyView() {
    getUserInfogetChats();
    if (loading == false)
      return storyList != []
          ? ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: storyList.length,
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    SizedBox(
                      width: 8,
                    ),
                    Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            image: DecorationImage(
                              image: NetworkImage(storyList[index][1]),
                            ),
                          ),
                          height: 240,
                          width: 180,
                        ),
                        SizedBox(height: 3),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                              color: Colors.black12,
                            ),
                            width: 160,
                            child: Text(
                              storyList[index][2] + "\n#" + storyList[index][3],
                              style: TextStyle(
                                  color: Colors.yellow[500], fontSize: 15),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                );
              },
            )
          : Container(
              width: 100,
              height: 100,
              color: Colors.white,
            );
    else
      return Container(
        decoration:
            BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(30))),
      );
  }
}

class ChatRoomsTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;
  final List userDetail;

  ChatRoomsTile({this.userName, @required this.chatRoomId, this.userDetail});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Chat(
                      chatRoomId: chatRoomId,
                      userName: userName,
                      userDetail: userDetail,
                    )));
      },
      child: Container(
        child: Column(
          children: [
            Container(
              color: Colors.black26,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 33,
                    backgroundColor: Colors.yellow[500],
                    child: CircleAvatar(
                        radius: 33,
                        backgroundImage: NetworkImage(
                            Constants.myDp == userDetail[2]
                                ? userDetail[3]
                                : userDetail[2])),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(userName,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'OverpassRegular',
                          fontWeight: FontWeight.w300))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
