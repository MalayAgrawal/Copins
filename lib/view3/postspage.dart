import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalproj/helper/constants.dart';
import 'package:finalproj/services/database.dart';
import 'package:finalproj/view2/chatpage.dart';
import 'package:finalproj/view3/createPost.dart';
import 'package:finalproj/view3/searchTag.dart';
import 'package:finalproj/view4/profileview.dart';
import 'package:finalproj/widget/widget.dart';
import 'package:flutter/material.dart';

class mainHomepage extends StatefulWidget {
  @override
  _mainHomepageState createState() => _mainHomepageState();
}

class _mainHomepageState extends State<mainHomepage> {
  Stream posts;
  Stream chatRooms;
  int currentIndex;
  bool loading = true, searchPage = false, refresh = true;
  getUserInfogetChats() async {
    if (true) {
      posts = await DatabaseMethods().getPosts();
      refresh = false;
    }

    if (this.mounted)
      setState(() {
        loading = false;
      });
  }

  @override
  void initState() {
    super.initState();
    currentIndex = 1;
  }

  void searchHash() {
    if (this.mounted)
      setState(() {
        searchPage ? searchPage = false : searchPage = true;
      });
  }

  void changePage(int index) {
    if (this.mounted)
      setState(() {
        refresh = true;
        currentIndex = index;
        if (index == 0) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => homepage()));
        }
        if (index == 2) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => profileview()));
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: Colors.blueGrey[900],
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.blueGrey[900],
                boxShadow: [
                  BoxShadow(
                      color: Colors.black54,
                      blurRadius: 5.0,
                      offset: Offset(0, 5))
                ],
              ),
              padding: EdgeInsets.only(bottom: 5),
              child: searchPage
                  ? GestureDetector(
                      onTap: () {
                        searchHash();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          color: Colors.black26,
                        ),
                        height: 47,
                        child: Row(
                          children: [
                            Container(
                                padding: EdgeInsets.only(left: 14),
                                alignment: Alignment.centerLeft,
                                child: Icon(
                                  Icons.search,
                                  color: Colors.white,
                                )),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              "Search",
                              textAlign: TextAlign.right,
                              style: (TextStyle(
                                color: Colors.white54,
                                fontFamily: 'Croissant One',
                              )),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Row(
                      children: [
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          "Copin's",
                          textAlign: TextAlign.left,
                          style: (TextStyle(
                            color: Colors.yellow[700],
                            fontSize: 24,
                            fontFamily: 'Croissant One',
                          )),
                        ),
                        SizedBox(
                          width: 18,
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              searchHash();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)),
                                color: Colors.black26,
                              ),
                              height: 47,
                              child: Row(
                                children: [
                                  Container(
                                      padding: EdgeInsets.only(left: 14),
                                      alignment: Alignment.centerLeft,
                                      child: Icon(
                                        Icons.search,
                                        color: Colors.white,
                                      )),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    "Search",
                                    textAlign: TextAlign.right,
                                    style: (TextStyle(
                                      color: Colors.white54,
                                      fontFamily: 'Croissant One',
                                    )),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 4,
                        )
                      ],
                    ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: EdgeInsets.only(left: 1, right: 1),
              child: postsView(),
              height: searchPage ? 0 : MediaQuery.of(context).size.height - 140,
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: searchPage ? MediaQuery.of(context).size.height - 140 : 0,
              child: hashSearch(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => createPost()));
        },
        child: Icon(Icons.add),
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
              title: Text("Refresh")),
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
    getUserInfogetChats();
    if (loading == false) {
      if (posts != null) {
        return StreamBuilder<QuerySnapshot>(
            stream: posts,
            builder: (context, snapshot) {
              return new ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Container(
                          decoration:
                              BoxDecoration(color: Colors.blueGrey[900]),
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
                                              backgroundImage: NetworkImage(
                                                  snapshot.data.documents[index]
                                                      .data["dp"]))),
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
                                                snapshot.data.documents[index]
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
                                                "",
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
                                    padding: EdgeInsets.only(
                                        left: 8, top: 5, bottom: 5),
                                    child: Text(
                                      "#" +
                                          snapshot.data.documents[index]
                                              .data["tag"],
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
                                      snapshot.data.documents[index]
                                          .data["caption"],
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
                                      image: NetworkImage(snapshot
                                          .data.documents[index].data["img"]),
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
                                like(snapshot.data.documents[index]),
                                Text(
                                    snapshot.data.documents[index].data["likes"]
                                        .length
                                        .toString(),
                                    style: (TextStyle(
                                      color: Colors.white,
                                    ))),
                                IconButton(
                                    alignment: Alignment.center,
                                    icon: Icon(Icons.comment,
                                        color: Colors.white)),
                                Text(
                                    snapshot.data.documents[index]
                                        .data["coments"].length
                                        .toString(),
                                    style: (TextStyle(
                                      color: Colors.white,
                                    ))),
                                Spacer(),
                                IconButton(
                                    icon: Icon(Icons.bookmark,
                                        color: Colors.white)),
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
            });
      } else
        return Container(
          alignment: Alignment.center,
          child: Text(
            "Your tag list is empty",
            style: TextStyle(color: Colors.yellow, fontSize: 20),
          ),
        );
    } else
      return loader1();
  }
}

Widget like(var a) {
  var b = a.data["likes"];
  if (b.contains(Constants.myName)) {
    return IconButton(
        onPressed: () {
          DatabaseMethods().removeLike(a);
        },
        icon: Icon(
          Icons.thumb_up,
          color: Colors.yellow[700],
        ));
  } else {
    return IconButton(
        onPressed: () {
          DatabaseMethods().addLike(a);
        },
        icon: Icon(
          Icons.thumb_up,
          color: Colors.white,
        ));
  }
}
