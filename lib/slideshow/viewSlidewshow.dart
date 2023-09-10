import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SlideshowImage {
  final String imageUrl;

  SlideshowImage(this.imageUrl);
}

class ViewSlideShow extends StatefulWidget {
  ViewSlideShow({Key? key}) : super(key: key);

  @override
  _ViewSlideShowState createState() => _ViewSlideShowState();
}

class _ViewSlideShowState extends State<ViewSlideShow> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<SlideshowImage> slideshowImages = [];

  // Add a method to fetch cached data from SharedPreferences
  Future<List<SlideshowImage>> getCachedData() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getStringList('slideshowImages');

    if (cachedData != null) {
      return cachedData.map((imageUrl) => SlideshowImage(imageUrl)).toList();
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<SlideshowImage>>(
      future: getCachedData(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        slideshowImages = snapshot.data!;

        return StreamBuilder(
          stream: firestore.collection('slideshow').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            var slideshowDocs = snapshot.data!.docs;

            slideshowImages = slideshowDocs
                .map((doc) => SlideshowImage(doc['image_url']))
                .toList();

            // Cache the fetched data
            cacheData(slideshowImages);

            return Container(
              height: 200,
              width: 400,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: slideshowImages.length,
                itemBuilder: (context, index) {
                  return Container(
                    width: 300,
                    height: 100,
                    margin: const EdgeInsets.all(8),
                    child: Image.network(
                      slideshowImages[index].imageUrl,
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  // Add a method to cache data in SharedPreferences
  void cacheData(List<SlideshowImage> data) async {
    final prefs = await SharedPreferences.getInstance();
    final imageUrlList = data.map((image) => image.imageUrl).toList();
    prefs.setStringList('slideshowImages', imageUrlList);
  }
}



