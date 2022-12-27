

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../Widgets/text_field.dart';
import '../Widgets/widget_text_button.dart';

class AddpostScreenState extends StatefulWidget {
  const AddpostScreenState({Key? key}) : super(key: key);

  @override
  State<AddpostScreenState> createState() => _AddpostScreenStateState();
}

class _AddpostScreenStateState extends State<AddpostScreenState> {
  GlobalKey<FormState> formkey = GlobalKey();
  TextEditingController titlecontroller = TextEditingController();
  TextEditingController bodycontroller = TextEditingController();
  CollectionReference postRefrence=FirebaseFirestore.instance.collection("Post");

  //add data to firebase
  void addPostToFirestore(String titletext,String bodytext)async{
    Map<String, dynamic> data={"title": titletext,"body":bodytext};
    postRefrence
        .add(data).then((value)
    => print("Successfully add to firestore"))
        .onError((error, stacktrace)
    =>print("Error $error"));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text("ADD POST SCREEN STATE"),
        backgroundColor: Colors.cyan,
      ),
      body: Form(
        key: formkey,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(top: 8.0,left: 12.0,right: 12.0,bottom: 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 100,),
                  TextInputField(
                    hinttext: "Post Title",
                    label: "Post Title...",
                    mycontroller: titlecontroller,
                    istitle: true,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextInputField(
                    hinttext: "Post Body",
                    label: "Post Body...",
                    maxline: 3,
                    mycontroller: bodycontroller,
                    isbody: true,
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  widgetTextButton(btnname: "Submit",onpressed: ()async{
                    if (formkey.currentState!.validate()) {
                      addPostToFirestore(titlecontroller.text, bodycontroller.text);
                      var snackBar = SnackBar(
                        content: Text("Successfully data is transferred"),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
