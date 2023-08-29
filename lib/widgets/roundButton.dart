import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  final String title;
  bool loading;
  final VoidCallback onTap;
  RoundButton(
      {super.key,
      required this.title,
      required this.onTap,
      this.loading = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
            color: Colors.deepPurpleAccent,
            borderRadius: BorderRadius.circular(10)),
        child: Center(
          child: Center(
              child: loading
                  ? const CircularProgressIndicator()
                  : Text(
                      title,
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    )),
        ),
      ),
    );
  }
}
