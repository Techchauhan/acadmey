import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class LiveClassCourse extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('live-courses').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator(); // Display a loading indicator.
        }
        var courses = snapshot.data?.docs; // Get the course documents.

        return ListView.builder(
          itemCount: courses?.length,
          itemBuilder: (context, index) {
            var course = courses![index].data();
            var thumbnailUrl = course['thumbnailUrl'];
            var CourseName = course['courseName'];
            var price = course['price'];
            var discountPrice = course['discountedPrice'];

            // Convert Firestore Timestamp to DateTime
            var startDate = (course['startDate'] as Timestamp).toDate();

            // The rest of your code remains the same...

            // Example: Format the startDate using intl package
            var formattedStartDate = DateFormat.yMMMMd('en_US').add_jm().format(startDate);


            return Container(
              width: double.infinity,
              margin: const EdgeInsets.all(9),
              child: Card(
                color: Colors.white,
                child: InkWell(
                  onTap: () {
                    // Handle tap
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        title: Text(
                          "$CourseName",
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                        ),
                        child:
                            Image.network(
                           '$thumbnailUrl',
                          width: double.infinity,
                          height: 100,
                          fit: BoxFit.cover,
                        )

                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.person),
                                Text("For preparation of "),
                                Text(
                                  'JEE/GATE',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const Icon(Icons.calendar_month),
                                Text(
                                  'Start on: ${DateFormat.yMMMMd('en_US').add_jm().format(startDate)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            const Row(
                              children: [
                                Icon(Icons.star),
                                Text("Explore for more"),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Divider(thickness: 3),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            children: [
                              const Text('Price: ₹'),
                              Text(
                                '$price',
                                style: const TextStyle(decoration: TextDecoration.lineThrough), // Strikethrough for original price.
                              ),
                              const SizedBox(width: 10), // Add spacing between original and discounted prices.
                              Text(
                                '₹$discountPrice',
                                style: const TextStyle(
                                  color: Colors.red, // Customize the color of the discounted price.
                                  fontWeight: FontWeight.bold, // Customize the font weight.
                                ),
                              ),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // Handle enrollment
                            },
                            child: const Text("Enroll Now"),
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
