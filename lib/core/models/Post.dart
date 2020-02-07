// import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

/// This allows the `Post` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'Post.g.dart';

@JsonSerializable()

class Post {
  String postID;
  String userID;
  String userName;
  String text;
  String imageUrl;
  int shares;
  int views;
  String timeStamp;
  List<Map<String, String>> comments;

  Post(
      {this.postID,
      this.userID,
      this.userName,
      this.text,
      this.imageUrl,
      this.shares,
      this.views,
      this.timeStamp,
      this.comments});

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory Post.fromJson(Map json) => _$PostFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$PostToJson(this);
}
