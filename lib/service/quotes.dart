import 'package:flutter/material.dart';


class DailyQuoteContainer extends StatelessWidget {
  final String quote;

  DailyQuoteContainer({required this.quote});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, // Use white for a whiteboard appearance
        border: Border.all(color: Colors.black, width: 2), // Border for blackboard appearance
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        quote,
        style: TextStyle(
          fontSize: 18,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
