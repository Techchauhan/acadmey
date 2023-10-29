import 'package:academy/course/exploreCourse/courseDataController.dart';
import 'package:academy/course/learnig/studentCourseScreen.dart';
import 'package:academy/course/showallVideoCourse.dart';
import 'package:academy/userScreens/navigator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
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

    DocumentSnapshot userSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (userSnapshot.exists) {
      List<dynamic> purchasedCourses = userSnapshot['purchased_courses'];

      if (purchasedCourses != null) {
        _isUserPurchased = purchasedCourses.contains(courseId);
      }
    }

    setState(() {});
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Handle successful payment
    setState(() {
      _isCoursePurchased = true;
    });

    String userId = FirebaseAuth.instance.currentUser!.uid;
    String courseId = widget.courseId;

    // Get the course data for the course name
    String courseName = courseData['title']; // You can customize this to get the course name as needed.

    CollectionReference usersCollection =
    FirebaseFirestore.instance.collection('users');

    // Add the course ID to the user's purchased_courses
    usersCollection.doc(userId).update({
      'purchased_courses': FieldValue.arrayUnion([courseId]),
    });

    // Create a new document in the purchased_course subcollection
    usersCollection.doc(userId).collection('purchased_course').doc(courseName).set({
      'course_id': courseId,
      'course_name': courseName,
    });

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ViewChaptersPage(courseId: widget.courseId)),
    );

    print('Payment success: Payment ID - ${response.paymentId}');
  }


  void _handlePaymentError(PaymentFailureResponse response) {
    // Handle payment failure
    print(
        'Payment error: Code - ${response.code}, Message - ${response.message}');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Handle external wallet payment
    print('External wallet: Wallet name - ${response.walletName}');
  }

  void _openCheckout() async {
    var options = {
      'key': 'rzp_test_dVPsviFAnVwnDM',
      'amount': 1000, // Amount in paise (Indian currency)
      'name': courseData['title'],
      'description': 'Buy this course',
      'prefill': {
        'contact': '6396219233',
        'email': FirebaseAuth.instance.currentUser!.email.toString()
      },
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

  Map<String, dynamic> courseData = {};

  Future<void> _fetchCourseData() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('courses')
          .doc(widget.courseId)
          .get();

      if (snapshot.exists) {
        setState(() {
          courseData = snapshot.data() as Map<String, dynamic>;
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
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => NavigatorPage(
                      FirebaseAuth.instance.currentUser!.uid,
                      initialIndex: 0)),
            );
          },
        ),
        title: Text(
          courseData.containsKey('title') ? courseData['title'] : '',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(courseData.containsKey('thumbnail')
                      ? courseData['thumbnail']
                      : ''),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Description",
                  style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(courseData.containsKey('description')
                  ? courseData['description']
                  : ''),
            ),
            const SizedBox(height: 16),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('courses')
                  .doc(widget.courseId)
                  .collection('chapters')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final chaptersData = snapshot.data!.docs;

                  if (chaptersData.isNotEmpty) {
                    return ListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: chaptersData.map((chapterDoc) {
                        final chapterInfo = chapterDoc.data() as Map<String, dynamic>;

                        return ExpansionTile(
                          title: Text(chapterInfo['title']),
                          children: [
                            if (chapterInfo['lectures'] != null)
                              ...chapterInfo['lectures'].map((lectureInfo) {
                                return ListTile(
                                  title: Text(lectureInfo['title']),
                                );
                              }).toList(),
                          ],
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text("₹ ${courseData['price']}",
                style: const TextStyle(color: Colors.black, fontSize: 20)),
            ElevatedButton(
              onPressed: _isUserPurchased
                  ? () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ViewChaptersPage(
                                  courseId: widget.courseId)));
                    }
                  : _openCheckout,
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                onPrimary: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Padding(
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
    );
  }
}
