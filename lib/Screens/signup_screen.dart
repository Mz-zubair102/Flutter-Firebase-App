import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/Widgets/text_button_widget.dart';
import 'package:firebase/Widgets/text_field.dart';
import 'package:firebase/db/firebase_auth.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';

import '../utills/utills.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  FirebaseAuth auth=FirebaseAuth.instance;
  GlobalKey<FormState> _formkey=GlobalKey();
  TextEditingController fullnamecontroller=TextEditingController();
  TextEditingController phonenumbercontroller=TextEditingController();
  TextEditingController emailcontroller=TextEditingController();
  TextEditingController passwordcontroller=TextEditingController();
  @override
  Widget build(BuildContext context) {
     CollectionReference userRefrence = FirebaseFirestore.instance.collection("user");
     void signUp({
      required String email,
      required String password,
      required String fullname,
      required String phoneNumber,}) async {
       bool status = false;
      final credential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      ).then((value) {
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>HomeScreen()));
        const snackBar = SnackBar(
          content: Text('Succesfull Signup'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }).onError((error, stackTrace) {
        utils().toastmessage(error.toString());
      });
      User? currentUser = credential.user;
      if (currentUser != null) {
        DocumentReference currentUserRefrence = userRefrence.doc(currentUser.uid);
        Map<String, dynamic> userProfileData = {
          "name": fullname,
          "phone": phoneNumber,
          "email": email,
          "password": password,
          "uid": currentUser.uid
        };
        await currentUserRefrence.set(userProfileData);
      }
       status = true;
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.cyan,
        title: Text("Sign Up Screen"),
      ),
      body: Form(
        key: _formkey,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(left: 8.0,right: 8.0,top:20.0,bottom: 8.0),
              child: Column(
                children: [
                  TextInputField(label: "Full Name", mycontroller: fullnamecontroller,isname: true,),
                  TextInputField(label: "Email", mycontroller: emailcontroller,isemail: true,),
                  TextInputField(label: "PhoneNumber", mycontroller: phonenumbercontroller,isphone: true,),
                  TextInputField(label: "Password", mycontroller: passwordcontroller,ispassword: true,isobscure: true,),
                  SizedBox(height: 15,),
                  FlutterPwValidator(width: 350, height: 120, minLength: 8,uppercaseCharCount: 1,numericCharCount: 3,specialCharCount: 1,successColor: Colors.green,failureColor:Colors.red,onSuccess:(){
                    print("MATCHED");
                    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
                        content: new Text("Password is Matched")));
                    onFail: () {
                      print("NOT MATCHED");
                    };
                  } , controller: passwordcontroller),
                  SizedBox(height: 25,),
                  TextButtonWidget(btnname: "Signup",onpressed: ()async{
                    if(_formkey.currentState!.validate()){
                      // signUp(email: emailcontroller.text, password: passwordcontroller.text, fullname: fullnamecontroller.text, phoneNumber: phonenumbercontroller.text);
                      await Auth.signUpUser(email: emailcontroller.text, password: passwordcontroller.text, fullname: fullnamecontroller.text, phoneNumber: phonenumbercontroller.text)
                    .then((value) {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>HomeScreen())).onError((error, stackTrace) {
                          utils().toastmessage(error.toString());
                        });
                        const snackBar = SnackBar(
                          content: Text('Succesfull Signup'),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }).onError((error, stackTrace) {
                        utils().toastmessage(error.toString());
                      });
                      // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AddpostScreenState()));
                      // const snackBar = SnackBar(
                      //   content: Text('Successful SignUP'),
                      // );
                      // ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },),
                  SizedBox(height: 20,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Alredy have an account?",style: TextStyle(fontSize: 18,color: Colors.grey),),
                      TextButton(onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
                      }, child: Text("Login",style: TextStyle(fontSize: 18,color: Colors.cyan,fontWeight: FontWeight.bold),))
                    ],)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
