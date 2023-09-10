import 'package:academy/userScreens/Downloads/pdfDownloads.dart';
import 'package:academy/userScreens/Downloads/videoDownloads.dart';
import 'package:academy/userScreens/navigator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';



class Downloder extends StatelessWidget {
  const Downloder({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>NavigatorPage(FirebaseAuth.instance.currentUser!.uid, initialIndex: 0,)));

        return false;
      },
      child: Scaffold(
        body: DefaultTabController(
          length: 2, // Number of tabs (PDF and Video)
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(80.0),
              child: AppBar(
                leading: BackButton(
                  onPressed: (){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>NavigatorPage(FirebaseAuth.instance.currentUser!.uid, initialIndex: 0,)));
                  },
                ),
                bottom: TabBar(
                  tabs: [
                    Tab(text: 'PDF Downloader'),
                    SizedBox(child: Tab(text: 'Video Downloader')),

                  ],
                ),
              ),
            ),
            body: TabBarView(
              children: [
                PdfDownloadSection(),
                VideoDownloadSection()

              ],
            ),
          ),
        ),
      ),
    );
  }
}




