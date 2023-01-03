import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/Models/post_model.dart';
import 'package:firebase/Screens/post_detail_screen.dart';
import 'package:firebase/Widgets/text_widget.dart';
import 'package:flutter/material.dart';

class PostListScreen extends StatefulWidget {
  const PostListScreen({Key? key}) : super(key: key);

  @override
  State<PostListScreen> createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  CollectionReference postRefrence=FirebaseFirestore.instance.collection("Post");
  // DocumentReference currentuserprofilerefrence=FirebaseFirestore.instance.collection("Post").doc("Comments");
  Future<List<PostModel>> getDataFromFirebase()async {
    List<PostModel> postlist = [];
    await postRefrence
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs){
        Map<String,dynamic> docData=doc.data() as Map<String, dynamic>;
        postlist.add(PostModel.froJson(docData, doc.id));
    }
      print("Postlist.length");
      print(postlist.length);
    }).catchError((error,stackTrace){
      print("$error");
    });
    print("Postlist.length");
    print(postlist.length);
    return postlist;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.cyan,
        title: const Text("Post List Screen"),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              // FutureBuilder<QuerySnapshot>(
              //   future: postRefrence.get(),
              //     builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
              //     if(snapshot.connectionState==ConnectionState.waiting){
              //       return Center(child: CircularProgressIndicator(),);
              //     }
              //     if(snapshot.hasData){
              //       if(snapshot.data!=null){
              //         return ListView.builder(
              //           itemCount: snapshot.data!.docs.length,
              //             physics: ScrollPhysics(),
              //             shrinkWrap: true,
              //             itemBuilder: (context, index){
              //             // ///For Model these 3 lines
              //             //   Map<String,dynamic> doc=snapshot.data!.docs[index].data() as Map<String, dynamic>;
              //             //   String docId=snapshot.data!.docs[index].id;
              //             //   PostModel detail=PostModel.froJson(doc, docId);
              //           return ListTile(
              //             ///For Model these 2 lines
              //             // title: Text(detail.title),
              //             // subtitle: Text(detail.body),
              //             title: Text(snapshot.data!.docs[index]["title"]),
              //             subtitle: Text(snapshot.data!.docs[index]["body"]),
              //           );
              //         });
              //       }else{
              //         return Center(child: Text("Nothing To Show"),);
              //       }
              //     }else if(snapshot.hasError){
              //       return Center(child: Text("${snapshot.error}"),);
              //     }
              //     else{
              //       return(Center(child: Text("Please wait"),));
              //     }
              // }),
              FutureBuilder<List<PostModel>>(
                  future: getDataFromFirebase(),
                  builder: (BuildContext context, AsyncSnapshot<List<PostModel>> snapshot){
                    if(snapshot.connectionState==ConnectionState.waiting){
                      return Center(child: CircularProgressIndicator(),);
                    }
                    if(snapshot.hasData){
                      if(snapshot.data!=null){
                        return ListView.builder(
                            itemCount: snapshot.data!.length,
                            physics: ScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index){
                              PostModel detail=snapshot.data![index];
                              return InkWell(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>PostDetailScreen(detail: detail,)));
                                },
                                child: Card(
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
                                              TextWidget(title: "Title", detail: detail.title),
                                              TextWidget(title: "Body", detail: detail.body)
                                            ],
                                          ),
                                        ),
                                        Icon(Icons.arrow_forward_ios_outlined,size: 30,color: Colors.cyan,),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            });
                      }else{
                        return Center(child: Text("Nothing To Show"),);
                      }
                    }else if(snapshot.hasError){
                      return Center(child: Text("${snapshot.error}"),);
                    }
                    else{
                      return(Center(child: Text("Please wait"),));
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
