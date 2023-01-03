import 'dart:convert';

class CommentModel{
  late final String comment;
  late final String postid;
  late final String Id;
  late final String uid;

  CommentModel({
    required this.comment,
    required this.postid,
    required this.uid,
    required this.Id,
  });

  CommentModel.fromJson(Map<String,dynamic>doc,String docId){
    comment = doc['text'];
    postid = doc['postid'];
    uid = doc['uid']??"";
    Id=docId;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['comment'] = comment;
    _data['postid'] = postid;
    _data["id"]=Id;
    _data['uid'] = uid;
    return _data;
  }


}