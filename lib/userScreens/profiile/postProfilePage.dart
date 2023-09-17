import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class PostProfilePage extends StatefulWidget {
  const PostProfilePage({super.key});

  @override
  State<PostProfilePage> createState() => _PostProfilePageState();
}

class _PostProfilePageState extends State<PostProfilePage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child: Text("Name"),
      ),
      floatingActionButton: SpeedDial(
        icon: Icons.edit_note,
        onPress: (){
          // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ChatScreen()));
        },
      ),
    );
  }
}
