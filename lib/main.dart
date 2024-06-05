import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gauge_indicator/gauge_indicator.dart';

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
  final months = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color.fromRGBO(14, 15, 16, 100),
            ),
          ),
          Row(
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
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            CircleAvatar(
                              backgroundImage: NetworkImage(
                                  'https://via.placeholder.com/150'),
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
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Color.fromARGB(29, 84, 84, 101)),
                                  width: MediaQuery.of(context).size.width / 8,
                                  height:
                                      MediaQuery.of(context).size.height / 5,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              DateTime.now().day.toString(),
                                              style: GoogleFonts.k2d(
                                                  fontSize: 70,
                                                  color: const Color.fromARGB(
                                                      76, 255, 255, 255)),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 8),
                                        Container(
                                            height: 50,
                                            width: 150,
                                            decoration: BoxDecoration(
                                                color: Colors.transparent,
                                                borderRadius:
                                                    BorderRadius.circular(100)),
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  width: 15,
                                                ),
                                                Text(
                                                  months[DateTime.now()
                                                          .month
                                                          .toInt()] +
                                                      ' ' +
                                                      DateTime.now()
                                                          .year
                                                          .toString(),
                                                  style: GoogleFonts.sora(
                                                      fontSize: 20,
                                                      color: Colors.white),
                                                ),
                                              ],
                                            )),
                                        SizedBox(height: 8),
                                      ],
                                    ),
                                  ),
                                ),

                                SizedBox(width: 16),
                                // Right Column
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height / 5,
                                  width:
                                      MediaQuery.of(context).size.width / 1.4,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(29, 84, 84, 101),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: EdgeInsets.all(16),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Container(
                                          child: AnimatedRadialGauge(
                                            duration: Duration(seconds: 1),
                                            value: 80,
                                            radius: 150,
                                            curve: Curves.elasticOut,
                                            axis: GaugeAxis(
                                              pointer: GaugePointer.circle(
                                                  radius: 13,
                                                  gradient: LinearGradient(
                                                      colors: [
                                                        Colors.deepPurple,
                                                        Colors.purple
                                                      ],
                                                      begin: Alignment.topLeft,
                                                      end: Alignment
                                                          .bottomRight)),
                                              min: 0,
                                              max: 100,
                                              progressBar:
                                                  GaugeProgressBar.rounded(
                                                color: Colors.deepPurple,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 50,
                                        ),
                                        Container(
                                          child: AnimatedRadialGauge(
                                            duration: Duration(seconds: 1),
                                            value: 80,
                                            radius: 150,
                                            curve: Curves.elasticOut,
                                            axis: GaugeAxis(
                                              pointer: GaugePointer.circle(
                                                  radius: 13,
                                                  gradient: LinearGradient(
                                                      colors: [
                                                        Colors.deepPurple,
                                                        Colors.purple
                                                      ],
                                                      begin: Alignment.topLeft,
                                                      end: Alignment
                                                          .bottomRight)),
                                              min: 0,
                                              max: 100,
                                              progressBar:
                                                  GaugeProgressBar.rounded(
                                                color: Colors.deepPurple,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Container(
                                          child: AnimatedRadialGauge(
                                            duration: Duration(seconds: 1),
                                            value: 80,
                                            radius: 150,
                                            curve: Curves.elasticOut,
                                            axis: GaugeAxis(
                                              pointer: GaugePointer.circle(
                                                  radius: 13,
                                                  gradient: LinearGradient(
                                                      colors: [
                                                        Colors.deepPurple,
                                                        Colors.purple
                                                      ],
                                                      begin: Alignment.topLeft,
                                                      end: Alignment
                                                          .bottomRight)),
                                              min: 0,
                                              max: 100,
                                              progressBar:
                                                  GaugeProgressBar.rounded(
                                                color: Colors.deepPurple,
                                              ),
                                            ),
                                          ),
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
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  SizedBox(width: 10),
                  Container(
                      height: 50,
                      width: 50,
                      child: Image(image: AssetImage('assets/logo/logo.png'))),
                  SizedBox(width: 20),
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
