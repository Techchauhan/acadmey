import 'package:academy/userScreens/dashboardScreen/homepage.dart';
import 'package:academy/userScreens/dashboardScreen/dashboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class NavigatorPage extends StatefulWidget {
  const NavigatorPage(this.userid, {super.key});

  final String? userid;

  @override
  State<NavigatorPage> createState() => _NavigatorPageState();
}

class _NavigatorPageState extends State<NavigatorPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final user = FirebaseAuth.instance.currentUser;

  final String? photoURL = FirebaseAuth.instance.currentUser!.photoURL;

  final email = FirebaseAuth.instance.currentUser!.email;

  final GoogleSignIn googleSignIn = GoogleSignIn();

  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.reference();

  int _currentIndex = 0;

  final List<Widget> _tabs = [
    HomePage(FirebaseAuth.instance.currentUser!.uid),
    const Dashboard(),
    const Dashboard(),
  ];

  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(widget.userid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return WillPopScope(
            onWillPop: () async {
              // Perform sign-out when back button is pressed
              return false; // Allow the user to navigate back
            },
            child: SafeArea(
              child: Scaffold(

                bottomNavigationBar: BottomNavigationBar(
                  currentIndex: _currentIndex,
                  onTap: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.dashboard),
                      label: 'Dashboard',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.settings),
                      label: 'Settings',
                    ),
                  ],
                ),
                body:   _tabs[_currentIndex],

              ),
            ),
          );
        }
        return Container(
          color: Colors.white,
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }


}


