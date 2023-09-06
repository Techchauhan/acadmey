import 'package:academy/course/padiorfree/LiveClassesCourse.dart';
import 'package:academy/course/padiorfree/VideoLecturecourse.dart';
import 'package:academy/userScreens/navigator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DecidePaidorFree(),
    );
  }
}

class DecidePaidorFree extends StatefulWidget {
  @override
  _DecidePaidorFreeState createState() => _DecidePaidorFreeState();
}

class _DecidePaidorFreeState extends State<DecidePaidorFree> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // Initialize the TabController with 2 tabs (Paid and Free).
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose(); // Don't forget to dispose of the controller.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>NavigatorPage(FirebaseAuth.instance.currentUser!.uid)));
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: (){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>NavigatorPage(FirebaseAuth.instance.currentUser!.uid)));
            },
          ),
          title: Text('Course Selection'),
          centerTitle: true,
        ),
        body: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container( // Container with circular border radius
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(color: Colors.blue), // Border color
                  ),
                  child: TabBar(
                    controller: _tabController,
                    tabs: [
                      Tab(
                        text: 'Live Course',
                      ),
                      Tab(
                        text: 'Video Course',
                      ),
                    ],
                    indicatorColor: Colors.blue, // Change the indicator color
                  ),
                ),
                SizedBox(height: 20.0),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // Paid Course content goes here
                      LiveClassCourse(),
                      // Free Course content goes here
                      VideoLectureCourse(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
