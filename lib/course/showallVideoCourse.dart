import 'package:academy/course/exploreCourse/courseExploreScreen.dart';
import 'package:academy/userScreens/dashboardScreen/homepage.dart';
import 'package:academy/userScreens/navigator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';


class ShowAllCourse extends StatefulWidget {
  const ShowAllCourse({Key? key}) : super(key: key);

  @override
  State<ShowAllCourse> createState() => _ShowAllCourseState();
}

class _ShowAllCourseState extends State<ShowAllCourse> {
  final DatabaseReference _databaseReference =
  FirebaseDatabase.instance.reference();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Handle the back button press here
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> HomePage(FirebaseAuth.instance.currentUser!.uid) )); // This pops the current page
        return false; // Return false to prevent app from closing
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text("All Course"),
            leading: BackButton(
              onPressed: (){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>NavigatorPage(FirebaseAuth.instance.currentUser!.uid)));
              },
            ),
          ),
          body: StreamBuilder(
            stream: _databaseReference.child('courses').onValue,
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                final courseData =
                snapshot.data?.snapshot.value as Map<dynamic, dynamic>;
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: courseData.entries.map((entry) {
                      final courseId = entry.key;
                      final courseInfo = entry.value as Map<dynamic, dynamic>;
                      return Container(
                        width: 300,
                        height: 500,
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
                                  width: 300,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.white,
                                  ),
                                  child: courseInfo.containsKey('thumbnail')
                                      ? Image.network(
                                    courseInfo['thumbnail'],
                                    width: 250,
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
                                        // Navigate to Explore Screen
                                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>CourseExplorationPage(courseId: courseId)));

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
                    }).toList(),
                  ),
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
