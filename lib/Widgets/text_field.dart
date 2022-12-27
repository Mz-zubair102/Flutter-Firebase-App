import 'package:flutter/material.dart';

class TextInputField extends StatefulWidget {
  final String hinttext;
  final String label;
  final bool istitle;
  final int maxline;
  // final bool iscommenttitle;
  // final bool iscommentbody;
  final bool isbody;
  final String Function(String?)? Validator;
  final TextEditingController mycontroller;
  const TextInputField({
    Key? key,
    this.hinttext = '',
    required this.label,
    this.istitle = false,
    this.isbody = false,
    this.Validator,
    this.maxline=1,
    // this.iscommenttitle=false,
    // this.iscommentbody=false,
    required this.mycontroller,
  }) : super(key: key);

  @override
  State<TextInputField> createState() => _TextInputFieldState();
}

class _TextInputFieldState extends State<TextInputField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 5,
            blurRadius: 10)
      ]),
      child: Center(
        child: TextFormField(
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
              // if (widget.iscommenttitle) {
              //   if (input == null || input.isEmpty) {
              //     return "comment Title is required";
              //   } else if ((!RegExp(r'^[a-z A-Z]+$').hasMatch(input))) {
              //     return 'Please Enter only Alphabets ';
              //   }
              // }
              // if (widget.iscommentbody) {
              //   if (input == null || input.isEmpty) {
              //     return "Comment body is required";
              //   } else if ((!RegExp(r'^[a-z A-Z]+$').hasMatch(input))) {
              //     return 'Please Enter only Alphabets ';
              //   }
              // }
              else {
                return null;
              }
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
