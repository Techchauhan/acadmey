import 'package:academy/userScreens/authentication/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';


class ForgetPassword extends StatelessWidget {
    ForgetPassword({super.key});

    final _auth = FirebaseAuth.instance;

  TextEditingController emailController = TextEditingController();

    Future<void> resetPassword(String email) async {
      try {
        await _auth.sendPasswordResetEmail(email: email);
        Fluttertoast.showToast(msg: 'password reset email sent to $email');
        print("Password reset email sent to $email");
      } catch (error) {
        Fluttertoast.showToast(msg: 'Error sending password reset email: $error');
        print("Error sending password reset email: $error");
      }
    }

  @override
  Widget build(BuildContext context) {
    return   WillPopScope(
      onWillPop: ()async{
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            leading: BackButton(
              onPressed: (){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
              },
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text("Fogot Passowrd?", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),),
                ),
                Center(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        LottieBuilder.network('https://lottie.host/1a2e6220-9adf-4afd-b3e0-96ba3c96fbad/DlCuSq4Ktu.json'),
                        TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                            hintText: "Enter your Email!"
                          ),
                        ),
                        SizedBox(height: 20,),
                        ElevatedButton(onPressed: (){
                          resetPassword(emailController.text);
                        }, child: Text("Send Email"))
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
