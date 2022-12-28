import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:firebase/Widgets/text_field.dart';
import 'package:flutter/material.dart';

import '../Widgets/widget_text_button.dart';

class UserInfo extends StatefulWidget {
  const UserInfo({Key? key}) : super(key: key);

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  GlobalKey<FormState>  formkey=GlobalKey();
  TextEditingController namecontroller=TextEditingController();
  TextEditingController usernamecontroller=TextEditingController();
  TextEditingController emailcontroller=TextEditingController();
  TextEditingController passwordcontroller=TextEditingController();
  TextEditingController phonecontroller=TextEditingController();
  TextEditingController cniccontroller=TextEditingController();
  CollectionReference userRefrence=FirebaseFirestore.instance.collection("User");

  //add data to firebase
  void addUserToFirestore(String nametext,String usernametext,String emailtext,String passwordtext,String phonetext,String cnictext)async{
    Map<String, dynamic> data={"name": nametext,"username":usernametext,"email": emailtext,"Password":passwordtext,"Phone":phonetext,"Cnic":cnictext};
    userRefrence
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
        title: Text("User Info Screen State"),
        backgroundColor: Colors.cyan,
      ),
      body: Form(
        key: formkey,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextInputField(label: "Name..",hinttext: "Name",mycontroller: namecontroller,isname: true,),
                  TextInputField(label: "User Name..",hinttext: "User Name",mycontroller: usernamecontroller,isusername: true,),
                  TextInputField(label: "Email..",hinttext: "Email",mycontroller: emailcontroller,isemail: true,),
                  TextInputField(label: "Password..",hinttext: "Password",mycontroller: passwordcontroller,isobscure: true,ispassword: true,),
                  FlutterPwValidator(width: 350, height: 120, minLength: 8,uppercaseCharCount: 1,numericCharCount: 3,specialCharCount: 1,successColor: Colors.cyan,failureColor:Colors.red,onSuccess:(){
                    print("MATCHED");
                    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
                        content: new Text("Password is matched")));
                    onFail: () {
                      print("NOT MATCHED");
                    };
                  } , controller: passwordcontroller),
                  SizedBox(height: 5,),
                  TextInputField(label: "Phone..",hinttext: "Phone",mycontroller: phonecontroller,isphone: true,),
                  TextInputField(label: "CNIC..",hinttext: "CNIC",mycontroller: cniccontroller,iscnic: true,),
                  SizedBox(height: 10,),
                  widgetTextButton(btnname: "Submit User Info",
                  onpressed: ()async{
                    if (formkey.currentState!.validate()) {
                      addUserToFirestore(namecontroller.text,usernamecontroller.text,emailcontroller.text,
                        passwordcontroller.text,phonecontroller.text,cniccontroller.text,
                      );
                      var snackBar = SnackBar(
                        content: Text("Successfully data is transferred"),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                  )

                ],
              ),
            ),
          ),
        ),
      )
    );
  }
}
