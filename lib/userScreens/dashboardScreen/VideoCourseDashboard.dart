import 'package:academy/course/learnig/studentCourseScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class VideoCourseDashboard extends StatefulWidget {
  const VideoCourseDashboard({super.key});

  @override
  State<VideoCourseDashboard> createState() => _VideoCourseDashboardState();
}

class _VideoCourseDashboardState extends State<VideoCourseDashboard> {
  @override
  Widget build(BuildContext context) {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    return  StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('purchased_course')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        // Display the purchased courses
        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;
            String courseName = data['course_name'];
            String courseID = data['course_id'];

            return InkWell(
              onTap: (){
                Fluttertoast.showToast(msg: 'Opening..');
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ViewChaptersPage(courseId: courseID)),
                );
              },
              child: ListTile(
                title: Text(courseName),
                // You can add more details here if needed
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
