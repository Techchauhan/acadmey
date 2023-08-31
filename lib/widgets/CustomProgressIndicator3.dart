import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';  // Import the lottie package

class MyProgressIndicator3 extends StatelessWidget {
  const MyProgressIndicator3({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(height: 100,
          child: Lottie.asset('assets/loading3.json')),  // Replace with the actual path to your JSON file
    );
  }
}