import 'package:academy/course/learnig/LectureVideoScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ViewChaptersPage extends StatefulWidget {
  final String courseId;
  ViewChaptersPage({super.key, required this.courseId});

  @override
  State<ViewChaptersPage> createState() => _ViewChaptersPageState();
}

class _ViewChaptersPageState extends State<ViewChaptersPage> {
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chapters and Lectures'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('courses')
            .doc(widget.courseId)
            .collection('chapters')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No chapters available.'),
            );
          }

          final chaptersData = snapshot.data!.docs;

          return ListView(
            children: chaptersData.map((chapterDoc) {
              final chapterInfo = chapterDoc.data() as Map<String, dynamic>;
              final chapterId = chapterDoc.id;
              final chapterTitle = chapterInfo['title'];

              return ExpansionTile(
                title: Text(
                  chapterTitle,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                children: [
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('courses')
                        .doc(widget.courseId)
                        .collection('chapters')
                        .doc(chapterId)
                        .collection('lectures')
                        .snapshots(),
                    builder: (context, lectureSnapshot) {
                      if (lectureSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (lectureSnapshot.hasError) {
                        return Text('Error: ${lectureSnapshot.error}');
                      }

                      if (!lectureSnapshot.hasData ||
                          lectureSnapshot.data!.docs.isEmpty) {
                        return const Center(
                          child: Text('No lectures available.'),
                        );
                      }

                      final lecturesData = lectureSnapshot.data!.docs;

                      return Column(
                        children: lecturesData.map((lectureDoc) {
                          final lectureInfo =
                          lectureDoc.data() as Map<String, dynamic>;
                          final lectureId = lectureDoc.id;

                          return ListTile(
                            title: Text(lectureInfo['title']),
                            // subtitle: Text(lectureInfo['videoUrl']),
                            trailing: IconButton(
                              icon: const Icon(Icons.play_circle),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LectureVideoScreen(
                                      videoUrl: lectureInfo['videoUrl'],
                                      chapterId: widget.courseId,
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ],
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
