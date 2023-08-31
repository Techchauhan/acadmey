import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';  // Import the lottie package

class MyProgressIndicator1 extends StatelessWidget {
  const MyProgressIndicator1({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset('assets/loading2.json'),  // Replace with the actual path to your JSON file
    );
  }
}