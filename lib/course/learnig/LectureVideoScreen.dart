import 'package:chewie/chewie.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:video_player/video_player.dart';

class LectureVideoScreen extends StatefulWidget {
  final String videoUrl;
  final String chapterId;


  const LectureVideoScreen(
      {super.key, required this.videoUrl,
      required this.chapterId,
       });


  @override
  _LectureVideoScreenState createState() => _LectureVideoScreenState();
}

class _LectureVideoScreenState extends State<LectureVideoScreen> {
  late ChewieController _chewieController;
  List<String> lectures = [];
  List<String> lectures2 = [];

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
    _fetchLectures();
  }

  @override
  void dispose() {
    _chewieController.dispose();
    _chewieController.videoPlayerController
        .dispose(); // Dispose video player controller
    super.dispose();
  }

  void _initializeVideoPlayer() {
    final videoPlayerController = VideoPlayerController.network(widget.videoUrl);
    _chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoPlay: true,
      looping: false,
      showControls: true, // Set to true to show video controls
      // Other options can be configured here
    );
    _chewieController.addListener(() {
      if (!_chewieController.isPlaying) {
        // Handle video completion or pausing here if needed
      }
    });
  }

  void _fetchLectures() {
    final DatabaseReference chapterRef = FirebaseDatabase.instance
        .reference()
        .child('chapters')
        .child(widget.chapterId)
        .child('lectures');

    chapterRef.onValue.listen((event) {
      if (event.snapshot.value != null && event.snapshot.value is Map) {
        final Map<dynamic, dynamic> lectureData =
            event.snapshot.value as Map<dynamic, dynamic>;
        lectures = lectureData.values.toList().cast<String>();

        setState(() {});
      }
    });
  }

  // Rest of the code remains the same

  // Rest of your code

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lecture Video'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final videoAspectRatio =
                  _chewieController.videoPlayerController.value.aspectRatio;
              return AspectRatio(
                aspectRatio: videoAspectRatio,
                child: Chewie(
                  controller: _chewieController,
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.6,
                ),
                child: const SizedBox(
                  height: 800,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                       Text("Heading 1", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),),
                       SizedBox(height: 20,),
                       Text("paragraph: This is the example view of the lectures, a very soon this will update and reflected the correct data.")
                      ],
                    ),
                  )
                ),
              ),
            ),
          )
        ],
      ),
      floatingActionButton:  SpeedDial(
        icon: Icons.download,
        label: const Text("Download Notes"),
        onPress: (){
          Fluttertoast.showToast(msg: "Downloading Start...");
        },
        animatedIconTheme: const IconThemeData(size: 22.0),
        curve: Curves.easeInOut,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,

      )
      ,
    );
  }
}
