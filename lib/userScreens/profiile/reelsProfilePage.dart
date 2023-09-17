import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class ReelsProfilePage extends StatefulWidget {
  const ReelsProfilePage({Key? key}) : super(key: key);

  @override
  State<ReelsProfilePage> createState() => _ReelsProfilePageState();
}

class _ReelsProfilePageState extends State<ReelsProfilePage> {

  final ImagePicker _imagePicker = ImagePicker();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> initializeSecondFirebaseApp() async {
    await Firebase.initializeApp(
      name: 'Social_Academy',
      options: FirebaseOptions(
        appId: '1:893108344546:android:994fe039ef7555fcfc70bb',
        apiKey: 'AIzaSyDebDv_AGtNFRUsCChkciHUpceDNbeFSBw',
        messagingSenderId: 'your_messaging_sender_id',
        projectId: 'socialacademy-9758f',
        storageBucket: 'socialacademy-9758f.appspot.com',
      ),
    );
  }

  Future<void> _uploadVideo() async {
    final XFile? video = await _imagePicker.pickVideo(source: ImageSource.gallery);

    if (video != null) {
      // Check if the user is authenticated
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        // Handle the case where the user is not authenticated
        // You might want to show an error message or redirect to the login screen
        print('User is not authenticated.');
        return;
      }

      // Initialize Firebase for the second project
      await initializeSecondFirebaseApp();

      // Generate a unique filename for the uploaded video
      final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final String fileName = 'video_$timestamp.mp4';

      // Reference the Firebase Storage instance for the second project
      Reference storageReference = FirebaseStorage.instanceFor(
        app: Firebase.app('Social_Academy'),
      ).ref().child('videos/$fileName');

      UploadTask uploadTask = storageReference.putFile(File(video.path));

      // Wait for the upload to complete
      await uploadTask.whenComplete(() async {
        // Retrieve the download URL of the uploaded video
        String videoUrl = await storageReference.getDownloadURL();
        // Store the video URL in the 'user/social/video' subcollection
        await firestore.collection('users').doc(user.uid).collection('social').doc(user.uid).collection('video').add({'videoUrl': videoUrl});
        print('Video URL: $videoUrl');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ReelsGrid(),
      floatingActionButton: SpeedDial(
        icon: Icons.upload,
        onPress: () {
          _uploadVideo();
        },
      ),
    );
  }
}

class ReelsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('social')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('video')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        final videos = snapshot.data!.docs;

        if (videos.isEmpty) {
          return Center(
            child: Text("No Videos Found"),
          );
        }

        return ListView.builder(
          itemCount: videos.length,
          itemBuilder: (BuildContext context, int index) {
            final video = videos[index];
            final videoUrl = video['videoUrl'] as String;

            // Create a VideoPlayerController to play the video
            final controller = VideoPlayerController.network(videoUrl);

            return InkWell(
              onTap: () {
                // Handle tapping on a video, e.g., navigate to a video player screen
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => VideoPlayerScreen(controller: controller),
                ));
              },
              child: Card(
                elevation: 3,
                child: VideoPlayer(controller), // Display the video
              ),
            );
          },
        );
      },
    );
  }
}


class VideoPlayerScreen extends StatelessWidget {
  final VideoPlayerController controller;

  VideoPlayerScreen({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Video Player"),
      ),
      body: Center(
        child: AspectRatio(
          aspectRatio: controller.value.aspectRatio,
          child: VideoPlayer(controller),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (controller.value.isPlaying) {
            controller.pause();
          } else {
            controller.play();
          }
        },
        child: Icon(
          controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }
}
