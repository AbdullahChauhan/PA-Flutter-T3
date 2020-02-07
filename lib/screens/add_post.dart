import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:pa_flutter_t3/core/models/Post.dart';
import 'package:pa_flutter_t3/core/services/Api.dart';
import 'package:pa_flutter_t3/utils/appUtils.dart';
import 'package:progress_dialog/progress_dialog.dart';

typedef OnFileDone(StorageReference storageReference);

class AddPost extends StatefulWidget {
  final String userID;
  final String userName;

  AddPost({this.userID, @required this.userName});

  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  Api api;
  TextEditingController postCtrl = TextEditingController();
  File imageFile;
  String imageUrl;
  Post post;
  bool isUploading;
  ProgressDialog pr;
  StorageUploadTask uploadTask;

  @override
  void initState() {
    pr = new ProgressDialog(context);
    pr.style(
      message: 'Please wait ...',
    );
    isUploading = false;
    api = Api("posts");
    imageFile = null;
    imageUrl = null;
    super.initState();
  }

  Future _getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      imageFile = image;
    });
  }

  void _uploadImage(String key, OnFileDone onFileDone) {
    isUploading = true;
    StorageReference ref = Api.storage.ref().child(key + ".jpg");
    uploadTask = ref.putFile(imageFile);
    uploadTask.events.listen((event) {
      if (event.type == StorageTaskEventType.success) {
        onFileDone(event.snapshot.ref);
      } else if (event.type == StorageTaskEventType.failure) {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text("Failed."),
        ));
      }
    });
  }

  void _createPost() {
    pr.show();
    String postText = postCtrl.text;
    var ref = api.ref;
    var key = ref.push().key;
    var newPost = ref.child(key);
    if (imageFile == null) {
      post = Post(
          postID: key,
          userID: widget.userID,
          userName: widget.userName,
          text: postText,
          shares: 12,
          views: 1000,
          timeStamp: DateTime.now().toString(),
          comments: []);
      newPost.set(post.toJson());
      progressDialog(context, 1);
    } else {
      _uploadImage(key, (fileRef) {
        fileRef.getDownloadURL().then((uri) {
          setState(() {
            imageUrl = uri.toString();
          });
          post = Post(
              postID: key,
              userID: widget.userID,
              userName: widget.userName,
              text: postText,
              imageUrl: imageUrl,
              shares: 12,
              views: 1000,
              timeStamp: DateTime.now().toString(),
              comments: []);
          newPost.set(post.toJson());
          if (uploadTask.isComplete && uploadTask.isSuccessful) {
            pr.hide().then((isHidden) {
              Navigator.of(context).pop();
            });
          }
        });
      });
      // progressDialog(context, 6);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Post'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              children: <Widget>[
                TextField(
                  controller: postCtrl,
                  maxLines: 8,
                  decoration: InputDecoration(
                      hintText: "What's on your mind ...",
                      contentPadding: const EdgeInsets.only(
                          top: 20, left: 20, right: 20, bottom: 10)),
                ),
                ListTile(
                  leading: Icon(Icons.photo_size_select_actual),
                  title: Text('Add Picture'),
                  onTap: _getImage,
                ),
                imageFile != null
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.file(
                          imageFile,
                          width: double.infinity,
                          height: 300,
                        ),
                      )
                    : SizedBox()
              ],
            ),
          ),
          Container(
            width: 300,
            decoration: BoxDecoration(
                color: Colors.grey[700],
                borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(8.0),
                    topRight: const Radius.circular(8.0))),
            child: ListTile(
              title: Text(
                'Post your talk',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                _createPost();
                FocusScopeNode currentFocus = FocusScope.of(context);

                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
              },
              trailing: Icon(
                Icons.done,
                size: 28.0,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
