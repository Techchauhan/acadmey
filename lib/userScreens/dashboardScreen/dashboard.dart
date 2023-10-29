import 'package:academy/userScreens/Downloads/videoDownloads.dart';
import 'package:academy/userScreens/dashboardScreen/VideoCourseDashboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
      ),
      body: DefaultTabController(
        length: 2, // Number of tabs
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCard(
                  color: Colors.blueAccent,
                  text: 'Live Lectures',
                  subtitle: '5 ',
                ),
                _buildCard(
                  color: Colors.blueAccent,
                  text: 'Video Course',
                  subtitle: '4',
                ),
              ],
            ),
            const TabBar(
              tabs: [
                Tab(text: 'Live Lecture'),
                Tab(text: 'Video Course'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // Replace the following with your Live Course content
                  _showSubjectList(),
                  // Replace the following with your Video Course content
                  const VideoCourseDashboard()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Your _buildCard method remains the same.
  Widget _buildCard(
      {required Color color, required String text, required String subtitle}) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: color,
      child: Container(
        width: 200,
        height: 150,
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                text,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              // Update the subtitle with the count of purchased video courses
              FutureBuilder<int>(
                future: _getPurchasedVideoCoursesCount(), // Fetch the count
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return const Text('Error');
                  }
                  return Text(
                    snapshot.data.toString(),
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<int> _getPurchasedVideoCoursesCount() async {
    try {
      // Fetch the count of purchased video courses from Firestore
      String userId = FirebaseAuth.instance.currentUser!.uid;
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('purchased_course')
          .get();

      // Return the count of purchased video courses
      return querySnapshot.size;
    } catch (e) {
      // Handle any errors, e.g., no data or Firestore issues
      return 0;
    }
  }





  Widget _showSubjectList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('subjects')
          .doc('class9')
          .collection('subject')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        List<QueryDocumentSnapshot> collections = snapshot.data!.docs;

        return Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              itemCount: collections.length,
              itemBuilder: (context, index) {
                String collectionName = collections[index].id;
                return ListTile(
                  title: Text(collectionName),
                  onTap: () {
                    // Handle the tap event here, e.g., navigate to a detail page
                    // when a collection is tapped.
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }


}
