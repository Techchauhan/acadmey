import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';  // Import the lottie package

class MyProgressIndicator2 extends StatelessWidget {
  const MyProgressIndicator2({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset('assets/loading.json'),  // Replace with the actual path to your JSON file
    );
  }
}