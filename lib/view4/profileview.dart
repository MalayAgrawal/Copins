import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:finalproj/services/database.dart';
import 'package:finalproj/view2/chatpage.dart';
import 'package:finalproj/view3/postspage.dart';
import 'package:finalproj/view4/settingwidget.dart';
import 'package:flutter/material.dart';
import 'package:finalproj/helper/constants.dart';

class profileview extends StatefulWidget {
  @override
  _profileviewState createState() => _profileviewState();
}

class _profileviewState extends State<profileview> {
  @override
  int currentIndex = 2, hearts = 0;
  var posts;
  bool loading = true;
  ScrollController _controller;
  bool wallpaper = true, editSetting = false;

  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(() {
      if (_controller.offset > 20) wallpaper = false;
      if (_controller.offset < 2) wallpaper = true;
    });
    super.initState();
  }

  getPosts() async {
    posts = await DatabaseMethods().myPosts();
    if (this.mounted)
      setState(() {
        loading = false;
      });
  }

  Widget count() {
    hearts = 0;
    if (posts != null)
      for (int i = 0; i < posts.documents.length; i++) {
        hearts = posts.documents[i].data["likes"].length + hearts;
      }
    return Container();
  }

  void changePage(int index) {
    if (this.mounted)
      setState(() {
        currentIndex = index;
        if (index == 1) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => mainHomepage()));
        }
        if (index == 0) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => homepage()));
        }
      });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      body: editSetting
          ? AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              child: setingEdit(),
            )
          : AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              color: Colors.blueGrey[900],
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  AnimatedContainer(
                    alignment: Alignment.topCenter,
                    duration: const Duration(milliseconds: 200),
                    height: wallpaper ? 210 : 0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(Constants.wallPaper),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    child: Row(
                      children: [
                        SizedBox(
                          width: 20,
                        ),
                        CircleAvatar(
                          radius: 42,
                          backgroundColor: Colors.blueGrey[900],
                          child: Stack(children: [
                            CircleAvatar(
                                radius: 40,
                                backgroundImage: NetworkImage(Constants.myDp)),
                          ]),
                        ),
                        Spacer(),
                        Column(children: [
                          Container(
                              child: Text(
                            Constants.realName,
                            style: (TextStyle(
                              color: Colors.yellow[50],
                              fontSize: 18,
                              fontFamily: 'Croissant One',
                            )),
                          )),
                          SizedBox(height: 10),
                          Container(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "@" + Constants.myName,
                                style: (TextStyle(
                                  color: Colors.yellow[50],
                                  fontSize: 18,
                                  fontFamily: 'Croissant One',
                                )),
                              ))
                        ]),
                        Spacer(),
                        Spacer(),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 26,
                  ),
                  AnimatedContainer(
                    alignment: Alignment.topCenter,
                    duration: const Duration(milliseconds: 200),
                    height: wallpaper ? 90 : 0,
                    child: Row(
                      children: [
                        Spacer(),
                        Text(
                          "Friends\n" + Constants.following.length.toString(),
                          textAlign: TextAlign.center,
                          style: (TextStyle(
                            color: Colors.yellow[50],
                            fontSize: 18,
                            height: 2,
                            fontFamily: 'Croissant One',
                          )),
                        ),
                        Spacer(),
                        Text(
                          "Hearts\n" + hearts.toString(),
                          textAlign: TextAlign.center,
                          style: (TextStyle(
                            color: Colors.yellow[50],
                            fontSize: 18,
                            height: 2,
                            fontFamily: 'Croissant One',
                          )),
                        ),
                        Spacer(),
                        Text(
                          "Tags\n" + Constants.hashtags.length.toString(),
                          textAlign: TextAlign.center,
                          style: (TextStyle(
                            color: Colors.yellow[50],
                            fontSize: 18,
                            height: 2,
                            fontFamily: 'Croissant One',
                          )),
                        ),
                        Spacer(),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(left: 1, right: 1),
                      child: postsView(),
                    ),
                  ),
                  count(),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (this.mounted)
            setState(() {
              if (editSetting == false)
                editSetting = true;
              else
                editSetting = false;
            });
        },
        child: Icon(Icons.settings),
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

  Widget postsView() {
    getPosts();
    if (loading == false)
      return posts.documents.length == 0
          ? Container(
              padding: EdgeInsets.only(top: 50),
              child: Text(
                "Wow So Empty!!!",
                style: (TextStyle(
                  color: Colors.yellow[500],
                  fontSize: 18,
                  fontFamily: 'Croissant One',
                )),
              ))
          : ListView.builder(
              controller: _controller,
              itemCount: posts.documents.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(color: Colors.blueGrey[900]),
                      child: Column(children: [
                        Container(
                          child: Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 7,
                                  ),
                                  CircleAvatar(
                                      radius: 27,
                                      backgroundColor: Colors.yellow[500],
                                      child: CircleAvatar(
                                          radius: 32,
                                          backgroundImage: NetworkImage(posts
                                              .documents[index].data["dp"]))),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Container(
                                    width: 100,
                                    child: Column(
                                      children: [
                                        Container(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            posts.documents[index]
                                                .data["author"],
                                            textAlign: TextAlign.left,
                                            style: (TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontFamily: 'Croissant One',
                                            )),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 3,
                                        ),
                                        Container(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            "3 hours",
                                            textAlign: TextAlign.left,
                                            style: (TextStyle(
                                              color: Colors.white24,
                                              fontSize: 15,
                                              fontFamily: 'Croissant One',
                                            )),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Spacer(),
                                  IconButton(
                                      icon: Icon(
                                        Icons.more,
                                        color: Colors.white38,
                                      ),
                                      iconSize: 23,
                                      onPressed: null)
                                ],
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                padding:
                                    EdgeInsets.only(left: 8, top: 5, bottom: 5),
                                child: Text(
                                  "#" + posts.documents[index].data["tag"],
                                  textAlign: TextAlign.left,
                                  style: (TextStyle(
                                    color: Colors.yellow[700],
                                    fontSize: 22,
                                    fontFamily: 'Croissant One',
                                  )),
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.only(
                                    left: 8, top: 1, bottom: 10),
                                child: Text(
                                  posts.documents[index].data["caption"],
                                  textAlign: TextAlign.left,
                                  style: (TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontFamily: 'Croissant One',
                                  )),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 340,
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              image: DecorationImage(
                                  image: NetworkImage(
                                      posts.documents[index].data["img"]),
                                  fit: BoxFit.cover)),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            like(posts.documents[index]),
                            Text(
                                posts.documents[index].data["likes"].length
                                    .toString(),
                                style: (TextStyle(
                                  color: Colors.white,
                                ))),
                            IconButton(
                                alignment: Alignment.center,
                                icon: Icon(Icons.comment, color: Colors.white)),
                            Text(
                                posts.documents[index].data["coments"].length
                                    .toString(),
                                style: (TextStyle(
                                  color: Colors.white,
                                ))),
                            Spacer(),
                            IconButton(
                                icon:
                                    Icon(Icons.bookmark, color: Colors.white)),
                          ],
                        ),
                      ]),
                    ),
                    Container(
                      color: Colors.black26,
                      height: 4,
                    )
                  ],
                );
              });
    else
      return Container();
  }
}
