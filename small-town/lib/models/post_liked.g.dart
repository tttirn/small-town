// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_liked.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_PostLiked _$_$_PostLikedFromJson(Map json) {
  return _$_PostLiked(
    userId: json['userId'] as String,
    userDisplayName: json['userDisplayName'] as String,
    postId: json['postId'] as String,
    postUserId: json['postUserId'] as String,
    postTitle: json['postTitle'] as String,
    timestamp: json['timestamp'] == null
        ? null
        : DateTime.parse(json['timestamp'] as String),
  );
}

Map<String, dynamic> _$_$_PostLikedToJson(_$_PostLiked instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'userDisplayName': instance.userDisplayName,
      'postId': instance.postId,
      'postUserId': instance.postUserId,
      'postTitle': instance.postTitle,
      'timestamp': instance.timestamp?.toIso8601String(),
    };
