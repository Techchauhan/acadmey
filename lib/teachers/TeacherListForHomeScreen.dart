import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TeachersListforHomeScreen extends StatefulWidget {
  const TeachersListforHomeScreen({Key? key});

  @override
  _TeachersListforHomeScreenState createState() =>
      _TeachersListforHomeScreenState();
}

class _TeachersListforHomeScreenState extends State<TeachersListforHomeScreen> {
  Future<List<String>> fetchTeacherImages() async {
    List<String> teacherImages = [];
    QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection('teachers').get();

    for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
      Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
      String profilePhotoUrl = data['profilePhoto'] ?? '';

      teacherImages.add(profilePhotoUrl);
    }

    return teacherImages;
  }

  // Add a method to fetch cached data from SharedPreferences
  Future<List<String>> getCachedData() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('teacherImages') ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: getCachedData(),
      builder: (context, cachedSnapshot) {
        if (cachedSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          ); // Loading indicator
        } else if (cachedSnapshot.hasError) {
          return Text('Error: ${cachedSnapshot.error}');
        } else if (cachedSnapshot.hasData && cachedSnapshot.data!.isNotEmpty) {
          // Use cached data
          final teacherImages = cachedSnapshot.data!;
          return buildTeacherList(teacherImages);
        } else {
          return FutureBuilder<List<String>>(
            future: fetchTeacherImages(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                ); // Loading indicator
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Text('No teachers found.');
              } else {
                // Cache the fetched data
                cacheData(snapshot.data!);

                return buildTeacherList(snapshot.data!);
              }
            },
          );
        }
      },
    );
  }

  // Add a method to cache data in SharedPreferences
  void cacheData(List<String> data) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('teacherImages', data);
  }

  Widget buildTeacherList(List<String> teacherImages) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: teacherImages.length,
      itemBuilder: (context, index) {
        return SizedBox(
          height: 40,
          child: Column(
            children: [
              CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(teacherImages[index]),
              ),
            ],
          ),
        );
      },
    );
  }
}

