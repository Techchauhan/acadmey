import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TeachersListforHomeScreen extends StatelessWidget {
  const TeachersListforHomeScreen({Key? key});

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

  @override
  Widget build(BuildContext context) {
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
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return SizedBox(
                height: 40,
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: NetworkImage(snapshot.data![index]),
                    ),
                  ],
                ),
              );
            },
          );
        }
      },
    );
  }
}
