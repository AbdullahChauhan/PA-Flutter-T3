// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Post _$PostFromJson(Map json) {
  return Post(
    postID: json['postID'] as String,
    userID: json['userID'] as String,
    userName: json['userName'] as String,
    text: json['text'] as String,
    imageUrl: json['imageUrl'] as String,
    shares: json['shares'] as int,
    views: json['views'] as int,
    timeStamp: json['timeStamp'] as String,
    comments: (json['comments'] as List)
        ?.map((e) => (e as Map)?.map(
              (k, e) => MapEntry(k as String, e as String),
            ))
        ?.toList(),
  );
}

Map<String, dynamic> _$PostToJson(Post instance) => <String, dynamic>{
      'postID': instance.postID,
      'userID': instance.userID,
      'userName': instance.userName,
      'text': instance.text,
      'imageUrl': instance.imageUrl,
      'shares': instance.shares,
      'views': instance.views,
      'timeStamp': instance.timeStamp,
      'comments': instance.comments,
    };
