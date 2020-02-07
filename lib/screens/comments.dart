import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pa_flutter_t3/core/models/Post.dart';
import 'package:pa_flutter_t3/core/services/Api.dart';
import 'package:pa_flutter_t3/utils/appUtils.dart';

class Comments extends StatefulWidget {
  final Post currentPost;
  final String userName;

  Comments({this.currentPost, this.userName});

  @override
  _CommentsState createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  TextEditingController commentCtrl = TextEditingController();
  Post post;
  Api api;
  List<Map<String, String>> comments;
  bool isLoaded;

  void initState() {
    api = Api("posts");
    isLoaded = false;
    super.initState();
  }

  void _loadComments() {
    comments = [];
    api.getData((event) {
      Post post =
          Post.fromJson(Map<String, dynamic>.from(event.snapshot.value));
      if (post.postID == widget.currentPost.postID) {
        if (post.comments != null) {
          post.comments.forEach((element) {
            setState(() {
              comments.add(element);
            });
          });
        }
      }
    });
  }

  void _postComment() {
    if (commentCtrl.text != '') {
      Map<String, String> comment = {
        'userName': widget.userName,
        'commentText': commentCtrl.text,
        'timeStamp': DateTime.now().toString(),
      };
      setState(() {
        comments.add(comment);
        widget.currentPost.comments = comments;
      });
      post = Post(
          postID: widget.currentPost.postID,
          userID: widget.currentPost.userID,
          userName: widget.currentPost.userName,
          text: widget.currentPost.text,
          imageUrl: widget.currentPost.imageUrl,
          shares: widget.currentPost.shares,
          views: widget.currentPost.views,
          timeStamp: widget.currentPost.timeStamp,
          comments: comments);
      api.ref.child(widget.currentPost.postID).update(post.toJson());
      commentCtrl.text = '';
    }
  }

  Future<Null> _handleRefresh() async {
    Completer<Null> completer = Completer<Null>();

    Future.delayed(new Duration(seconds: 2)).then((_) {
      completer.complete();
      _loadComments();
    });
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    if (!isLoaded) {
      _loadComments();
      isLoaded = true;
    }

    return Scaffold(
        appBar: AppBar(
          title: Text('Comments'),
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      CircleAvatar(
                        child: Text(
                          widget.currentPost.userName.substring(0, 1),
                          style: TextStyle(fontSize: 22.0, color: Colors.white),
                        ),
                        backgroundColor: Colors.grey[700],
                      ),
                      SizedBox(
                        width: 8.0,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.currentPost.userName,
                            style: Theme.of(context).textTheme.subtitle,
                          ),
                          Text(
                            readTimestamp(
                                DateTime.parse(
                                    widget.currentPost.timeStamp.toString()),
                                false),
                            style: TextStyle(
                              fontSize: 10.0,
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
                padding: const EdgeInsets.fromLTRB(12.0, 0.0, 18.0, 12.0),
                child: Text(
                  widget.currentPost.text,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            widget.currentPost.imageUrl != null
                ? CachedNetworkImage(
                    placeholder: (context, url) => Container(
                      width: double.infinity,
                      height: 200,
                      child: Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.black54,
                          strokeWidth: 2.0,
                        ),
                      ),
                    ),
                    imageUrl: widget.currentPost.imageUrl,
                    height: 200.0,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  )
                : SizedBox(),
            Divider(
              color: Colors.grey[300],
              height: 2.0,
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _handleRefresh,
                child: widget.currentPost.comments != null
                    ? ListView.builder(
                        itemCount: comments.length,
                        itemBuilder: (context, idx) {
                          var cmntUser;
                          var cmntText;
                          var timeStamp;
                          if (comments != null) {
                            comments[idx].entries.forEach((e) {
                              if (e.key == 'userName') cmntUser = e.value;
                              if (e.key == 'commentText') cmntText = e.value;
                              if (e.key == 'timeStamp') timeStamp = e.value;
                            });
                          }
                          return Column(
                            children: <Widget>[
                              ListTile(
                                  leading: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        '$cmntUser',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        readTimestamp(
                                            DateTime.parse(timeStamp), true),
                                        style: TextStyle(
                                            fontSize: 10.0, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                  title: Wrap(children: <Widget>[
                                    Container(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 4.0,
                                            right: 12.0,
                                            bottom: 8.0,
                                            left: 8.0),
                                        child: Text(
                                          '$cmntText',
                                          style: TextStyle(fontSize: 14.0),
                                        ),
                                      ),
                                      decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                    ),
                                  ]))
                            ],
                          );
                        })
                    : Center(
                        child: Text(
                          'No comments here ...',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
              ),
            ),
            ListTile(
              title: TextField(
                controller: commentCtrl,
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24.0),
                      borderSide: const BorderSide(
                          color: Color.fromRGBO(225, 225, 225, 1), width: 1.0),
                    ),
                    hintText: "What's on your mind ...",
                    contentPadding: const EdgeInsets.only(
                        top: 20, left: 20, right: 20, bottom: 10)),
              ),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                _postComment();
                FocusScopeNode currentFocus = FocusScope.of(context);

                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
              },
            )
          ],
        ));
  }
}
