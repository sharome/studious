import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
// import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gauge_indicator/gauge_indicator.dart';
import 'package:go_router/go_router.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:get/get.dart';
import 'dart:async';

void main() {
  Get.put(ClassesController());
  Get.put(TaskController());
  runApp(StudyApp());
}

class StudyApp extends StatelessWidget {
  final GlobalKey<_ClassGridViewState> classGridViewKey =
      GlobalKey<_ClassGridViewState>();

  final GoRouter _router = GoRouter(
    initialLocation: '/',
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return MainShell(child: child);
        },
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => ClassesPage(),
          ),
          GoRoute(
            path: '/study',
            builder: (context, state) => StudyPage(),
          ),
          GoRoute(
            path: '/statistics',
            builder: (context, state) => StatisticsPage(),
          ),
          GoRoute(
            path: '/add_class',
            builder: (context, state) => AddClassPage(),
          ),
        ],
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      title: 'studious',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}

class ClassesController extends GetxController {
  // List<StudyClass> _classes = [];
  var _classes = <StudyClass>[
    StudyClass(name: "Maths", taskCompletion: 0, color: Colors.deepPurple , tasks: [])
  ].obs;
}

class ClassesPage extends StatefulWidget {
  @override
  _ClassesPageState createState() => _ClassesPageState();
}

class _ClassesPageState extends State<ClassesPage> {
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

  final _classescontroller = Get.find<ClassesController>();

  bool _isAddingClass = false;
  TextEditingController _classNameController = TextEditingController();
  Color _selectedColor = Colors.blue;

  void _addNewClass() {
    setState(() {
      _classescontroller._classes.add(StudyClass(
        name: _classNameController.text,
        taskCompletion: 0,
        color: _selectedColor,
        tasks: [],
      ));
      _isAddingClass = false;
      _classNameController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
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
                    backgroundImage:
                        NetworkImage('https://via.placeholder.com/150'),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color.fromARGB(29, 84, 84, 101)),
                  width: MediaQuery.of(context).size.width / 8,
                  height: MediaQuery.of(context).size.height / 5,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                                  color:
                                      const Color.fromARGB(76, 255, 255, 255)),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Container(
                          height: 50,
                          width: 150,
                          decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(100)),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 15,
                              ),
                              Text(
                                months[DateTime.now().month.toInt()] +
                                    ' ' +
                                    DateTime.now().year.toString(),
                                style: GoogleFonts.sora(
                                    fontSize: 20, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Container(
                  height: MediaQuery.of(context).size.height / 5,
                  width: MediaQuery.of(context).size.width / 1.4,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(29, 84, 84, 101),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 60,
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
                                      end: Alignment.bottomRight)),
                              min: 0,
                              max: 100,
                              progressBar: GaugeProgressBar.rounded(
                                color: Colors.deepPurple,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 150,
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
                                      end: Alignment.bottomRight)),
                              min: 0,
                              max: 100,
                              progressBar: GaugeProgressBar.rounded(
                                color: Colors.deepPurple,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 150,
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
                                      end: Alignment.bottomRight)),
                              min: 0,
                              max: 100,
                              progressBar: GaugeProgressBar.rounded(
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
            SizedBox(height: MediaQuery.of(context).size.height / 10),
            Expanded(child: ClassGridView()),
          ],
        ),
        if (_isAddingClass)
          Center(
            child: Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              width: 300,
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: _classNameController,
                    decoration: InputDecoration(labelText: 'Class Name'),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      _addNewClass();
                    },
                    child: Text('Save'),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class TaskController extends GetxController {

  bool isTaskCreating = false;

}

class MainShell extends StatefulWidget {
  final Widget child;

