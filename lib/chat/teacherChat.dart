import 'package:flutter/material.dart';

class TeacherChatScreen extends StatefulWidget {
  const TeacherChatScreen({super.key});

  @override
  State<TeacherChatScreen> createState() => _TeacherChatScreenState();
}

class _TeacherChatScreenState extends State<TeacherChatScreen> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Teacher Chat"),
    );
  }
}
