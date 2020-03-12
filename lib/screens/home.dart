import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pa_flutter_t3/core/models/Post.dart';
import 'package:pa_flutter_t3/core/services/Api.dart';
import 'package:pa_flutter_t3/screens/add_post.dart';
import 'package:pa_flutter_t3/utils/appUtils.dart';
import 'package:pa_flutter_t3/widgets/navigation_drawer.dart';
import 'comments.dart';

class Home extends StatefulWidget {
  final String userID;

  Home({@required this.userID});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Post> posts;
  Api api;
  bool isLoaded;
  String userName;
  String userEmail;

  @override
  void initState() {
    FirebaseAuth.instance.currentUser().then((value) {
      userName = value.displayName;
      userEmail = value.email;
    });

    posts = [];
    isLoaded = false;
    api = Api("posts");
    super.initState();
  }

  void _loadPosts() {
    api.getData((event) {
      Post post =
          Post.fromJson(Map<String, dynamic>.from(event.snapshot.value));
      setState(() {
        posts.add(post);
      });
    });
  }

  void _loadComments() {
    api.getData((event) {
      Post post =
          Post.fromJson(Map<String, dynamic>.from(event.snapshot.value));
      if (post.comments != null) {
        int i = 0;
        while (i < posts.length) {
          if (post.postID == posts[i].postID) {
            setState(() {
              posts[i].comments = post.comments;
            });
          }
          i++;
        }
      }
    });
  }

  Future<Null> _handleRefresh() async {
    Completer<Null> completer = Completer<Null>();

    Future.delayed(new Duration(seconds: 3)).then((_) {
      completer.complete();
      _loadComments();
    });
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    if (!isLoaded) {
      _loadPosts();
      isLoaded = true;
    }

    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        appBar: AppBar(
          title: Text('New Talk'),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.camera_alt,
                size: 28.0,
              ),
              onPressed: () {
                Navigator.of(context).push(CupertinoPageRoute(
                    builder: (ctx) =>
                        AddPost(userID: widget.userID, userName: userName)));
              },
            )
          ],
        ),
        drawer: NavigationDrawer(userName, userEmail),
        body: RefreshIndicator(
          onRefresh: _handleRefresh,
          child: posts.isNotEmpty
              ? ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (ctx, idx) {
                    var lastCmntUser;
                    var lastCmntText;
                    if (posts[idx].comments != null) {
                      posts[idx]
                          .comments[posts[idx].comments.length - 1]
                          .entries
                          .forEach((e) {
                        if (e.key == 'userName') lastCmntUser = e.value;
                        if (e.key == 'commentText') lastCmntText = e.value;
                      });
                    }
                    return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    CircleAvatar(
                                      child: Text(
                                        posts[idx].userName.substring(0, 1),
                                        style: TextStyle(
                                            fontSize: 22.0,
                                            color: Colors.white),
                                      ),
                                      backgroundColor: Colors.grey[700],
                                    ),
                                    SizedBox(
                                      width: 8.0,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          posts[idx].userName,
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle,
                                        ),
                                        Text(
                                          readTimestamp(
                                              DateTime.parse(posts[idx]
                                                  .timeStamp
                                                  .toString()),
                                              false),
                                          style: TextStyle(
                                            fontSize: 11.0,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  12.0, 0.0, 18.0, 8.0),
                              child: Text(posts[idx].text,
                                  style: Theme.of(context).textTheme.caption),
                            ),
                          ),
                          posts[idx].imageUrl != null
                              ? CachedNetworkImage(
                                  placeholder: (context, url) => Container(
                                    width: double.infinity,
                                    height: 225,
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        backgroundColor: Colors.black54,
                                        strokeWidth: 2.0,
                                      ),
                                    ),
                                  ),
                                  imageUrl: posts[idx].imageUrl,
                                  height: 225.0,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                )
                              : SizedBox(),
                          Container(
                            decoration: BoxDecoration(color: Colors.grey[200]),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  0.0, 8.0, 12.0, 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Text(
                                    '${posts[idx].shares.toString()} Shares',
                                    style: TextStyle(
                                      fontSize: 11.0,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 8.0,
                                  ),
                                  Text(
                                    '${posts[idx].views.toString()} Views',
                                    style: TextStyle(
                                      fontSize: 11.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                                12.0, 8.0, 18.0, 12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                posts[idx].comments == null ||
                                        posts[idx].comments.isEmpty
                                    ? GestureDetector(
                                        onTap: () {
                                          Navigator.of(context)
                                              .push(CupertinoPageRoute(
                                                  builder: (ctx) => Comments(
                                                        currentPost: posts[idx],
                                                        userName: userName,
                                                      )));
                                        },
                                        child: Text(
                                          'Write a comment ...',
                                          style: TextStyle(fontSize: 12.0),
                                        ))
                                    : Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text('$lastCmntUser',
                                              style: TextStyle(
                                                  fontSize: 13.0,
                                                  fontWeight: FontWeight.w500)),
                                          Text('$lastCmntText',
                                              style: TextStyle(
                                                  fontSize: 12.0,
                                                  color: Colors.grey[600])),
                                        ],
                                      ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 6.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.of(context)
                                          .push(CupertinoPageRoute(
                                              builder: (ctx) => Comments(
                                                    currentPost: posts[idx],
                                                    userName: userName,
                                                  )));
                                    },
                                    child: posts[idx].comments == null ||
                                            posts[idx].comments.isEmpty
                                        ? SizedBox()
                                        : Text('View all comments',
                                            style: TextStyle(
                                                fontSize: 12.0,
                                                color: Colors.grey[400])),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Divider(
                            color: Colors.grey[300],
                            height: 1.0,
                          )
                        ]);
                  })
              : SizedBox(),
        ),
      ),
    );
  }
}
