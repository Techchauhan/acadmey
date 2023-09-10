import 'package:academy/course/exploreCourse/courseDataController.dart';
import 'package:academy/course/learnig/studentCourseScreen.dart';
import 'package:academy/course/showallVideoCourse.dart';
import 'package:academy/userScreens/navigator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:academy/main.dart';

class CourseExplorationPage extends StatefulWidget {
  final String courseId;

  CourseExplorationPage({required this.courseId});

  @override
  _CourseExplorationPageState createState() => _CourseExplorationPageState();
}

class _CourseExplorationPageState extends State<CourseExplorationPage> {

  Razorpay _razorpay = Razorpay();
  bool _isCoursePurchased = false;
  bool _isUserPurchased = false;

  @override
  void initState() {
    super.initState();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    _fetchCourseData();
    _checkUserPurchase();
  }

  void _checkUserPurchase() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    String courseId = widget.courseId;

    DatabaseEvent snapshot = await _databaseReference.child('users').child(userId).child('purchased_courses').once();

    if (snapshot.snapshot.value != null) {
      Map<dynamic, dynamic> purchasedCourses = snapshot.snapshot.value as Map;
      _isUserPurchased = purchasedCourses.values.contains(courseId);
    }

    setState(() {});
  }




  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Handle successful payment
    setState(() {
      _isCoursePurchased = true;
    });
    String userId = FirebaseAuth.instance.currentUser!.uid; // Replace with the actual user ID
    String courseId = widget.courseId;

    // Update the user's database record with the purchased course
    _databaseReference.child('users').child(userId).child('purchased_courses').push().set(courseId);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => StudentCourseScreen(courseId: widget.courseId)),
    );
    print('Payment success: Payment ID - ${response.paymentId}');
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Handle payment failure
    print('Payment error: Code - ${response.code}, Message - ${response.message}');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Handle external wallet payment
    print('External wallet: Wallet name - ${response.walletName}');
  }

  void _openCheckout() async {
    var options = {
      'key': 'rzp_test_VY38lT9nyjeVqe',
      'amount': 1000, // Amount in paise (Indian currency)
      'name': courseData['title'],
      'description': 'Buy this course',
      'prefill': {'contact': '6396219233', 'email': FirebaseAuth.instance.currentUser!.email.toString()},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print('Error during payment: $e');
    }
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }


  final DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();
  Map<String, dynamic> courseData = {}; // Initialize an empty map



  Future<void> _fetchCourseData() async {
    try {
      final snapshot = await _databaseReference.child('courses').child(widget.courseId).get();

      if (snapshot.exists) {
        setState(() {
          courseData = Map<String, dynamic>.from(snapshot.value as Map);
        });
      } else {
        print('No data available.');
      }
    } catch (error) {
      print('Error fetching course data: $error');
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Handle the back button press here
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> NavigatorPage(FirebaseAuth.instance.currentUser!.uid) )); // This pops the current page
        return false; // Return false to prevent app from closing
      },
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => NavigatorPage(FirebaseAuth.instance.currentUser!.uid)),
              );
            },
          ),
          title:   Text(courseData.containsKey('title') ? courseData['title'] : '',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Course Thumbnail
              Container(
                width: double.infinity,
                height: 200, // Adjust the height as needed
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(courseData.containsKey('thumbnail')
                        ? courseData['thumbnail']
                        : ''),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Scaffold(
              //   appBar: AppBar(
              //     bottom:  PreferredSize(
              //       preferredSize: Size.fromHeight(48.0),
              //       child: TabBar(
              //         tabs: [
              //           Tab(text: 'Description'),
              //           Tab(text: 'Lectures'),
              //           Tab(text: 'About'),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),

              const SizedBox(height: 16),



              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Description", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500,),),
              ),
              // Course Description
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(courseData.containsKey('description') ? courseData['description'] : ''),
              ),


              const SizedBox(height: 16), // Add some spacing

              // Chapters and Lectures
              StreamBuilder(
                stream: _databaseReference
                    .child('courses')
                    .child(widget.courseId)
                    .child('chapters')
                    .onValue,
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    final chaptersData = snapshot.data?.snapshot.value;

                    if (chaptersData is Map) {
                      return ListView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: chaptersData.entries.map((entry) {
                          final chapterId = entry.key;
                          final chapterInfo = entry.value as Map<dynamic, dynamic>;

                          return ExpansionTile(
                            title: Text(chapterInfo['title']),
                            children: chapterInfo['lectures'] != null
                                ? (chapterInfo['lectures'] as Map<dynamic, dynamic>)
                                .entries
                                .map((lectureEntry) {
                              final lectureId = lectureEntry.key;
                              final lectureInfo =
                              lectureEntry.value as Map<dynamic, dynamic>;

                              return ListTile(
                                title: Text(lectureInfo['title']),
                              );
                            }).toList()
                                : [], // Handle if lectures are null
                          );
                        }).toList(),
                      );
                    } else {
                      return const Center(
                        child: Text('No chapters available.'),
                      );
                    }
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),

            ],
          ),

        ),
        floatingActionButton: Container(

          width: double.infinity,
          color: Colors.white,
          // padding: EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("₹ ${courseData['price']}", style: const TextStyle(color: Colors.black, fontSize: 20),),
              ElevatedButton(

                onPressed: _isUserPurchased ? ( ){Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>StudentCourseScreen(courseId: widget.courseId)));} : _openCheckout,
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue, // Background color
                  onPrimary: Colors.white, // Text color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // Rounded corners
                  ),
                ),
                child:   Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    _isUserPurchased ? 'View Course' : 'Buy Course',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
