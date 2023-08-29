import 'package:academy/userScreens/assigmentScreen/fetchAssigment.dart';
import 'package:flutter/material.dart';


class AssignmentScreen extends StatelessWidget {
  const AssignmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      appBar: AppBar(
        title: const Text("Assignment"),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20)
                )
              ),
              child: ListView.builder(
                  itemCount: assignment.length,
                  itemBuilder: (context, int index){
                return Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white70,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 6.0
                            )
                          ]
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              height: 30.0,
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),

                              ),
                              child: Center(
                                child: Text(
                                  assignment[index].subjectName,
                                  style: const TextStyle(fontSize: 13.0, fontWeight: FontWeight.w500, color: Colors.blue),
                                ),
                              ),
                            ),
                            const SizedBox(height: 30,),
                            Text(assignment[index].topicName, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                            const SizedBox(height: 30,),
                            AssignmentDetailRow(title: 'Assign Date',statusValue: assignment[index].assignDate),
                            AssignmentDetailRow(title: 'Last Date',statusValue: assignment[index].lastDate),
                            const SizedBox(height: 30,),
                            AssignmentDetailRow(title: 'Status',statusValue: assignment[index].status),
                            const SizedBox(height: 30,),
                            Container(
                              width: double.infinity,
                              height: 40,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Colors.blue, Colors.blueAccent],
                                  begin: FractionalOffset(0.0,0.0),
                                  end: FractionalOffset(0.5,0.5),
                                  stops: [0.0,1.0],
                                  tileMode: TileMode.clamp
                                ),
                                borderRadius: BorderRadius.circular(10)
                              ),
                              child: const Center(
                                child: Text('Submit', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                              ),
                            )

                          ],
                        ),
                      ),
                      const SizedBox(height: 30,),
                    ],
                  ),
                );
              }),
            ),
          )
        ],
      ),
    );
  }
}


class AssignmentDetailRow extends StatelessWidget {
  final String title;
  final String statusValue;
  const AssignmentDetailRow({super.key, required this.title, required this.statusValue});

  @override
  Widget build(BuildContext context) {
    return         Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.blue),),
        Text(statusValue, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.blue),)
      ],
    );
  }
}


