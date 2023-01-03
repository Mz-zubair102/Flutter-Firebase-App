import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/db/firestore_db.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Models/Users_model.dart';
import '../Models/post_model.dart';
import '../Widgets/text_field.dart';
import '../Widgets/text_button_widget.dart';
import '../Widgets/text_widget.dart';
import '../utills/utills.dart';
import 'comment_screen.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  GlobalKey<FormState> formkey = GlobalKey();
  TextEditingController titlecontroller = TextEditingController();
  TextEditingController bodycontroller = TextEditingController();
  CollectionReference postRefrence =
      FirebaseFirestore.instance.collection("Post");
  CollectionReference uerRefrence =
      FirebaseFirestore.instance.collection("user");
  User? user = FirebaseAuth.instance.currentUser;
  Future<List<PostModel>> getPostofCurrentUser() async {
    List<PostModel> postlist = [];
    User? user = FirebaseAuth.instance.currentUser;
    String uid = "";
    if (user != null) {
      uid = user.uid;
    }
    await postRefrence
        .where("uid", isEqualTo: uid)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> docData = doc.data() as Map<String, dynamic>;
        postlist.add(PostModel.fromJson(docData, doc.id));
      }
      print("postlist.length");
      print(postlist.length);
    }).catchError((error, stackTrace) {
      print("$error");
    });
    print("postlist.length");
    print(postlist.length);
    return postlist;
  }

  //add data to firebase
  void addPostToFirestore(String titletext, String bodytext) async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    String uid = "";
    if (currentUser != null) {
      uid = currentUser.uid;
    }
    Map<String, dynamic> data = {
      "title": titletext,
      "body": bodytext,
      "uid": uid
    };
    postRefrence
        .add(data)
        .then((value) => print("Successfully add to firestore"))
        .onError((error, stacktrace) => print("Error $error"));
  }

  Future<List<UsersModel>> getUserInfo() async {
    List<UsersModel> userlist = [];
    // User? user=FirebaseAuth.instance.currentUser;
    String uid = "";
    if (user != null) {
      uid = user!.uid;
    }
    await uerRefrence
        .where("uid", isEqualTo: uid)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> docData = doc.data() as Map<String, dynamic>;
        userlist.add(UsersModel.fromJson(docData, doc.id));
      }
    }).catchError((error, stackTrace) {
      print("$error");
    });
    return userlist;
  }

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text("PROFILE SCREEN"),
        backgroundColor: Colors.cyan,
        actions: [
          TextButton(
              onPressed: () {
                // Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomeScreen()));
              },
              child: Text(
                "Home",
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              )),
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
      drawer: Drawer(
        elevation: 5,
        backgroundColor: Colors.grey.shade200,
        width: 300,
        // shape: ,
        child: ListView(
          children: [
            DrawerHeader(
                decoration: BoxDecoration(color: Colors.cyan),
                child: Image.asset("Assets/FirebaseLogo.png")),
            ListTile(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomeScreen()));
                },
                leading: Icon(
                  Icons.home,
                  size: 32,
                  color: Colors.cyan,
                ),
                trailing: Icon(
                  Icons.navigate_next,
                  size: 32,
                  color: Colors.cyan,
                ),
                title: Text(
                  "Home",
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.cyan,
                      fontWeight: FontWeight.bold),
                ))
          ],
        ),
      ),
      body: Form(
        key: formkey,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                  top: 8.0, left: 12.0, right: 12.0, bottom: 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ///-----------By future<Document Snapshot>--------------------------///

                  FutureBuilder<DocumentSnapshot>(
                    future: uerRefrence.doc(user!.uid).get(),
                    builder: (BuildContext context,
                        AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text("Something went wrong");
                      }

                      if (snapshot.hasData && !snapshot.data!.exists) {
                        return Text("Document does not exist");
                      }

                      if (snapshot.connectionState == ConnectionState.done) {
                        ///----------Without Model --------------///
                        // Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
                        // // return Text("Name: ${data['name']} ${data['last_name']}");
                        // return Card(
                        //   elevation: 4,
                        //   color: Colors.grey.shade200,
                        //   child: Padding(
                        //     padding: EdgeInsets.all(8.0),
                        //     child: Row(
                        //       children: [
                        //         Expanded(
                        //           child: Column(
                        //             crossAxisAlignment:
                        //             CrossAxisAlignment.start,
                        //             children: [
                        //               TextWidget(
                        //                   title: "Name", detail: data["name"]),
                        //               SizedBox(
                        //                 height: 5,
                        //               ),
                        //               TextWidget(
                        //                   title: "Email", detail: data["email"]),
                        //               SizedBox(
                        //                 height: 5,
                        //               ),
                        //               TextWidget(
                        //                   title: "Phone", detail: data["phone"])
                        //             ],
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // );
                        ///------------With Model--------------------------///
                        Map<String, dynamic> data =
                            snapshot.data!.data() as Map<String, dynamic>;
                        UsersModel detail =
                            UsersModel.fromJson(data, snapshot.data!.id);
                        // return Text("Full Name: ${detail.name} ${data['name']}");
                        return Card(
                          elevation: 4,
                          color: Colors.grey.shade200,
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
                                          title: "Name", detail: detail.name),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      TextWidget(
                                          title: "Email", detail: detail.email),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      TextWidget(
                                          title: "Phone", detail: detail.phone)
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      return Text("loading");
                    },
                  ),
                  //----------------------------------------------------------------//
                  ///-----------By Model Future Function---------------------///
                  // FutureBuilder<List<UsersModel>>(
                  //     future: getUserInfo(),
                  //     builder: (BuildContext context, AsyncSnapshot<List<UsersModel>> snapshot){
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
                  //                 // PostModel detail=postModel.fromJson(doc, docId);
                  //                 UsersModel detail=snapshot.data![index];
                  //                 return Card(
                  //                   elevation: 4,
                  //                   color: Colors.grey.shade200,
                  //                   child: Padding(
                  //                     padding: EdgeInsets.all(8.0),
                  //                     child: Row(
                  //                       children: [
                  //                         Expanded(
                  //                           child: Column(
                  //                             crossAxisAlignment: CrossAxisAlignment.start,
                  //                             children: [
                  //                               TextWidget(title: "Name", detail: detail.name),
                  //                               SizedBox(height: 5,),
                  //                               TextWidget(title: "Email", detail: detail.email),
                  //                               SizedBox(height: 5,),
                  //                               TextWidget(title: "Phone", detail: detail.phone)
                  //
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
                  //     }),
                  ///--------------------------------------------------------///
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: Divider(
                        color: Colors.black,
                        thickness: 3,
                        endIndent: 5,
                      )),
                      Text(
                        "CREATE POST",
                        style: TextStyle(
                            color: Colors.lightBlueAccent,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: Divider(
                            color: Colors.black, thickness: 3, indent: 5),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextInputField(
                    hinttext: "Post Title",
                    label: "Post Title...",
                    mycontroller: titlecontroller,
                    istitle: true,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextInputField(
                    hinttext: "Post Body",
                    label: "Post Body...",
                    maxline: 3,
                    mycontroller: bodycontroller,
                    isbody: true,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextButtonWidget(
                    btnname: "Submit Post",
                    onpressed: () async {
                      if (formkey.currentState!.validate()) {
                        // addPostToFirestore(
                        //     titlecontroller.text, bodycontroller.text);
                        FirestoreDB().addPostToFirestore(titletext: titlecontroller.text, bodytext: bodycontroller.text);
                        var snackBar = SnackBar(
                          content: Text("Successfully data is transferred"),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: Divider(
                        color: Colors.black,
                        thickness: 3,
                        endIndent: 5,
                      )),
                      Text(
                        "SPECIFIC POSTS",
                        style: TextStyle(
                            color: Colors.lightBlueAccent,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: Divider(
                            color: Colors.black, thickness: 3, indent: 5),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  FutureBuilder<List<PostModel>>(
                      future: getPostofCurrentUser(),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<PostModel>> snapshot) {
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
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, int index) {
                                  // Map<String,dynamic> doc=snapshot.data!.docs[index].data() as Map<String, dynamic>;
                                  // String docId=snapshot.data!.docs[index].id;
                                  // PostModel detail=postModel.fromJson(doc, docId);
                                  PostModel detail = snapshot.data![index];
                                  return InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CommentScreen(
                                                    postdetail: detail,
                                                  )));
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
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  TextWidget(
                                                      title: "Post Title",
                                                      detail: detail.title),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  TextWidget(
                                                      title: "Body",
                                                      detail: detail.body)
                                                ],
                                              ),
                                            ),
                                            Icon(
                                              Icons.arrow_forward_ios_outlined,
                                              size: 30,
                                              color: Colors.cyan,
                                            ),
                                          ],
                                        ),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
