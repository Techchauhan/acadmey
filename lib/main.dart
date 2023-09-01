import 'package:academy/userScreens/navigator.dart';
import 'package:academy/userScreens/authentication/login_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_sign_in/google_sign_in.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  //Creating a firebase Messaging instance.
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // Request permission for notifications
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  User? user;

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser;

    // Initialize FlutterLocalNotificationsPlugin
    var initializationSettingsAndroid = AndroidInitializationSettings('app_icon'); // Replace 'app_icon' with your app's icon name
    // var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      // iOS: initializationSettingsIOS,
    );
    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Check for an existing FCM token
    checkForExistingToken();

    // Handle incoming FCM messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Handle the incoming message when the app is in the foreground
      print("onMessage: $message");
      _displayNotification(message);
    });
  }

  Future<void> checkForExistingToken() async {
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
    String? fcmToken = await _firebaseMessaging.getToken();

    if (fcmToken != null) {
      // Handle the case where the FCM token already exists
      // You can display a message or perform any other actions
      print('FCM Token exists: $fcmToken');
    }
  }

  Future<void> _displayNotification(RemoteMessage message) async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      // 'channel_description',
      importance: Importance.max,
      priority: Priority.high,
    );
    // var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics,
        // iOS: iOSPlatformChannelSpecifics
    );

    await flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      'New Message', // Notification title
      message.notification?.body ?? '', // Notification content
      platformChannelSpecifics,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home: Scaffold(
        body: Center(
          child: user != null
              ? NavigatorPage(
            user!.uid,
          )
              : const LoginScreen(),
        ),
      ),
    );
  }
}