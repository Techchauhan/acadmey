import 'package:academy/course/exploreCourse/courseExploreScreen.dart';
import 'package:academy/userScreens/dashboardScreen/homepage.dart';
import 'package:academy/userScreens/navigator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class VideoLectureCourse extends StatefulWidget {
  const VideoLectureCourse({Key? key}) : super(key: key);

  @override
  State<VideoLectureCourse> createState() => _VideoLectureCourseState();
}

class _VideoLectureCourseState extends State<VideoLectureCourse> {
  final DatabaseReference _databaseReference =
  FirebaseDatabase.instance.reference();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    MainHomePage(FirebaseAuth.instance.currentUser!.uid)));
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          body: StreamBuilder(
            stream: _databaseReference.child('courses').onValue,
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                final courseData =
                snapshot.data?.snapshot.value as Map<dynamic, dynamic>;
                return ListView.builder(
                  itemCount: courseData.entries.length,
                  itemBuilder: (context, index) {
                    final entry = courseData.entries.elementAt(index);
                    final courseId = entry.key;
                    final courseInfo = entry.value as Map<dynamic, dynamic>;

                    return Container(
                      width: double.infinity,
                      margin: const EdgeInsets.all(9),
                      child: Card(
                        color: Colors.white,
                        child: InkWell(
                          onTap: () {
                            // Handle tap
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                title: Text(
                                  courseInfo['title'],
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(left: 20, right: 20),
                                height: 200,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white,
                                ),
                                child: courseInfo.containsKey('thumbnail')
                                    ? Image.network(
                                  courseInfo['thumbnail'],
                                  width: double.infinity,
                                  height: 100,
                                  fit: BoxFit.cover,
                                )
                                    : Container(),
                              ),
                              const SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.only(left: 20, right: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.person),
                                        const Text("For preparation of "),
                                        Text(
                                          courseInfo['courseFor'],
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        const Icon(Icons.calendar_month),
                                        const Text("Start on "),
                                        Text(
                                          courseInfo['startDate'],
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    const Row(
                                      children: [
                                        Icon(Icons.star),
                                        Text("Explore for more"),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Divider(thickness: 3),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CourseExplorationPage(courseId: courseId)));
                                    },
                                    child: const Text("Explore"),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      // Handle enrollment
                                    },
                                    child: const Text("Enroll Now"),
                                  )
                                ],
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
