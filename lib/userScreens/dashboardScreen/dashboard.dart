import 'package:academy/userScreens/dashboardScreen/homepage.dart';
import 'package:academy/userScreens/navigator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) =>
                    NavigatorPage(FirebaseAuth.instance.currentUser!.uid,
                        initialIndex: 0)));
          }
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildCard(color: Colors.blueAccent, text: 'Live Course', subtitle: '1'),
              _buildCard(color: Colors.blueAccent, text: 'Video Course', subtitle: '4')
            ],
          )],
        ),
      ),
    );
  }
  Widget _buildCard({required Color color, required String text, required String subtitle}) {
    return Card(
      elevation: 5, // Add shadow to the card
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15), // Rounded corners for the card
      ),
      color: color,
      child: Container(
        width: 200,
        height: 150,
        padding: EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                text,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10,),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