  const MainShell({required this.child});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {


  final _taskController = Get.find<TaskController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // final classGridViewState = StudyApp().classGridViewKey.currentState;
          // if (classGridViewState != null) {
          //   classGridViewState.setState(() {
          //     classGridViewState._isAddingClass = true;
          //   });
          // }
          if (GoRouter.of(context).routeInformationProvider.value.uri.toString() == '/study') {
            _taskController.isTaskCreating = true;
          }
          else {
            context.go('/add_class');
            print(GoRouter.of(context).routeInformationProvider.value.uri);
          }
        },
        backgroundColor: Colors.deepPurple,
        child: Icon(Icons.add, color: Colors.white),
      ),
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
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: widget.child,
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
                context.go('/');
              },
            ),
            // SidebarItem(
            //   icon: Icons.book,
            //   text: 'Study',
            //   onTap: () {
            //     context.go('/study');
            //   },
            // ),
            SidebarItem(
              icon: Icons.bar_chart,
              text: 'Statistics',
              onTap: () {
                context.go('/statistics');
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

// Model for Class
class StudyClass {
  final String name;
  final double taskCompletion;
  final Color color;
  final List<ClassTask> tasks;

  StudyClass({
    required this.name,
    required this.taskCompletion,
    required this.color,
    required this.tasks,
  });
}

class ClassTask {
  final String name;
  final bool isCompleted;

  ClassTask({
    required this.name,
    required this.isCompleted,
  });
}

class ClassGridView extends StatefulWidget {
  const ClassGridView({Key? key}) : super(key: key);

  @override
  State<ClassGridView> createState() => _ClassGridViewState();
}

class _ClassGridViewState extends State<ClassGridView> {
  final ClassesController _classesController = Get.find<ClassesController>();
  int _itemWidth = 4;
  int _hoveredIndex = -1;
  bool _isLoading = false;
  final ScrollController _scrollController = ScrollController();
  bool _isAddingClass = false;
  String _newClassName = '';
  Color _newClassColor = Colors.blue;

  @override
  void initState() {
    super.initState();
    _loadMoreClasses();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !_isLoading) {
        _loadMoreClasses();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadMoreClasses() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate network request delay
    // await Future.delayed(Duration(seconds: 2));

    // List<StudyClass> newClasses = List.generate(10, (index) {
    //   return StudyClass(
    //     name: 'Class ${_classesController._classes.length + index + 1}',
    //     taskCompletion:
    //         (index + 1) * 10 % 100, // Random task completion percentage
    //     color: Colors
    //         .primaries[(_classesController._classes.length + index) % Colors.primaries.length],
    //   );
    // });

    setState(() {
      _itemWidth = 4;
      // _classesController._classes.addAll(newClasses);
      _isLoading = false;
    });
  }

  void _addClass() {
    if (_newClassName.isNotEmpty) {
      setState(() {
        _classesController._classes.add(StudyClass(
          name: _newClassName,
          taskCompletion: 0,
          color: _newClassColor,
          tasks: [],
        ));
        _isAddingClass = false;
        _newClassName = '';
        _newClassColor = Colors.blue;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Stack(
        children: [
          if (_classesController._classes.isEmpty)
            Center(
              child: Text(
                'No classes created',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            )
          else
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _classesController._classes
                          .asMap()
                          .entries
                          .map((entry) {
                        int index = entry.key;
                        StudyClass studyClass = entry.value;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: MouseRegion(
                            onEnter: (_) {
                              setState(() {
                                _hoveredIndex = index;
                              });
                            },
                            onExit: (_) {
                              setState(() {
                                _hoveredIndex = -1;
                              });
                            },
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOutCirc,
                              width: constraints.maxWidth /
                                  (_hoveredIndex == index ? 2 : _itemWidth),
                              decoration: BoxDecoration(
                                color: studyClass.color,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(studyClass.name,
                                            style: _hoveredIndex == index
                                                ? GoogleFonts.sora(
                                                    fontSize: 40,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  )
                                                : GoogleFonts.sora(
                                                    fontSize: 18,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  )),
                                        SizedBox(height: 8),
                                        GestureDetector(
                                          onTap: () {
                                            _hoveredIndex == index ? context.go('/study') : null; 

                                          },
                                          child: AnimatedContainer(
                                            duration: Duration(milliseconds: 400),
                                            curve: Curves.easeInOutCirc,
                                            width:  _hoveredIndex == index ? MediaQuery.of(context).size.width/4 : 200,
                                            padding: _hoveredIndex == index ? EdgeInsets.all(10) : EdgeInsets.all(0),
                                            alignment: _hoveredIndex == index ?  Alignment.center : Alignment.topLeft,
                                            decoration: BoxDecoration(
                                              color:  _hoveredIndex == index ? Colors.black : Colors.transparent,
                                              borderRadius: BorderRadius.circular(20)
                                            ),
                                            child: Text(
                                              _hoveredIndex == index ? 'Start Study' :
                                              'Task Completion: ${studyClass.taskCompletion}%',
                                              style: GoogleFonts.sora(
                                                fontSize:  _hoveredIndex == index ? 24 : 16,
                                                color: Colors.white
                                              ),
                                              // style: TextStyle(
                                              //   fontSize:  _hoveredIndex == index ? 24 : 16,
                                              //   color: Colors.white,
                                              // ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    // _hoveredIndex == index ?
                                    // SizedBox(width: constraints.maxWidth/3)
                                    // : SizedBox(width: 1),
                                    //                   if (_hoveredIndex == index)
                                    // Padding(
                                    //   padding: const EdgeInsets.only(top: 8.0),
                                    //   child: SizedBox(
                                    //     width: double.infinity,
                                    //     child: Text(
                                    //       'Additional information about this class',
                                    //       style: TextStyle(color: Colors.grey, fontSize: 14),
                                    //     ),
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
            ),
          if (_isAddingClass)
            Center(
              child: Positioned(
                left: MediaQuery.of(context).size.width / 4,
                top: MediaQuery.of(context).size.height / 4,
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  width: MediaQuery.of(context).size.width / 2,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            _newClassName = value;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Enter Class Name',
                          hintStyle: TextStyle(color: Colors.white),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          _addClass();
                        },
                        child: Text('Save'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      );
    });
  }
}

class StudyPage extends StatefulWidget {
  @override
  State<StudyPage> createState() => _StudyPageState();
}

class _StudyPageState extends State<StudyPage> {
  // Variables
  int secondsLeft = 5;
  int minutesLeft = 10;
  int hoursLeft = 0;

  bool timerStarted = false;

  late int startingTime;

  final _classesController = Get.find<ClassesController>();

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    startingTime = hoursLeft * 60 * 60 + minutesLeft * 60 + secondsLeft;
  }

  void _startCountdown() {
    if (_timer != null && _timer!.isActive) return; // Prevent multiple timers from running

    setState(() {
      timerStarted = true;
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (secondsLeft > 0) {
          secondsLeft--;
        } else {
          if (minutesLeft > 0) {
            minutesLeft--;
            secondsLeft = 59;
          } else {
            if (hoursLeft > 0) {
              hoursLeft--;
              minutesLeft = 59;
              secondsLeft = 59;
            } else {
              timer.cancel();
            }
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Container(
            height: 100,
            width: 100,
            color: Colors.white,
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 100, left: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                   _classesController._classes.last.name,
                    style: GoogleFonts.mPlusRounded1c(
                      color: Colors.white,
                      fontSize: 100,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 1.9,
                  ),
                  Container(
                    width: 200,
                    height: 400,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$hoursLeft : $minutesLeft : $secondsLeft',
                          style: GoogleFonts.mPlusRounded1c(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        IconButton(
                          onPressed: _startCountdown,
                          icon: Icon(Icons.timer),
                        ),
                        AnimatedRadialGauge(
                          duration: Duration(seconds: 1),
                          value: hoursLeft * 60 * 60 + minutesLeft * 60 + secondsLeft.toDouble(),
                          radius: 100,
                          axis: GaugeAxis(
                            progressBar: GaugeProgressBar.rounded(color: Colors.black),
                            min: 0,
                            max: startingTime.toDouble(),
                            degrees: 360,
                            // pointer: GaugePointer.circle(radius: 10)
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Container(
                width: MediaQuery.of(context).size.width/4,
                height: MediaQuery.of(context).size.height/3,
                child:
                _classesController._classes.last.tasks.isEmpty
                
                ? 
                Text('Click + to create task', style: GoogleFonts.sora(color: Colors.white, fontSize: 24),)
                
                :
        
                ListView.builder(
                  itemCount: 20, // Number of items in the list
                  itemBuilder: (context, index) {
                    return CheckboxListTile(
                      title: Text(
                        'Task ${index + 1}',
                        style: GoogleFonts.mPlusRounded1c(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      value: false,
                      onChanged: (bool? value) {
                        // Handle checkbox state change
                      },
                      checkColor: Colors.white,
                      activeColor: Colors.blue,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }
}


class StatisticsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Statistics Page',
        style: TextStyle(fontSize: 24, color: Colors.white),
      ),
    );
  }
}

class AddClassPage extends StatefulWidget {
  const AddClassPage({super.key});

  @override
  State<AddClassPage> createState() => _AddClassPageState();
}

class _AddClassPageState extends State<AddClassPage> {
  final _classesController = Get.find<ClassesController>();

  late Color screenPickerColor;
  // Color for the picker in a dialog using onChanged.
  late Color dialogPickerColor;
  // Color for picker using the color select dialog.
  late Color dialogSelectColor;

  String textFieldEntry = 'No Class Name';

  @override
  void initState() {
    super.initState();
    screenPickerColor = Colors.blue; // Material blue.
    dialogPickerColor = Colors.red; // Material red.
    dialogSelectColor = const Color(0xFFA239CA); // A purple color.
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 100),
                child: TextField(
                  onChanged: (text) {
                    textFieldEntry = text;
                  },
                  style: GoogleFonts.sora(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Class Name',
                    hintStyle: GoogleFonts.sora(color: Colors.grey),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade400)),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: Card(
                    color: Colors.transparent,
                    elevation: 2,
                    child: ColorPicker(
                      // Use the screenPickerColor as start and active color.
                      color: screenPickerColor,
                      // Update the screenPickerColor using the callback.
                      onColorChanged: (Color color) =>
                          setState(() => screenPickerColor = color),
                      width: 44,
                      height: 44,
                      borderRadius: 22,
                      heading: Text(
                        'Select color',
                        style: GoogleFonts.sora(color: Colors.white),
                      ),
                      subheading: Text(
                        'Select color shade',
                        style: GoogleFonts.sora(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 100,
              ),
              GestureDetector(
                onTap: () {
                  _classesController._classes.add(StudyClass(
                    name: textFieldEntry,
                    taskCompletion: 0,
                    color: screenPickerColor,
                    tasks: [],
                  ));
                  context.go('/');
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.purple,
                      borderRadius: BorderRadius.circular(50)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Text(
                      'Submit',
                      style: GoogleFonts.sora(color: Colors.white),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
