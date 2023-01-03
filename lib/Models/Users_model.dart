class UsersModel {
  UsersModel({
    required this.email,
    required this.name,
    required this.phone,
    required this.id,
    required this.uid,
  });
  late final String email;
  late final String name;
  late final String phone;
  late final String id;
  late final String uid;

  UsersModel.fromJson(Map<String, dynamic> doc,String docId){
    email = doc['email'];
    name = doc['name'];
    phone = doc['phone'];
    uid = doc['uid']??"";
    id=docId;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['email'] = email;
    _data['name'] = name;
    _data['Phone'] = phone;
    _data['uid'] = uid;
    _data['id']=id;
    return _data;
  }
}