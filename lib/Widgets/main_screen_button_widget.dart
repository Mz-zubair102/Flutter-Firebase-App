import 'package:flutter/material.dart';

class MainScreenButtonWidget extends StatelessWidget {
  final String buttonname;
  final VoidCallback? onpressesd;
  final Icon iconss;
  const MainScreenButtonWidget({Key? key, required this.buttonname,this.onpressesd,required this.iconss}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onpressesd,
      child: Container(
        height: 50,
        width: 300,
        margin: EdgeInsets.only(left: 10,top: 15),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.grey.shade300,
                  Colors.cyan.shade100,
                ]
            ),
            borderRadius: BorderRadius.only(bottomRight:Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey,
                  blurRadius: 3,spreadRadius:0.5)
            ]
        ),
        child: Row(
          children: [
            Expanded(child: iconss),
            Center(
              child: Text(buttonname,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.blue)),
            ),
            Expanded(child: Center())
          ],
        ),

      ),
    );
  }
}
