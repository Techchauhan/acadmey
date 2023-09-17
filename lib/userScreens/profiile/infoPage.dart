import 'package:academy/Basic%20Pages/settingPage.dart';
import 'package:academy/widgets/CustomProgressIndicator3.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Info extends StatefulWidget {
  const Info({super.key});

  @override
  State<Info> createState() => _InfoState();
}

class _InfoState extends State<Info> {
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
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const SettingPage() )); // This pops the current page
        return false; // Return false to prevent app from closing
      },
      child: FutureBuilder<User?>(
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
              if (userDataSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: MyProgressIndicator3(),
                );
              }

              if (!userDataSnapshot.hasData || userDataSnapshot.data == null) {
                return const Center(child: Text('No user data found.'));
              }

              final userData = userDataSnapshot.data!.data()!;

              return Scaffold(
                body: Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      Expanded(child: SingleChildScrollView(
                        child: Column(
                          children: [

                            const SizedBox(height: 10,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ProfileRowDetail(title: 'Registration No.', value: '${userData['registrationNumber']}',),
                                ProfileRowDetail(title: 'Academic Year', value: '${userData['academicYear']}',),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ProfileRowDetail(title: 'Admission Class', value: '${userData['admissionClass']}',),
                                ProfileRowDetail(title: 'Academic Year', value: '${userData['admissionNumber']}',),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ProfileRowDetail(title: 'Date of Birth', value: '${userData['dob']}',),
                                ProfileRowDetail(title: 'Date of Admission', value: '${userData['dataOfAdmission']}',),
                              ],
                            ),
                            ProfileColoumDetail(title: 'Email', value: '${userData['email']}'),
                            ProfileColoumDetail(title: 'Father Name', value: '${userData['fatherName']}'),
                            ProfileColoumDetail(title: 'Mother Name', value: '${userData['motherName']}'),
                            ProfileColoumDetail(title: 'Phone Number', value: '+91 ${userData['number']}'),
                          ],
                        ),
                      ))
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}



class ProfileRowDetail extends StatelessWidget {
  const ProfileRowDetail({super.key, required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return  Container(
      padding: const EdgeInsets.only(right: 1,left: 10, top: 15, bottom: 25),
      width: MediaQuery.of(context).size.width/2,
      color: Colors.white70,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),),
              const SizedBox(height: 10,),
              InkWell(
                onTap: (){
                  Fluttertoast.showToast(msg: "Contact to your Teacher to Update");
                },
                child:Text(value, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),) ,
              ),


              SizedBox(
                width: MediaQuery.of(context).size.width/3,
                child: const Divider(
                  thickness: 1.0,
                ),
              )
            ],
          ),
          IconButton(onPressed: (){
            Fluttertoast.showToast(msg: "Call to your Teacher to Update");
          }, icon: const Icon(Icons.lock_outline), )
        ],
      ),
    );
  }
}

class ProfileColoumDetail extends StatelessWidget {
  final String title;
  final String value;
  const ProfileColoumDetail({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.grey, fontSize: 16),),
              const SizedBox(height: 10,),
              Text(value, style: const TextStyle(color: Colors.black, fontSize: 15),),
              SizedBox(
                width: MediaQuery.of(context).size.width/1.4,
                child: const Divider(
                  thickness: 1.0,
                ),
              )
            ],
          ),
          IconButton(onPressed: (){
            Fluttertoast.showToast(msg: "Contact to your Teacher to Update");
          }, icon:  const Icon(Icons.lock),)
        ],
      ),
    );
  }
}



// class MessageBox extends StatelessWidget {
//   final VoidCallback onClose;
//
//   MessageBox({required this.onClose});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: MediaQuery.of(context).size.width * 0.8,
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.grey[200],
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'Send a Message',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 10),
//           const TextField(
//             decoration: InputDecoration(
//               hintText: 'Type your message...',
//             ),
//           ),
//           const SizedBox(height: 10),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               TextButton(
//                 onPressed: onClose, // Close the message box
//                 child: const Text('Close'),
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   // Implement sending the message logic here
//                 },
//                 child: const Text('Send'),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
