import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/Models/post_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Models/comment_model.dart';
import '../Widgets/text_button_widget.dart';
import '../Widgets/text_field.dart';
import '../Widgets/text_widget.dart';
import '../db/firestore_db.dart';
import '../utills/utills.dart';
import 'login_screen.dart';

class CommentScreen extends StatefulWidget {
  final PostModel postdetail;
  const CommentScreen({Key? key, required this.postdetail})
      : super(key: key);

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  GlobalKey<FormState> _formkey = GlobalKey();
  TextEditingController commentController = TextEditingController();
  CollectionReference commentRefrence =
      FirebaseFirestore.instance.collection("comments");

  Future<List<CommentModel>> getcommentDataFromFirebase() async {
    List<CommentModel> commentlist = [];
    await commentRefrence
        .where("postid", isEqualTo: widget.postdetail.Id)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> docData = doc.data() as Map<String, dynamic>;
        commentlist.add(CommentModel.fromJson(docData, doc.id));
      }
      print("commentlist.length");
      print(commentlist.length);
    }).catchError((error, stackTrace) {
      print("$error");
    });
    print("commentlist.length");
    print(commentlist.length);
    return commentlist;
  }

  void addCommentToFirestore({required String commenttext}) async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    String uid = "";
    if (currentUser != null) {
      uid = currentUser.uid;
    }
    ;
    Map<String, dynamic> data = {
      "comment": commenttext,
      "uid": uid,
      "postid": widget.postdetail.Id
    };
    commentRefrence
        .add(data)
        .then((value) => print("Successfully add to firestore"))
        .onError((error, stacktrace) => print("Error $error"));
  }

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text("COMMENT SCREEN"),
        backgroundColor: Colors.cyan,
        actions: [
          IconButton(
              onPressed: () {
                auth.signOut().then((value) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                }).onError((error, stackTrace) {
                  utils().toastmessage(error.toString());
                });
              },
              icon: Icon(Icons.logout_outlined))
        ],
      ),
      body: Form(
        key: _formkey,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                  top: 8.0, left: 12.0, right: 12.0, bottom: 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Card(
                    elevation: 4,
                    color: Colors.grey.shade300,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextWidget(title: "Post Title", detail: widget.postdetail.title),
                                SizedBox(height: 5,),
                                TextWidget(title: "Post Body", detail: widget.postdetail.body)
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 10,
                  ),
                  TextInputField(
                      width: 360,
                      label: "Add Comment",
                      mycontroller: commentController),
                  SizedBox(
                    height: 15,
                  ),
                  TextButtonWidget(
                    btnname: "Submit comment",
                    onpressed: () async {
                      if (_formkey.currentState!.validate()) {
                        // addCommentToFirestore(
                        //     commenttext: commentController.text);
                        FirestoreDB().addCommentToFirestore(commenttext: commentController.text, postid: widget.postdetail.Id);
                        var snackBar = SnackBar(
                          content: Text("Successfully data is transferred"),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  FutureBuilder<QuerySnapshot>(
                      future: commentRefrence
                          .where("postid", isEqualTo: widget.postdetail.Id)
                          .get(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (snapshot.hasData) {
                          if (snapshot.data != null) {
                            return ListView.builder(
                                shrinkWrap: true,
                                physics: ScrollPhysics(),
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, int index) {
                                  // Map<String,dynamic> doc=snapshot.data!.docs[index].data() as Map<String, dynamic>;
                                  // String docId=snapshot.data!.docs[index].id;
                                  // CommentModel detail=CommentModel.fromJson(doc, docId);
                                  // CommentModel detail=snapshot.data![index];
                                  return Card(
                                    elevation: 4,
                                    color: Colors.white,
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                TextWidget(
                                                    title: "Comment",
                                                    detail: snapshot
                                                            .data!.docs[index]
                                                        ["comment"]),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                });
                          } else {
                            return Center(
                              child: Text("Nothing To Show"),
                            );
                          }
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text("${snapshot.error}"),
                          );
                        } else {
                          return Center(
                            child: Text("Please wiat"),
                          );
                        }
                      })
                  // FutureBuilder<List<CommentModel>>(
                  //     future: getcommentDataFromFirebase(),
                  //     builder: (BuildContext context, AsyncSnapshot<List<CommentModel>> snapshot){
                  //       if(snapshot.connectionState==ConnectionState.waiting){
                  //         return Center(child: CircularProgressIndicator(),);
                  //       }
                  //       if(snapshot.hasData){
                  //         if(snapshot.data!=null){
                  //           return ListView.builder(
                  //               shrinkWrap: true,
                  //               physics: ScrollPhysics(),
                  //               itemCount: snapshot.data!.length,
                  //               itemBuilder: (context,int index){
                  //                 // Map<String,dynamic> doc=snapshot.data!.docs[index].data() as Map<String, dynamic>;
                  //                 // String docId=snapshot.data!.docs[index].id;
                  //                 // CommentModel detail=CommentModel.fromJson(doc, docId);
                  //                 CommentModel detail=snapshot.data![index];
                  //                 return Card(
                  //                   elevation: 4,
                  //                   color: Colors.white,
                  //                   child: Padding(
                  //                     padding: EdgeInsets.all(8.0),
                  //                     child: Row(
                  //                       children: [
                  //                         Expanded(
                  //                           child: Column(
                  //                             crossAxisAlignment: CrossAxisAlignment.start,
                  //                             children: [
                  //                               TextWidget(title: "Title", detail: detail.comment),
                  //                             ],
                  //                           ),
                  //                         ),
                  //                       ],
                  //                     ),
                  //                   ),
                  //                 );
                  //               });
                  //         }else {
                  //           return Center(child: Text("Nothing To Show"),);
                  //         }
                  //       }else if(snapshot.hasError){
                  //         return Center(child: Text("${snapshot.error}"),);
                  //       }else{
                  //         return Center(child: Text("Please wiat"),);
                  //       }
                  //     })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
