import 'package:academy/service/Authservice.dart';
import 'package:flutter/material.dart';
// import 'auth_service.dart';

class AuthCheckScreen extends StatefulWidget {
  @override
  _AuthCheckScreenState createState() => _AuthCheckScreenState();
}

class _AuthCheckScreenState extends State<AuthCheckScreen> {
  final AuthService _auth = AuthService();

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    final bool isLoggedIn = await _auth.isUserLoggedIn();
    if (isLoggedIn) {
      // Navigate to the HomeScreen
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      // Navigate to the LoginScreen
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
