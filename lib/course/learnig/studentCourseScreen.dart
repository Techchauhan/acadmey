import 'package:academy/course/learnig/LectureVideoScreen.dart';
import 'package:academy/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';


class StudentCourseScreen extends StatefulWidget {
  final String courseId;

  const StudentCourseScreen({super.key, required this.courseId});

  @override
  _StudentCourseScreenState createState() => _StudentCourseScreenState();
}

class _StudentCourseScreenState extends State<StudentCourseScreen> {
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Course'),
        leading: IconButton(
          onPressed: (){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> MyApp()));
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: StreamBuilder(
        stream: _databaseReference
            .child('courses')
            .child(widget.courseId)
            .child('chapters')
            .onValue,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            final chaptersData = snapshot.data?.snapshot.value;

            if (chaptersData is Map) {
              return ListView(
                children: chaptersData.entries.map((entry) {
                  final chapterId = entry.key;
                  final chapterInfo = entry.value as Map<dynamic, dynamic>;

                  return ExpansionTile(
                    title: Text(chapterInfo['title']),
                    children: chapterInfo['lectures'] != null
                        ? (chapterInfo['lectures'] as Map<dynamic, dynamic>)
                        .entries
                        .map((lectureEntry) {
                      final lectureId = lectureEntry.key;
                      final lectureInfo =
                      lectureEntry.value as Map<dynamic, dynamic>;

                      return ListTile(
                        title: Text(lectureInfo['title']),
                        subtitle: Text(lectureInfo['videoUrl']),
                        trailing: IconButton(
                          icon: const Icon(Icons.play_circle),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LectureVideoScreen(
                                  videoUrl: lectureInfo['videoUrl'], chapterId: chapterId,
                                ),
                              ),
                            );
                          },
                        ),

                      );
                    }).toList()
                        : [], // Handle if lectures are null
                  );
                }).toList(),
              );
            } else {
              return const Center(
                child: Text('No chapters available.'),
              );
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
