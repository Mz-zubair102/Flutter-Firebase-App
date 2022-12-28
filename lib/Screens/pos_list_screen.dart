import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PostListScreen extends StatefulWidget {
  const PostListScreen({Key? key}) : super(key: key);

  @override
  State<PostListScreen> createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  CollectionReference postRefrence=FirebaseFirestore.instance.collection("Post");
  DocumentReference currentuserprofilerefrence=FirebaseFirestore.instance.collection("Post").doc("Comments");
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
              FutureBuilder<QuerySnapshot>(
                future: postRefrence.get(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                  if(snapshot.connectionState==ConnectionState.waiting){
                    return Center(child: CircularProgressIndicator(),);
                  }
                  if(snapshot.hasData){
                    if(snapshot.data!=null){
                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                          physics: ScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index){
                        return ListTile(
                          title: Text(snapshot.data!.docs[index]["title"]),
                          subtitle: Text(snapshot.data!.docs[index]["body"]),
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
              })
            ],
          ),
        ),
      ),
    );
  }
}
