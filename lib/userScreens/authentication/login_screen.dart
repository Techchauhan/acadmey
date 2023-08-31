import 'package:academy/userScreens/authentication/forgetPassword.dart';
import 'package:academy/userScreens/navigator.dart';
import 'package:academy/userScreens/authentication/regisrtration_screen.dart';
import 'package:academy/widgets/cutomProgressIndicator2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //firebase
  final _auth = FirebaseAuth.instance;
  final user1 = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  final GoogleSignIn googleSignIn = GoogleSignIn();
  User? user;

  //form key
  final _formkey = GlobalKey<FormState>();

  //editing Controller
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  Future<void> _handleSignIn() async {
    try {
      // Show the Circular Progress Indicator while signing in
      showDialog(
        context: context,
        barrierDismissible: false, // Prevent users from dismissing the dialog
        builder: (context) => Center(
          child: MyProgressIndicator2(),
        ),
      );

      GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
        AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        UserCredential result = await _auth.signInWithCredential(credential);
        User? user = result.user;
        if (user != null) {
          // Create a reference to the 'users' collection in Firestore
          CollectionReference usersCollection = _firestore.collection('users');

          // Set additional values along with the Google user's ID
          await usersCollection.doc(user.uid).set({
            'uid': user.uid,
            'displayName': user.displayName,
            'email': user.email,
            'firstName': '',
            'secondName': '',
            'academicYear': '',
            'admissionClass': '',
            'admissionNumber': '',
            'dataOfAdmission': '',
            'dob': '',
            'fatherName': '',
            'motherName': '',
            'number': '',
            'registrationNumber': '',
            // Add more fields as needed
          });

          // Close the progress indicator dialog
          Navigator.pop(context);

          await Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => NavigatorPage(user.uid)),
                (route) => false,
          );
        }
      }
    } catch (error) {
      print(error);
      // Close the progress indicator dialog on error
      Navigator.pop(context);
    }
  }



  @override
  Widget build(BuildContext context) {
    //Email Field
    final emailField = TextFormField(
      autofocus: false,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      onSaved: (value) {
        emailController.text = value!;
      },
      validator: (value) {
        if (value!.isEmpty) {
          return ("Please Enter you Email");
        }
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
          return ("Please Enter a Valid Email");
        }
        return null;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.mail),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Email",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );

    //password field
    final passwordField = TextFormField(
      autofocus: false,
      controller: passController,
      onSaved: (value) {
        passController.text = value!;
      },
      validator: (value) {
        RegExp regExp = RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return ("Password is Required for login");
        }
        if (!regExp.hasMatch(value)) {
          return ("Enter Valid Password (Min. 6 Character is Required)");
        }
      },
      obscureText: true,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.shield),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Password",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );



    //LoginButton
    final loginButton = Material(
      child: ElevatedButton(
        child: const Text("Login in"),
        onPressed: () {
          signIn(emailController.text, passController.text);
        },
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          color: Colors.white,
          child: Form(
            key: _formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //Space for adding an Image;

                SizedBox(
                  height: 200,
                  // child: Text("Space for an Image"),
                  child: LottieBuilder.network(
                      "https://lottie.host/0c641077-74bc-4a76-b0b8-8cd29578b178/Kqf5MY4QX9.json"),
                  // child: Image.asset("assets/login-sinup.json"),
                ),
                const SizedBox(
                  height: 40,
                ),
                emailField,
                const SizedBox(
                  height: 40,
                ),
                passwordField,

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(onPressed: (){
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ForgetPassword()));
                      // resetPassword(FirebaseAuth.instance.currentUser.);
                    }, child: Text("Forget Password?"))
                  ],
                ),
                loginButton,
                const SizedBox(
                  height: 10,
                ),

                const Align(
                  alignment: Alignment.center,
                  child: Text("or"),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    _handleSignIn();

                    // Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen(documentId: user!.uid,)));
                  },
                  icon: const FaIcon(
                    FontAwesomeIcons.google,
                    color: Colors.blue,
                  ),
                  label: const Text("Sign Up with Google"),
                  style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      onPrimary: Colors.black,
                      minimumSize: const Size(double.infinity, 50)),
                ),

                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account?",
                      style: TextStyle(color: Colors.red),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const RegistrationScreen()));
                      },
                      child: const Text(
                        "Sing up",
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 15),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 140,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //login function

  void signIn(String email, String password) async {
    if (_formkey.currentState!.validate()) {
      showDialog(
        context: context,
        barrierDismissible: false, // Prevent users from dismissing the dialog
        builder: (context) => Center(
          child: MyProgressIndicator2(),
        ),
      );

      try {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        if (userCredential.user != null) {
          Navigator.pop(context); // Hide the progress indicator

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => NavigatorPage(userCredential.user!.uid),
            ),
                (route) => false,
          );
        }
      } catch (e) {
        Navigator.pop(context); // Hide the progress indicator

        Fluttertoast.showToast(msg: e.toString());
      }
    }
  }


//Function for Reset Password




}
