import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/Models/user_model.dart';
import 'package:flutter/material.dart';

import '../../Widgets/text_widget.dart';


class UsersListScreen extends StatefulWidget {
  const UsersListScreen({Key? key}) : super(key: key);

  @override
  State<UsersListScreen> createState() => _UsersListScreenState();
}

class _UsersListScreenState extends State<UsersListScreen> {
  CollectionReference postRefrence=FirebaseFirestore.instance.collection("User");
  // Future<List<UserModel>> getDataFromFirebase()async {
  //   List<UserModel> userlist = [];
  //   postRefrence
  //       .get()
  //       .then((QuerySnapshot querySnapshot) {
  //     for (var doc in querySnapshot.docs){
  //       Map<String,dynamic> docData=doc.data() as Map<String, dynamic>;
  //       userlist.add(UserModel.fromJson(docData, doc.id));
  //     }
  //     return userlist;
  //   }).catchError((error,stackTrace){
  //     print("$error");
  //   });
  //   return userlist;
  // }
  Future<List<UserModel>> getDataFromFirebase()async{
    List<UserModel> userlist=[];
    QuerySnapshot data=await FirebaseFirestore.instance.collection("User").get();
    for (var doc in data.docs){
            Map<String,dynamic> docData=doc.data() as Map<String, dynamic>;
            userlist.add(UserModel.fromJson(docData, doc.id));
            // return userlist;
          }
    return userlist;
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Users List Screen"),
        backgroundColor: Colors.cyan,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                FutureBuilder<List<UserModel>>(
                  future: getDataFromFirebase(),
                    builder: (BuildContext context,AsyncSnapshot<List<UserModel>> snapshot){
                  if(snapshot.connectionState==ConnectionState.waiting){
                    return Center(child: CircularProgressIndicator(),);
                  }
                  if(snapshot.hasData){
                    if(snapshot.data!=null){
                      return ListView.builder(
                        physics: ScrollPhysics(),
                          shrinkWrap: true,
                          // itemCount: snapshot.data!.docs.length,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, int index){
                            ///For Model these 3 lines if return type in Future<QuerySnapshot> and without above Future Function
                            // Map<String,dynamic> doc=snapshot.data!.docs[index].data() as Map<String, dynamic>;
                            // String docId=snapshot.data!.docs[index].id;
                            // PostModel detail=UserModel.froJson(doc, docId);
                          UserModel userdetail=snapshot.data![index];
                        return Card(child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              TextWidget(title: "Name",detail: "${userdetail.name}",),
                              TextWidget(title: "Username",detail: "${userdetail.username}",),
                              TextWidget(title: "Email",detail: "${userdetail.email}",),
                              TextWidget(title: "Phone",detail: "${userdetail.Phone}",),
                              TextWidget(title: "Cnic",detail: "${userdetail.Cnic}",),
                            ],
                          ),
                        ),);
                      });
                    }else{
                      return Center(child: Text("Nothing to show"),);
                    }

                  }
                  else if(snapshot.hasError){
                    return Center(child: Text(" Error ${snapshot.error}"),);
                  }else {
                    return Center(child: Text("Please wait"),);
                  }

                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
