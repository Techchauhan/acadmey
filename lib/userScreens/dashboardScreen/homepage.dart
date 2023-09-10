import 'package:academy/Basic%20Pages/aboutUs.dart';
import 'package:academy/Basic%20Pages/helpSupport.dart';
import 'package:academy/Basic%20Pages/settingPage.dart';
import 'package:academy/chat/chatScreen.dart';
import 'package:academy/course/padiorfree/decideliveOrVideo.dart';
import 'package:academy/slideshow/viewSlidewshow.dart';
import 'package:academy/teachers/TeacherListForHomeScreen.dart';
import 'package:academy/teachers/allTeacherView.dart';
import 'package:academy/userScreens/Downloads/downloader.dart';
import 'package:academy/userScreens/authentication/login_screen.dart';
import 'package:academy/userScreens/dashboardScreen/myprofile.dart';
import 'package:academy/widgets/CustomProgressIndicator3.dart';
import 'package:academy/widgets/animatedButton.dart';
import 'package:academy/widgets/animatedButton2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  HomePage(this.userid);

  final String? userid;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final user = FirebaseAuth.instance.currentUser;

  final String? photoURL = FirebaseAuth.instance.currentUser!.photoURL;

  final email = FirebaseAuth.instance.currentUser!.email;

  final GoogleSignIn googleSignIn = GoogleSignIn();

  final String name = '';

  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.reference();

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    CollectionReference<Map<String, dynamic>> users = _firestore.collection('users');


    // Check shared preferences for cached data
    Future<String?> getCachedData() async {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('homeScreenData');
    }

    return FutureBuilder<String?>(
      future: getCachedData(),
      builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }

        final cachedData = snapshot.data;

        if (cachedData != null) {
          // Use cached data
          final parsedData = json.decode(cachedData); // Use appropriate parsing based on your data structure
          return buildHomeScreenWithData(parsedData);
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

                return buildHomeScreenWithData(data);
              }

              return const Center(
                child: MyProgressIndicator3(),
              );
            },
          );
        }
      },
    );
  }

  // Cache data in shared preferences
  void cacheData(String data) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('homeScreenData', data);
  }

  Widget buildHomeScreenWithData(Map<String, dynamic> data) {
    // Your existing home screen UI logic here
    // Use the 'data' parameter to populate your UI with the fetched data
    // ...

    return WillPopScope(
      onWillPop: () async {
        // Perform sign-out when back button is pressed
        return false; // Allow the user to navigate back
      },
      child: Scaffold(
        drawer: Drawer(
          child: Column(
            children: [
              const SizedBox(height: 60,),
              CircleAvatar(
                minRadius: 30,
                maxRadius: 30,
                backgroundImage: photoURL != null
                    ? NetworkImage(
                    photoURL.toString())
                    : const NetworkImage(
                    'https://cdn-icons-png.flaticon.com/512/149/149071.png'),
              ),
              const SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  const Text(
                    "Hello! ",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight:
                        FontWeight.bold,
                        fontSize: 20),
                  ),
                  Text(

                      data['firstName'] != null && data['firstName'].toString().isNotEmpty
                          ? data['firstName'].toString()
                          : FirebaseAuth.instance.currentUser!.displayName.toString(),
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight:
                          FontWeight.w500,
                          fontSize: 20)),
                ],
              ),
              const Divider(
                height: 1,
              ),
              DrawerButton(
                title: "Drought",
                onPress: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SettingPage()));
                },
                icon: Icons.question_mark,
              ),
              DrawerButton(
                title: "Setting",
                onPress: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SettingPage()));
                },
                icon: Icons.settings,
              ),
              const SizedBox(height: 10),
              DrawerButton(
                title: "Help & Support",
                onPress: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => const HelpAndSupportPage()));
                },
                icon: Icons.support_agent,
              ),
              const SizedBox(height: 10),
              DrawerButton(
                title: "About us",
                onPress: () {

                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => const AboutUsPage()));
                },
                icon: Icons.info,
              ),
              const SizedBox(
                height: 20,
              ),
              DrawerButton(
                title: 'Logout',
                icon: Icons.logout,
                onPress: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()));
                },
              ),
            ],
          ),
        ),
        appBar: AppBar(
          backgroundColor: Colors.white,
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Downloder()));
                // Handle button tap here
                // You can add your custom logic when the button is tapped
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Lottie.asset(
                    'assets/download.json', // Replace with your Lottie animation path
                    width: 40, // Adjust the width as needed
                    height: 40, // Adjust the height as needed
                    fit: BoxFit.cover, // Fit the animation within the specified dimensions
                  ),

                ],
              ),
            ),
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.notifications,
                  size: 30,
                )),
          ],
        ),
        body: StreamBuilder(
          stream: _databaseReference.child('courses').onValue,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              final courseData = snapshot.data?.snapshot.value
              as Map<dynamic, dynamic>;

              return SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 100,
                      decoration: const BoxDecoration(
                        // color: Colors.yellow,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          const Text(
                                            "Hello! ",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight:
                                                FontWeight.bold,
                                                fontSize: 26),
                                          ),
                                          Text(
                                              data['firstName'] != null && data['firstName'].toString().isNotEmpty
                                                  ? data['firstName'].toString()
                                                  : FirebaseAuth.instance.currentUser!.displayName.toString(),
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontWeight:
                                                  FontWeight.w500,
                                                  fontSize: 26)),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding:
                                                const EdgeInsets.only(
                                                    left: 20),
                                                child: Container(
                                                  width: 300,
                                                  height: 40,

                                                  child: TextField(
                                                    decoration: InputDecoration(
                                                      alignLabelWithHint:  true,
                                                      contentPadding: const EdgeInsets.symmetric(horizontal: 40),
                                                      hintText: 'Search...',
                                                      prefixIcon: const Icon(Icons.search),
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(25),
                                                      ),
                                                    ),
                                                    onChanged: (value) {
                                                      // Handle search query changes here
                                                    },
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                              const MyProfile()));
                                    },
                                    child: CircleAvatar(
                                      minRadius: 30,
                                      maxRadius: 40,
                                      backgroundImage: photoURL != null
                                          ? NetworkImage(
                                          photoURL.toString())
                                          : const NetworkImage(
                                          'https://cdn-icons-png.flaticon.com/512/149/149071.png'),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Add your additional children here
                    Column(
                      children: [
                        ViewSlideShow(),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: TextButton(
                              onPressed: (){
                                //Implement the functions when the student click on the our Expert Teachers.
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const TeachersListScreen(),
                                  ),
                                );
                              },
                              child: const Text("Our Expert Teachers", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20),),
                            ),
                          ),
                        ),
                        Container(
                            height: 100,
                            child: TeachersListforHomeScreen()),
                        SizedBox(height: 20,),
                        // Add your additional children here
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                AnimatedButton(
                                  onPress: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>   DecidePaidorFree(),
                                      ),
                                    );
                                  },
                                ),
                                AnimateButton2(
                                  onPress: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>  const TeachersListScreen(),
                                      ),
                                    );
                                  },
                                )
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),
                        const Text('ADDING MORE WIDGETS SOON'),
                      ],
                    ),

                    const SizedBox(height: 10),

                    const Text('ADDING MORE WIDGETS SOON'),

                    SizedBox(height: 200,)
                  ],
                ),
              );
            } else {
              return const Center(
                child: MyProgressIndicator3(),
              );
            }
          },
        ),
        floatingActionButton: SpeedDial(
          icon: Icons.chat,
          onPress: (){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ChatScreen()));
          },
        ),
      ),
    );
  }

}

class DrawerButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onPress;

  const DrawerButton({
    super.key,
    required this.title,
    required this.icon,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          InkWell(
            onTap: onPress,
            child: Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(
                  width: 10,
                ),
                Icon(icon),
              ],
            ),
          ),
          const SizedBox(
            height: 50,
          )
        ],
      ),
    );
  }
}
