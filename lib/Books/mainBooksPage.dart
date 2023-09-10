 import 'package:academy/Books/pdf/pdfView.dart';
import 'package:academy/userScreens/navigator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';



class MainBooksPage extends StatefulWidget {


  @override
  State<MainBooksPage> createState() => _MainBooksPageState();
}

class _MainBooksPageState extends State<MainBooksPage> {

  void viewPdf(String pdfUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PdfViewerPage(pdfUrl)),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: (){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> NavigatorPage(FirebaseAuth.instance.currentUser!.uid, initialIndex: 0,)));
          },
        ),
        title: const Text('Open Book Store'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search the book',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Categories',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              height: 80,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  CategoryAvatar('Hindi'),
                  CategoryAvatar('English'),
                  CategoryAvatar('Maths'),
                  CategoryAvatar('History'),
                  CategoryAvatar('Civis'),
                  CategoryAvatar('Geogr.'),
                  CategoryAvatar('Physics'),
                  CategoryAvatar('Chemis.'),
                  CategoryAvatar('Biology'),
                  CategoryAvatar('C.S.E'),
                  CategoryAvatar('G.K'),
                  // Add more categories here
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Suggestions',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              height: 150,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  BookCard('https://timesofuniversity.com/wp-content/uploads/2023/09/Hnad-Book-Mathematics.jpg', 'Book Title 1', (){
                    viewPdf('https://timesofuniversity.com/wp-content/uploads/2023/09/hemh113.pdf');
                  }),
                  BookCard('https://timesofuniversity.com/wp-content/uploads/2023/09/metal-Maths.jpg', 'Book Title 2', (){
                    viewPdf('https://ncert.nic.in/textbook/pdf/hemh113.pdf');
                  }),
                  BookCard('https://timesofuniversity.com/wp-content/uploads/2023/09/physics-JEE-Books.jpg', 'Book Title 3',(){}),
                  // Add more book suggestions here
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Continue Reading',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              height: 150,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  BookCard('https://timesofuniversity.com/wp-content/uploads/2023/09/ART-Architecure.jpg', 'Book Title 4',(){}),
                  BookCard('https://timesofuniversity.com/wp-content/uploads/2023/09/Rich-Dad-Poor-Dad.jpg', 'Book Title 5',(){}),
                  BookCard('https://timesofuniversity.com/wp-content/uploads/2023/09/metal-Maths.jpg', 'Book Title 6',(){}),
                  // Add more books for continued reading here
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryAvatar extends StatelessWidget {
  final String category;

  CategoryAvatar(this.category);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      child: CircleAvatar(
        radius: 30,
        backgroundColor: Colors.blue,
        child: Text(
          category,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class BookCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final VoidCallback onPress;

  BookCard(this.imageUrl, this.title, this.onPress);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      child: InkWell(
        onTap: onPress,
        child: Card(
          elevation: 2.0,
          child: Column(
            children: <Widget>[
              Image.network(
                imageUrl,
                height: 100,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
