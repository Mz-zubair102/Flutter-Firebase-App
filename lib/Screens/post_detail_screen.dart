import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/Widgets/text_button_widget.dart';
import 'package:firebase/Widgets/text_field.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../Models/comment_model.dart';
import '../Models/post_model.dart';
import '../Widgets/text_widget.dart';

class PostDetailScreen extends StatefulWidget {
  final PostModel detail;
  const PostDetailScreen({Key? key,required this.detail}) : super(key: key);

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  GlobalKey<FormState> _Formkey=GlobalKey();
  TextEditingController commentController=TextEditingController();
  CollectionReference commentRefrence=FirebaseFirestore.instance.collection("comments");
  // late CollectionReference commentReferenceDeep;
  // getAllCommentsofPost(){
  //  commentRefrence
  //       .where('PostId', isEqualTo: widget.detail.Id)
  //       .get();
  //  //      .then((QuerySnapshot snapshot) {
  //  //   print("Successfully get from firestore");
  //  // }).onError((error, stackTrace){
  //  //   print("Error $error");
  //  // });
  // }
  // Future<List<CommentModel>> getcommentDataFromFirebase()async {
  //   List<CommentModel> commentlist = [];
  //   await commentRefrence
  //       .where("PostId" , isEqualTo: widget.detail.Id)
  //       .get()
  //       .then((QuerySnapshot querySnapshot) {
  //     for (var doc in querySnapshot.docs){
  //       Map<String,dynamic> docData=doc.data() as Map<String, dynamic>;
  //       commentlist.add(CommentModel.fromJson(docData, doc.id));
  //     }
  //     print("commentlist.length");
  //     print(commentlist.length);
  //   }).catchError((error,stackTrace){
  //     print("$error");
  //   });
  //   print("commentlist.length");
  //   print(commentlist.length);
  //   return commentlist;
  // }
  Future<bool> addcommenttopost()async{
   Map<String, dynamic> commentdata={
     "PostId":widget.detail.Id,
     "text":commentController.text,
   } ;
   bool status=false;
   commentRefrence.add(commentdata).then((value) {
     print("${status = true}");
   }).onError((error, stackTrace) {
     // status = false;
     print("Error ${status=false}");
   });
   return status;
  }
  void initstate(){
    super.initState();
    // getAllCommentsofPost();
    // commentReferenceDeep = FirebaseFirestore.instance
    //     .collection("post")
    //     .doc(widget.detail.id)
    //     .collection("comments");

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("User ${widget.detail.Id}"),
        backgroundColor: Colors.cyan,
      ),
      body: Form(
        key: _Formkey,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Card(
                  elevation: 4,
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextWidget(title: "Title", detail: widget.detail.title),
                                TextWidget(title: "Body", detail: widget.detail.body),
                              ],
                            ),
                          ),
                        ],
                      ),
                  ),
                ),
                TextInputField(
                  width: 340,
                    label: "Add Comment", mycontroller: commentController),
                TextButtonWidget(btnname: "Add Comment",onpressed: ()async{
                  bool status=await addcommenttopost();
                  // print("status: $status");
                  if (status) {
                    print("posted");
                  } else {
                    print("error");
                  }
                },),
                SizedBox(height: 5,),
                // FutureBuilder<List<CommentModel>>(
                //   future: getcommentDataFromFirebase(),
                //     builder: (BuildContext context, AsyncSnapshot<List<CommentModel>> snapshot){
                //     if(snapshot.connectionState==ConnectionState.waiting){
                //       return Center(child: CircularProgressIndicator(),);
                //     }
                //     if(snapshot.hasData){
                //       if(snapshot.data!=null){
                //         return ListView.builder(
                //           shrinkWrap: true,
                //             physics: ScrollPhysics(),
                //             itemCount: snapshot.data!.length,
                //             itemBuilder: (context,int index){
                //               // Map<String,dynamic> doc=snapshot.data!.docs[index].data() as Map<String, dynamic>;
                //               // String docId=snapshot.data!.docs[index]["title"];
                //               // PostModel detail=UserModel.froJson(doc, docId);
                //               CommentModel detail=snapshot.data![index];
                //           return ListTile(
                //             title:Text(detail.text) ,
                //           );
                //         });
                //       }else {
                //         return Center(child: Text("Nothing To Show"),);
                //       }
                //     }else if(snapshot.hasError){
                //       return Center(child: Text("${snapshot.error}"),);
                //     }else{
                //       return Center(child: Text("Please wiat"),);
                //     }
                // })
                FutureBuilder<QuerySnapshot>(
                    future: commentRefrence.where("PostId", isEqualTo: widget.detail.Id).get(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                      if(snapshot.connectionState==ConnectionState.waiting){
                        return Center(child: CircularProgressIndicator(),);
                      }
                      if(snapshot.hasData){
                        if(snapshot.data!=null){
                          return ListView.builder(
                              shrinkWrap: true,
                              physics: ScrollPhysics(),
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context,int index){
                                // Map<String,dynamic> doc=snapshot.data!.docs[index].data() as Map<String, dynamic>;
                                // String docId=snapshot.data!.docs[index].id;
                                // CommentModel detail=CommentModel.fromJson(doc, docId);
                                // CommentModel detail=snapshot.data![index];
                                return ListTile(
                                  // title:Text(detail.text) ,
                                  title: Text(snapshot.data!.docs[index]["text"]),
                                );
                              });
                        }else {
                          return Center(child: Text("Nothing To Show"),);
                        }
                      }else if(snapshot.hasError){
                        return Center(child: Text("${snapshot.error}"),);
                      }else{
                        return Center(child: Text("Please wiat"),);
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

// bool status=await addCommentToPost();
// if(status){
//   print(posted)
// }else{
//  print(error)
// }