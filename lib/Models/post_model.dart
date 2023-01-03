import 'dart:convert';

class PostModel{
  late final String title;
  late final String body;
  late final String Id;

  PostModel({
    required this.title,
    required this.body,
    required this.Id,
  });

  PostModel.froJson(Map<String,dynamic>doc,String docId){
    title = doc['title'];
    body = doc['body'];
    Id=docId;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['Cnic'] = title;
    _data['Password'] = body;
    _data["id"]=Id;
    return _data;
  }


}