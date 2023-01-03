
import 'package:firebase/Screens/simple%20firebase%20screen/post_list_screen.dart';
import 'package:firebase/Screens/simple%20firebase%20screen/user_info_screen_state.dart';
import 'package:firebase/Screens/simple%20firebase%20screen/users_list_screen.dart';
import 'package:flutter/material.dart';
import '../../Widgets/main_screen_button_widget.dart';
import '../home_screen.dart';

class ButtonScreen1 extends StatefulWidget {
  const ButtonScreen1({Key? key}) : super(key: key);

  @override
  State<ButtonScreen1> createState() => _ButtonScreen1State();
}

class _ButtonScreen1State extends State<ButtonScreen1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Main Screen"),
        backgroundColor: Colors.cyan,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MainScreenButtonWidget(
                  iconss: Icon(Icons.account_circle_outlined,),
                  buttonname:"USER INFO SCREEN STATE",
                  onpressesd: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>UserInfoScreenState()));
                  },
                ),
                MainScreenButtonWidget(buttonname: "Users List Screen", iconss: Icon(Icons.account_box),onpressesd: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>UsersListScreen()));},),
                MainScreenButtonWidget(
                  buttonname: "ADD POST SSCREEN STATE",
                  iconss: Icon(Icons.post_add_outlined,
                  ),

                  onpressesd:(){Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));} ,),
                MainScreenButtonWidget(buttonname: "Post List Screen", iconss: Icon(Icons.post_add_outlined),
                onpressesd: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>PostListScreen()));},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

