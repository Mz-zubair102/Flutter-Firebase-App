import 'dart:convert';

class CommentModel{
  late final String text;
  late final String PostId;
  late final String Id;

  CommentModel({
    required this.text,
    required this.PostId,
    required this.Id,
  });

  CommentModel.fromJson(Map<String,dynamic>doc,String docId){
    text = doc['text'];
    PostId = doc['PostId'];
    Id=docId;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['text'] = text;
    _data['PostId'] = PostId;
    _data["id"]=Id;
    return _data;
  }


}