import 'package:academy/userScreens/navigator.dart';
import 'package:academy/userScreens/profiile/AnalyticsProfilePage.dart';
import 'package:academy/userScreens/profiile/infoPage.dart';
import 'package:academy/userScreens/profiile/postProfilePage.dart';
import 'package:academy/userScreens/profiile/reelsProfilePage.dart';
import 'package:academy/widgets/CustomProgressIndicator3.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final photoURL = FirebaseAuth.instance.currentUser!.photoURL;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> _getUser() async {
    return _auth.currentUser;
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> _getUserData(String uid) {
    return _firestore.collection('users').doc(uid).get();
  }

  bool showMessageBox = false;

  void toggleMessageBox() {
    setState(() {
      showMessageBox = !showMessageBox;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Handle the back button press here
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => NavigatorPage(
                    FirebaseAuth.instance.currentUser!.uid,
                    initialIndex: 0))); // This pops the current page
        return false; // Return false to prevent app from closing
      },
      child: Scaffold(
        body: FutureBuilder<User?>(
          future: _getUser(),
          builder: (context, userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return const MyProgressIndicator3();
            }

            if (!userSnapshot.hasData || userSnapshot.data == null) {
              return const Center(child: Text('No user logged in.'));
            }

            final User user = userSnapshot.data!;

            return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              future: _getUserData(user.uid),
              builder: (context, userDataSnapshot) {
                if (userDataSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: MyProgressIndicator3(),
                  );
                }

                if (!userDataSnapshot.hasData ||
                    userDataSnapshot.data == null) {
                  return const Center(child: Text('No user data found.'));
                }

                final userData = userDataSnapshot.data!.data()!;

                return Scaffold(
                  appBar: AppBar(
                    leading: BackButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NavigatorPage(
                                    FirebaseAuth.instance.currentUser!.uid,
                                    initialIndex:
                                        0))); // This pops the current page
                      },
                    ),
                    backgroundColor: Colors.blue,
                    title: const Text("My Profile"),
                    actions: [
                      InkWell(
                        onTap: () {
                          const AlertDialog(
                            title: Text("Update Info"),
                            actions: [
                              Row(
                                children: [Text("This is onte")],
                              ),
                              Row(
                                children: [Text("This is onte")],
                              )
                            ],
                          );
                          //Handle the report button
                        },
                        child: Container(
                          padding: const EdgeInsets.only(right: 10),
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  Fluttertoast.showToast(
                                    msg:
                                        'Contact to your Teacher to Update the Data.',
                                  );
                                },
                                icon: const Icon(
                                  Icons.info_outlined,
                                  color: Colors.red,
                                ),
                              ),
                              const Text("Update Info")
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  body: Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 150,
                          decoration: const BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(40),
                                  bottomRight: Radius.circular(40))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                maxRadius: 50,
                                minRadius: 50,
                                backgroundColor: Colors.black,
                                backgroundImage:
                                    NetworkImage(photoURL.toString()),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "${user.displayName}",
                                    style: const TextStyle(
                                        fontSize: 30,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Class: ${userData['admissionClass']}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        //Here I want to show the three scrolling tab.
                        const Expanded(
                          child: Scaffold(
                            body: DefaultTabController(
                              length: 4, // Number of tabs
                              child: Column(
                                children: [

                                  TabBar(
                                    tabs: [
                                      Column(
                                        children: [
                                          Icon(
                                            Icons.analytics,
                                            size: 20,
                                          ),
                                          Text("Analytics")
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Icon(
                                            Icons.edit_note,
                                            size: 20,
                                          ),
                                          Text("Posts")
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Icon(
                                            Icons.person,
                                            size: 20,
                                          ),
                                          Text("Info")
                                        ],
                                      )
                                    ],
                                  ),
                                  Expanded(
                                    child: TabBarView(
                                      children: [
                                        // Content of Tab 1
                                        AnalyticsProfilePage(),
                                        // Content of Tab 2
                                        PostProfilePage(),
                                        // Content of Tab 3
                                        Info(),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
