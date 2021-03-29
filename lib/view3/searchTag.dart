import 'package:finalproj/helper/constants.dart';
import 'package:finalproj/services/database.dart';
import 'package:flutter/material.dart';

var posts;

getTag() async {
  posts = await DatabaseMethods().tagList();
}

Widget hashSearch() {
  getTag();
  if (posts == null)
    return Container();
  else
    return Container(
        child: ListView.builder(
            itemCount: posts.documents.length,
            itemBuilder: (context, index) {
              return Container(
                padding:
                    EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                child: Column(
                  children: [
                    Container(
                        padding: EdgeInsets.only(left: 10, right: 15),
                        decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius:
                                BorderRadius.all(Radius.circular(30))),
                        height: 90,
                        child: Row(
                          children: [
                            Text(
                              "#" + posts.documents[index].data["tag"],
                              style: TextStyle(
                                  color: Colors.yellow[700], fontSize: 25),
                            ),
                            Spacer(),
                            Text(
                              "Members : " +
                                  posts.documents[index].data["followers"]
                                      .toString(),
                              style: TextStyle(color: Colors.white),
                            ),
                            Spacer(),
                            followButton(posts.documents[index].data["tag"],
                                posts.documents[index].documentID),
                          ],
                        )),
                  ],
                ),
              );
            }));
}

Widget followButton(var a, var b) {
  if (Constants.hashtags.contains(a)) {
    return IconButton(
        onPressed: () {
          DatabaseMethods().removeTag(a, b);
          Constants.hashtags.remove(a);
        },
        icon: Icon(
          Icons.thumb_up,
          color: Colors.yellow[700],
        ));
  } else {
    return IconButton(
        onPressed: () {
          DatabaseMethods().addTag(a, b);
          Constants.hashtags.add(a);
        },
        icon: Icon(
          Icons.thumb_up,
          color: Colors.white,
        ));
  }
}
