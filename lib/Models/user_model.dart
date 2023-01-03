class UserModel {
  UserModel({
    required this.Cnic,
    required this.Password,
    required this.Phone,
    required this.email,
    required this.name,
    required this.username,
    required this.Id,
  });
  late final String Cnic;
  late final String Password;
  late final String Phone;
  late final String email;
  late final String name;
  late final String username;
  late final String Id;

  UserModel.fromJson(Map<String, dynamic> doc,String docId){
    Cnic = doc['Cnic'];
    Password = doc['Password'];
    Phone = doc['Phone'];
    email = doc['email'];
    name = doc['name'];
    username = doc['username'];
    Id=docId;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['Cnic'] = Cnic;
    _data['Password'] = Password;
    _data['Phone'] = Phone;
    _data['email'] = email;
    _data['name'] = name;
    _data['username'] = username;
    _data['id']=Id;
    return _data;
  }
}