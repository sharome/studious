import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sidebarx/sidebarx.dart';

void main() {
  runApp(StudyApp());
}

class StudyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'studious',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  final months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Row(
        children: [
          CustomSidebar(),
          // Left Sidebar

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
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        CircleAvatar(
                          backgroundImage:
                              NetworkImage('https://via.placeholder.com/150'),
                        ),
                      ],
                    ),
                  ),
                  // Body
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            // Left Column
                            Container(
                                width: MediaQuery.of(context).size.width / 8,
                                height: MediaQuery.of(context).size.height / 5,
                                decoration: BoxDecoration(color: Colors.purple, borderRadius: BorderRadius.circular(10)),
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(width: 10,),
                                        Text(
                                          DateTime.now().day.toString(),
                                          style: GoogleFonts.k2d(fontSize: 70, color: Colors.black),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    Container(
                                      height: 50,
                                      width: 150,
                                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(100)), child: Center(child: Text(months[DateTime.now().month.toInt()] + ' ' + DateTime.now().year.toString(), style: GoogleFonts.sora(fontSize: 20),))),
                                    SizedBox(height: 8),
                                    
                                  ],
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
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 16),
                                    Container(
                                      height: 100,
                                      color: Colors.grey[200],
                                      child:
                                          Center(child: Text('Graph Placeholder')),
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
                                          width: MediaQuery.of(context).size.width *
                                              0.25,
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

class CustomSidebar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    bool isSmall = false;
    if (width * 0.1 < 200) {
      isSmall = true;
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: isSmall
            ? 200
            : width * 0.1, // Sidebar takes 10% of the screen width
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                      height: 50,
                      width: 50,
                      child: Image(image: AssetImage('assets/logo/logo.png'))),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    'studious',
                    style: GoogleFonts.sora(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
            ),
            SizedBox(height: 50), // Top padding
            SidebarItem(
              icon: Icons.home,
              text: 'Home',
              onTap: () {
                // Handle Home tap
              },
            ),
            SidebarItem(
              icon: Icons.book,
              text: 'Study',
              onTap: () {
                // Handle Study tap
              },
            ),
            SidebarItem(
              icon: Icons.bar_chart,
              text: 'Statistics',
              onTap: () {
                // Handle Statistics tap
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SidebarItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const SidebarItem({
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: 20),
            Icon(icon, color: Colors.white),
            SizedBox(width: 20),
            Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
