
import 'package:academy/userScreens/dashboardScreen/homepage.dart';
import 'package:academy/userScreens/dashboardScreen/myprofile.dart';
import 'package:academy/userScreens/navigator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';



class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {

  User? user = FirebaseAuth.instance.currentUser;


  @override
  Widget build(BuildContext context) {

    if (user != null) {
      String uid = user!.uid;
      print("User UID: $uid");
    } else {
      print("No user is currently logged in.");
    }

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
          title: const Text('Settings'),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const SectionHeader(title: 'Account'),
              SettingsOption(
                title: 'Edit Profile',
                onTap: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const MyProfile()));

                },
              ),
              SettingsOption(
                title: 'Change Password',
                onTap: () {
                  // Navigate to the change password page or perform action
                },
              ),
              SettingsOption(
                title: 'Social',
                onTap: () {
                  // Navigate to the social settings page or perform action
                },
              ),
              SettingsOption(
                title: 'Language',
                onTap: () {
                  // Navigate to the language settings page or perform action
                },
              ),
              SettingsOption(
                title: 'Privacy and Security',
                onTap: () {
                  // Navigate to the privacy and security settings page or perform action
                },
              ),
              const SizedBox(height: 20),
              const SectionHeader(title: 'Notification'),
              SettingsOption(
                title: 'New Updates',
                onTap: () {
                  // Toggle new updates notifications or perform action
                },
              ),
              SettingsOption(
                title: 'Message Notifications',
                onTap: () {
                  // Toggle message notifications or perform action
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}


class SectionHeader extends StatelessWidget {
  final String title;

  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class SettingsOption extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const SettingsOption({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: onTap,
    );
  }
}
