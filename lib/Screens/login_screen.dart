import 'package:firebase/Screens/signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';

import '../Widgets/text_button_widget.dart';
import '../Widgets/text_field.dart';
import '../db/firebase_auth.dart';
import '../utills/utills.dart';
import 'home_screen.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FirebaseAuth auth=FirebaseAuth.instance;
  GlobalKey<FormState> _formkey=GlobalKey();
  TextEditingController emailcontroller=TextEditingController();
  TextEditingController passwordcontroller=TextEditingController();
  void login({required String emailtext,required String passwordtext}){
    auth.signInWithEmailAndPassword(email: emailtext, password: passwordtext)
        .then((value) {
      // / utils().toastmessage(value.user!.email.toString());
      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>HomeScreen()));
      const snackBar = SnackBar(
        content: Text('Succesfull login'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    })
        .onError((error, stackTrace) {
          utils().toastmessage(error.toString());
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.cyan,
        title: Text("Login Screen"),
      ),
      body: Form(
        key: _formkey,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(left: 8.0,right: 8.0,top:20.0,bottom: 8.0),
              child: Column(
                children: [
                  TextInputField(label: "Email", mycontroller: emailcontroller,isemail: true,),
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
                  TextButtonWidget(btnname: "Login",onpressed: ()async{
                    if(_formkey.currentState!.validate()){
                      login(emailtext:emailcontroller.text,passwordtext:passwordcontroller.text);
                      // await Auth.loginUser(email: emailcontroller.text, password: passwordcontroller.text);
                      // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AddpostScreenState()));
                      // const snackBar = SnackBar(
                      //   content: Text('Succesfull login'),
                      // );
                      // ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },),
                  SizedBox(height: 20,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    Text("Dont have an account?",style: TextStyle(fontSize: 18,color: Colors.grey),),
                      TextButton(onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUpScreen()));
                      }, child: Text("SignUp",style: TextStyle(fontSize: 18,color: Colors.cyan,fontWeight: FontWeight.bold),))
                  ],)
                ],
              ),
            ),
          ),
        ),
      ),
    );;
  }
}
