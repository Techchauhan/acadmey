import 'package:academy/Basic%20Pages/settingPage.dart';
import 'package:academy/Books/mainBooksPage.dart';
import 'package:academy/service/quotesPage.dart';
import 'package:academy/userScreens/dashboardScreen/homepage.dart';
import 'package:academy/userScreens/dashboardScreen/dashboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../widgets/CustomProgressIndicator3.dart';

class NavigatorPage extends StatefulWidget {
  const NavigatorPage(this.userid, {super.key, required this.initialIndex});

  final String? userid;
  final int initialIndex;

  @override
  State<NavigatorPage> createState() => _NavigatorPageState();
}

class _NavigatorPageState extends State<NavigatorPage> {
  final user = FirebaseAuth.instance.currentUser;

  final String? photoURL = FirebaseAuth.instance.currentUser!.photoURL;

  final email = FirebaseAuth.instance.currentUser!.email;

  final GoogleSignIn googleSignIn = GoogleSignIn();

  final DatabaseReference _databaseReference =
  FirebaseDatabase.instance.reference();

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Set the initial index to the value passed from SettingPage
    _currentIndex = widget.initialIndex;
  }

  final List<Widget> _tabs = [
    HomePage(FirebaseAuth.instance.currentUser!.uid),
    const Dashboard(),
    MainBooksPage(),
    const SettingPage(),
  ];

  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
  }

  // Add a method to fetch cached data from SharedPreferences
  Future<String?> getCachedData() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('navigatorPageData');
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference users =
    FirebaseFirestore.instance.collection('users');

    return FutureBuilder<String?>(
      future: getCachedData(),
      builder: (BuildContext context, AsyncSnapshot<String?> cachedSnapshot) {
        if (cachedSnapshot.hasError) {
          return const Text("Something went wrong");
        }

        if (cachedSnapshot.hasData && cachedSnapshot.data != null) {
          // Use cached data
          final parsedData = json.decode(cachedSnapshot.data!); // Use appropriate parsing based on your data structure
          return buildNavigatorPageWithData(parsedData);
        } else {
          // Data not found in shared preferences, fetch from the server
          return FutureBuilder<DocumentSnapshot>(
            future: users.doc(widget.userid).get(),
            builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text("Something went wrong");
              }

              if (snapshot.hasData && !snapshot.data!.exists) {
                return const Text("Document does not exist");
              }

              if (snapshot.connectionState == ConnectionState.done) {
                final data = snapshot.data!.data() as Map<String, dynamic>;
                final jsonData = json.encode(data); // Serialize data to JSON

                // Cache the fetched data
                cacheData(jsonData);

                return buildNavigatorPageWithData(data);
              }

              return Container(
                color: Colors.white,
                child: const Center(
                  child: MyProgressIndicator3(),
                ),
              );
            },
          );
        }
      },
    );
  }

  // Add a method to cache data in SharedPreferences
  void cacheData(String data) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('navigatorPageData', data);
  }

  Widget buildNavigatorPageWithData(Map<String, dynamic> data) {
    return WillPopScope(
      onWillPop: () async {
        // Perform sign-out when the back button is pressed
        return true; // Allow the user to navigate back
      },
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
              icon: Icon(Icons.home, color: Colors.white,),
              label: 'Home',
              backgroundColor: Colors.black87
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: 'Dashboard',
                backgroundColor: Colors.black87
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_sharp),
              label: 'Books',
                backgroundColor: Colors.black87
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
                backgroundColor: Colors.black87
            ),
          ],
        ),
        body: _tabs[_currentIndex],
      ),
    );
  }
}



