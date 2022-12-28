import 'package:flutter/material.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';

class TextInputField extends StatefulWidget {
  final double? width;
  final double? height;
  final String hinttext;
  final String label;
  final bool istitle;
  final bool isbody;
  final bool isname;
  final bool isusername;
  final bool isemail;
  final bool ispassword;
  final bool isphone;
  final bool iscnic;
  final bool isobscure;
  final bool ispwvalidate;
  // final bool iscommenttitle;
  // final bool iscommentbody;
  final int maxline;
  // /// validation by function
  // final String Function(String?)? Validator;
  final TextEditingController mycontroller;
  const TextInputField({
    Key? key,
    this.height,
    this.width,
    this.hinttext = '',
    required this.label,
    this.istitle = false,
    this.isbody = false,
    this.isname=false,
    this.isusername=false,
    this.isemail=false,
    this.ispassword=false,
    this.isphone=false,
    this.iscnic=false,
    this.isobscure=false,
    this.ispwvalidate=false,
    // this.Validator,
    // this.iscommenttitle=false,
    // this.iscommentbody=false,
    this.maxline=1,
    required this.mycontroller,
  }) : super(key: key);

  @override
  State<TextInputField> createState() => _TextInputFieldState();
}

class _TextInputFieldState extends State<TextInputField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      margin: EdgeInsets.only(top: 8,bottom: 8),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 5,
            blurRadius: 10)
      ]),
      child: Center(
        child: TextFormField(
          obscureText: widget.isobscure,
          maxLines: widget.maxline,
          controller: widget.mycontroller,
          validator: (String? input) {
            if (widget.istitle) {
              if (input == null || input.isEmpty) {
                return "Title is required";
              } else if ((!RegExp(r'^[a-z A-Z]+$').hasMatch(input))) {
                return 'Please Enter only Alphabets ';
              }
            }
            if (widget.isbody) {
            if (input == null || input.isEmpty) {
                 return "Body is required";
            } else if ((!RegExp(r'^[a-z A-Z]+$').hasMatch(input))) {
                return 'Please Enter only Alphabets ';
              }
              }
            if (widget.isname) {
            if (input == null || input.isEmpty) {
                return "Name is required";
            } else if ((!RegExp(r'^[a-z A-Z.\-]+$').hasMatch(input))) {
                return 'Please Enter only Alphabets ';
            }
            }
            if (widget.isemail) {
            if (input == null || input.isEmpty) {
                return "Email is required";
            } else if ((!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(input))) {
                return 'Please Enter Correct Email with @';
            }
            }
            if (widget.isusername) {
              if (input == null || input.isEmpty) {
                return "User Name is required";
              } else
              if ((!RegExp(r"^[A-Za-z][A-Za-z0-9_]{7,29}$").hasMatch(input))) {
                return 'Please Enter valid Username ';
              }
            }
            if (widget.ispassword) {
              if (input == null || input.isEmpty) {
                return "Password is required";
              } else
              if ((!RegExp(r'^(?=.*?[A-Z]{1})(?=.*?[a-z])(?=.*?[0-9]{3})(?=.*?[!@#\$&*~]{1}).{8,}$').hasMatch(input))) {
                return 'Please Enter valid password';
              }
            }
            if (widget.isphone) {
              if (input == null || input.isEmpty) {
                return "Phone Number is required";
            } else if ((!RegExp(r"^\+?0[0-9]{10}$").hasMatch(input))) {
                return 'Please Enter Valid Phone Number';
            }
            }
            if (widget.iscnic) {
              if (input == null || input.isEmpty) {
                return "Cnic Numbaer is required";
              } else if ((!RegExp(r"^[0-9]{5}-[0-9]{7}-[0-9]{1}$").hasMatch(input))) {
                return 'Please Enter only 13 Digit CNIC Number With Dashes ';
              }
            }

            else {
              return null;
            }
          },
          decoration: InputDecoration(
              hintText: widget.hinttext,
              fillColor: Colors.white,
              filled: true,
              label: Text(
                widget.label,
                // style: TextStyle(fontSize: 17, color: Color(0xff5D5D5D)),
                style: TextStyle(
                    fontSize: 17,
                    color: Colors.lightBlueAccent,
                    fontWeight: FontWeight.bold),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                borderSide: BorderSide(color: Colors.cyan),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                borderSide: BorderSide(color: Colors.cyan),
              )),
        ),
      ),
    );
  }
}
/// Package pw validator

// pwvalidator(){
//   FlutterPwValidator(width: 400, height: 120, minLength: 8,uppercaseCharCount: 1,numericCharCount: 3,specialCharCount: 1,successColor: Colors.green,failureColor:Colors.red,onSuccess:(){
//     print("MATCHED");
//     ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
//         content: new Text("Password is matched")));
//     onFail: () {
//       print("NOT MATCHED");
//     };
//   } ,controller: widget.mycontroller,);
// }