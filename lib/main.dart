import 'package:flutter/material.dart';

void main() {
  runApp(StudyApp());
}

class StudyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Study App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Left Sidebar
          Container(
            width: MediaQuery.of(context).size.width/10,
            child: Container(
              decoration: BoxDecoration(borderRadius:BorderRadius.only(topRight: Radius.circular(30), bottomRight: Radius.circular(30)), color: Colors.blue[100],),
              
              child: Column(
                children: [
                  SizedBox(height: 50),
                  Text(
                    'Studious',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Container(width: MediaQuery.of(context).size.width/20, decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(100)), child: IconButton(onPressed: () {}, icon: Icon(Icons.home)))
                ],
              ),
            ),
          ),
          // Main Content
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'All Classes Events Today (48)',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        CircleAvatar(
                          backgroundImage: NetworkImage('https://via.placeholder.com/150'),
                        ),
                      ],
                    ),
                  ),
                  // Body
                  Expanded(
                    child: Row(
                      children: [
                        // Left Column
                        Expanded(
                          flex: 1,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            padding: EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '13',
                                  style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 8),
                                Text('Industrial Design UX'),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Text('75%'),
                                    SizedBox(width: 8),
                                    Stack(
                                      children: [
                                        Container(
                                          width: 100,
                                          height: 10,
                                          color: Colors.grey[300],
                                        ),
                                        Container(
                                          width: 75,
                                          height: 10,
                                          color: Colors.green,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        // Right Column
                        Expanded(
                          flex: 1,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            padding: EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Time Average 4h 32min',
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 16),
                                Container(
                                  height: 100,
                                  color: Colors.grey[200],
                                  child: Center(child: Text('Graph Placeholder')),
                                ),
                                SizedBox(height: 16),
                                Text('Weekly Productivity: +13%'),
                                SizedBox(height: 8),
                                Text('Basics of UX Design: In Progress'),
                                SizedBox(height: 8),
                                Stack(
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      height: 10,
                                      color: Colors.grey[300],
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width * 0.25,
                                      height: 10,
                                      color: Colors.green,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
