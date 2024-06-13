import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:gauge_indicator/gauge_indicator.dart';
import 'package:go_router/go_router.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

// Initialise App and Set-up universal variables
void main() {
  Get.put(ClassesController());
  Get.put(IndexController());
  runApp(StudyApp());
}

// Navigation Set Up
class StudyApp extends StatelessWidget {
  final GlobalKey<_ClassGridViewState> classGridViewKey =
      GlobalKey<_ClassGridViewState>();

  // Intialising named routes for app navigation
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
            path: '/study/:index',
            builder: (context, state) =>
                StudyPage(index: state.pathParameters["index"] ?? "0"),
          ),
          // GoRoute(
          //   path: '/statistics',
          //   builder: (context, state) => StatisticsPage(),
          // ),
          GoRoute(
            path: '/add_class',
            builder: (context, state) => AddClassPage(),
          ),
          GoRoute(
            path: '/add_task/:index',
            builder: (context, state) =>
                AddTaskPage(index: state.pathParameters["index"] ?? "0"),
          ),
        ],
      ),
    ],
  );

  // building home screen
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

// universal variable to access class information on all widgets
class ClassesController extends GetxController {
  var _classes = <StudyClass>[
    StudyClass(
        name: "Maths", taskCompletion: 0, color: Colors.deepPurple, tasks: []),
            StudyClass(
        name: "English", taskCompletion: 0, color: Colors.blue, tasks: []),
            StudyClass(
        name: "Science", taskCompletion: 0, color: Colors.green, tasks: []),
            StudyClass(
        name: "Programming", taskCompletion: 0, color: Colors.deepOrange, tasks: []),
            StudyClass(
        name: "BM 12", taskCompletion: 0, color: Colors.teal, tasks: []),

  ].obs;
}

// universal variable to access index of selected class
class IndexController extends GetxController {
  var _index = 0;
}

//home page or class view page
class ClassesPage extends StatefulWidget {
  @override
  _ClassesPageState createState() => _ClassesPageState();
}

class _ClassesPageState extends State<ClassesPage> {
  // translate month index to month text
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

  //impoort the _classesController to get the _classes list
  final _classescontroller = Get.find<ClassesController>();

  //variables for tracking tasks
  List totalTasks = [];
  List completedTasks = [];
  List hourlyTasks = [];
  int currentTaskLength = 0;
  double maxValue = 1;
  double value = 0;
  bool _isAddingClass = false;
  TextEditingController _classNameController = TextEditingController();
  Color _selectedColor = Colors.blue;

  //timer for gauges
  Timer? _timer;
  Timer? _hourlyTimer;

  int _currentSeconds = DateTime.now().second;
  String _currentTime = 'Finding Timezone...';

  int? closestDueDate;
  DateTime closestDueDateTime = DateTime(DateTime.now().year + 1);

  //initialise the state for the page
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //start timer for gauge
    _startTimer();

    //for every item in the _classes list
    for (var item in Get.find<ClassesController>()._classes) {
      //add "taskCompletion" to "value"
      value = value + item.taskCompletion;
    }

    // set the maximum value to the length of classes times 100
    maxValue = Get.find<ClassesController>()._classes.length * 100;
  }

  // function for adding a new class
  void _addNewClass() {
    //setState so UI updates
    setState(() {
      //add the StudyClass class to the _classes list
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

  // dispose timers
  @override
  void dispose() {
    _timer?.cancel();
    _hourlyTimer?.cancel();
    super.dispose();
  }

  // function to start the timer
  void _startTimer() {
    List timerCompletedTasks = [];
    // happen every second
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        //set the second hand of the gauge to the currebt second
        _currentSeconds = DateTime.now().second;
        //set the time of the time display to the current time
        _currentTime =
            '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}';

        List dueDates = [];
        List dueDateTime = [];
        int daysBetween(DateTime from, DateTime to) {
          from = DateTime(from.year, from.month, from.day);
          to = DateTime(to.year, to.month, to.day);
          return (to.difference(from).inHours / 24).round();
        }

        for (var item in _classescontroller._classes) {
          if (item.tasks.isNotEmpty) {
            for (var task in item.tasks) {
              dueDates.add(daysBetween(DateTime.now(), task.dueDate));
              dueDateTime.add(task.dueDate);
            }
          } else {
            closestDueDateTime = DateTime(DateTime.now().year + 1);
          }
        }

        dueDates.sort();
        dueDateTime.sort((a, b) {
          DateTime now = DateTime.now();
          Duration diffA = a.difference(now);
          Duration diffB = b.difference(now);
          return diffA.inMilliseconds.compareTo(diffB.inMilliseconds);
        });
        
        if (dueDateTime.isNotEmpty) {
          closestDueDateTime = dueDateTime.first;
        }
        
        if (dueDates.isNotEmpty) {
          closestDueDate = dueDates.first;
        }
        
      });
    });
  }

  @override
  // build method
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    final DateTime oneMonthAgo = DateTime(now.year, now.month - 1, now.day);

    // home page creation
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
                    'Time to Study!',
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
            // date display
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
                // Task Completion Gauge
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
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Text(
                                'Total Tasks: ${(value / maxValue * 100).round()}',
                                style: GoogleFonts.mPlusRounded1c(
                                    color: Colors.white, fontSize: 15),
                              ),
                              AnimatedRadialGauge(
                                duration: Duration(seconds: 1),
                                value: value,
                                radius: 150,
                                curve: Curves.easeInOutCirc,
                                axis: GaugeAxis(
                                  degrees: 270,
                                  pointer: GaugePointer.circle(
                                      radius: 13,
                                      gradient: LinearGradient(
                                          colors: value == maxValue
                                              ? [Colors.green, Colors.blue]
                                              : [
                                                  Colors.deepPurple,
                                                  Colors.purple
                                                ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight)),
                                  min: 0,
                                  max: maxValue,
                                  progressBar: GaugeProgressBar.rounded(
                                    color: value == maxValue
                                        ? Colors.green
                                        : Colors.deepPurple,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 150,
                        ),
                        // Time Gauge
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Text(
                              _currentTime,
                              style: GoogleFonts.sora(
                                  color: Colors.white,
                                  fontSize:
                                      _currentTime == 'Finding Timezone...'
                                          ? 11
                                          : 20),
                            ),
                            Container(
                              child: AnimatedRadialGauge(
                                duration: Duration(seconds: 1),
                                value: _currentSeconds.toDouble(),
                                radius: 150,
                                curve: Curves.ease,
                                axis: GaugeAxis(
                                  degrees: 360,
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
                                  max: 60,
                                  progressBar: GaugeProgressBar.rounded(
                                    color: Colors.deepPurple,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 150,
                        ),
                        // Gauge 3
                        Container(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Text(
                                //null check
                                closestDueDate != null
                                    ? '${closestDueDate! < 3 ? 'Hurry' : ''} A task is due in ${closestDueDate} days!'
                                    : "No Tasks Created",
                                style: GoogleFonts.mPlusRounded1c(
                                  //null check
                                    color: Colors.white, fontSize: closestDueDate != null ? 10 : 15),
                              ),
                              AnimatedRadialGauge(
                                duration: Duration(seconds: 1),
                                value: DateTime.now().millisecondsSinceEpoch.toDouble(),
                                radius: 150,
                                curve: Curves.elasticOut,
                                axis: GaugeAxis(
                                  degrees: 270,
                                  pointer: GaugePointer.circle(
                                      radius: 13,
                                      gradient: LinearGradient(
                                          colors: 
                                          //null check
                                          closestDueDate != null ? 
                                          closestDueDate! < 3 ? 
                                          [
                                            Colors.red,
                                            Colors.pink
                                          ]
                                          :

                                          [
                                            Colors.deepPurple,
                                            Colors.purple
                                          ]


                                          :
                                          
                                          [
                                            Colors.deepPurple,
                                            Colors.purple
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight)),
                                  min: oneMonthAgo.millisecondsSinceEpoch.toDouble(),
                                  max: closestDueDateTime.millisecondsSinceEpoch.toDouble(),
                                  progressBar: GaugeProgressBar.rounded(
                                    gradient: GaugeAxisGradient(colors: 
                                    //null check
                            
                                          closestDueDate != null ? 
                                          closestDueDate! < 3 ? 
                                          [
                                            Colors.red,
                                            Colors.pink
                                          ]
                                          :

                                          [
                                            Colors.deepPurple,
                                            Colors.purple
                                          ]


                                          :
                                          
                                          [
                                            Colors.deepPurple,
                                            Colors.purple
                                          ],),
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
            // Display Classes (see Class GridView)
            SizedBox(height: MediaQuery.of(context).size.height / 10),
            Expanded(child: ClassGridView()),
          ],
        ),
      ],
    );
  }
}

//main shell widget => Prevents sidebar from being rebuilt every time you switch screens
class MainShell extends StatefulWidget {
  final Widget child;

  const MainShell({required this.child});

  @override
  State<MainShell> createState() => _MainShellState();
}
// isolate shell
class _MainShellState extends State<MainShell> {
  final _index = Get.find<IndexController>()._index;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        // bottom right button logic
        onPressed: () {
          // if im in the study screen
          if (GoRouter.of(context)
              .routeInformationProvider
              .value
              .uri
              .toString()
              .startsWith('/study/')) {
                // then make the button go to the task screen
            context.go('/add_task/$_index');
          } else if (GoRouter.of(context)
              .routeInformationProvider
              .value
              .uri
              .toString()
              .startsWith('/add_task')) {
                //prevent button from redirecting when in an important page
            null;
          } else if (GoRouter.of(context)
              .routeInformationProvider
              .value
              .uri
              .toString()
              .startsWith('/add_class')) {
                //prevent button from redirecting when in an important page
            null;
          } else {
            // if in home page make it add class
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

// create the sidebar so it doesn't have to be rebuilt when it is called again
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
                      // studious logo in the sidebar
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
            //   icon: Icons.bar_chart,
            //   text: 'Statistics',
            //   onTap: () {
            //     context.go('/statistics');
            //   },
            // ),
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

// StudyClass class
class StudyClass {
  final String name;
  double taskCompletion;
  final Color color;
  final List<ClassTask> tasks;

  StudyClass({
    required this.name,
    required this.taskCompletion,
    required this.color,
    required this.tasks,
  });

// Map converter for saving (not implemented)
  StudyClass.fromMap(Map map)
      : this.name = map["name"],
        this.taskCompletion = map["taskCompletion"],
        this.color = map["color"],
        this.tasks = map["tasks"];

  Map toMap() {
    return {
      "name": this.name,
      "taskCompletion": this.taskCompletion,
      "color": this.color,
      "tasks": this.tasks,
    };
  }
}

// ClassTask class
class ClassTask {
  final String name;
  bool isCompleted;
  DateTime dueDate;

  ClassTask({
    required this.name,
    required this.isCompleted,
    required this.dueDate,
  });
}

// Animated Gridview (seen on homescreen)
class ClassGridView extends StatefulWidget {
  const ClassGridView({Key? key}) : super(key: key);

  @override
  State<ClassGridView> createState() => _ClassGridViewState();
}

class _ClassGridViewState extends State<ClassGridView> {
  // gridview variables
  final ClassesController _classesController = Get.find<ClassesController>();
  int _itemWidth = 4;
  int _hoveredIndex = -1;
  bool _isLoading = false;
  final ScrollController _scrollController = ScrollController();
  bool _isAddingClass = false;
  String _newClassName = '';
  Color _newClassColor = Colors.blue;

  @override
  // initialise state
  void initState() {
    super.initState();
    _loadMoreClasses();
    //listent to the scroll controller to cahge scroll position when hovered over
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
    //dispose of scroll controller when widget is not active
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadMoreClasses() async {
    // load more classes (not needed as local database)
    setState(() {
      _isLoading = true;
    });

    setState(() {
      _itemWidth = 4;

      _isLoading = false;
    });
  }

  void _addClass() { //function to add class
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
        Future<void> saveData(String key, String value) async {
          final prefs = await SharedPreferences.getInstance();
          List<String> usrList = _classesController._classes
              .map((item) => jsonEncode(item.toMap()))
              .toList();
        }
      });
    }
  }

  @override
  // access index controller (the index of the current selected class)
  final _indexController = Get.find<IndexController>();


  //build method for gridview (any if statements are for resiizing elements to fit different screen sizes)
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
                                            _indexController._index = index;
                                            context.go('/study/$index');
                                          },
                                          child: AnimatedContainer(
                                            duration:
                                                Duration(milliseconds: 400),
                                            curve: Curves.easeInOutCirc,
                                            width: _hoveredIndex == index
                                                ? MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    4
                                                : 200,
                                            padding: _hoveredIndex == index
                                                ? EdgeInsets.all(10)
                                                : EdgeInsets.all(0),
                                            alignment: _hoveredIndex == index
                                                ? Alignment.center
                                                : Alignment.topLeft,
                                            decoration: BoxDecoration(
                                                color: _hoveredIndex == index
                                                    ? Colors.black
                                                    : Colors.transparent,
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            child: Text(
                                              _hoveredIndex == index
                                                  ? 'Start Study'
                                                  : 'Task Completion: ${studyClass.taskCompletion}%',
                                              style: GoogleFonts.sora(
                                                  fontSize:
                                                      _hoveredIndex == index
                                                          ? 24
                                                          : 16,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
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
        ],
      );
    });
  }
}

// Timer manager for updating gauges
class TimerManager {
  late Timer _timer;
  late int _remainingSeconds;
  late bool _isRunning = false;
  String timerStatus = 'stopped';

  TimerManager(int hours, int minutes, int seconds) {
    _remainingSeconds = hours * 3600 + minutes * 60 + seconds;
  }

  void startTimer(Function(int, int, int) callback) {
    // if the timer is not equal to isRunning
    if (!_isRunning) {
      // start timer 
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        // if the timer is not finished
        if (_remainingSeconds > 0) {
          // reduce the seconds
          _remainingSeconds--;
          final hours = _remainingSeconds ~/ 3600;
          final minutes = (_remainingSeconds ~/ 60) % 60;
          final seconds = _remainingSeconds % 60;
          callback(hours, minutes, seconds);
        } else {
          _timer.cancel();
        }
      });
      _isRunning = true;
      timerStatus = 'running';
    }
  }

// pause timer
  void pauseTimer() {
    timerStatus = 'paused';
    _timer.cancel();
    _isRunning = false;
  }

// resume timer
  void resumeTimer(Function(int, int, int) callback) {
    timerStatus = 'running';
    startTimer(callback);
  }

// return if the timer is running or not
  bool isRunning() {
    return _isRunning;
  }

// get the starting time of the timer
  int getStartingTime(hours, minutes, seconds) {
    return hours * 3600 + minutes * 60 + seconds;
  }

// dispose of the timer after use
  void dispose() {
    _timer.cancel(); // Cancel the timer when disposing
    _isRunning = false;
  }
}

// study mode page
class StudyPage extends StatefulWidget {
  final String index;

  StudyPage({
    required this.index,
  });

  @override
  State<StudyPage> createState() => _StudyPageState();
}

class _StudyPageState extends State<StudyPage> {
  // study page variables
  int _startingHours = 0;
  int _startingMinutes = 45;
  int _startingSeconds = 0;
  // Variables
  int _hours = 0;
  int _minutes = 0;
  int _seconds = 0;
  String timerStatus = 'stopped';
  bool _isInitialized = false;

  bool timerStarted = false;

  double startingTime = 2700;

  final _classesController = Get.find<ClassesController>();

  Timer? _timer;

  late TimerManager _timerManager;

  @override
  void initState() {
    // initialise the state of the timer
    super.initState();

    _timerManager = TimerManager(0, _startingMinutes, 0);
    _timerManager.startTimer((hours, minutes, seconds) {
      setState(() {
        _hours = hours;
        _minutes = minutes;
        _seconds = seconds;
      });

    
    });
  }
// dunction for toggling timer on and off
  void _toggleTimer() {
    // if the timer is running
    if (_timerManager.isRunning()) {
      // pause it
      _timerManager.pauseTimer();
    } else {
      // if it isn't resume it
      _timerManager.resumeTimer((hours, minutes, seconds) {
        setState(() {
          _hours = hours;
          _minutes = minutes;
          _seconds = seconds;
        });
      });
    }
  }

  @override
  // build method and variables
  final _indexController = Get.find<IndexController>();
  String timerMessage = 'Tap for info';

  Widget build(BuildContext context) {
    return Container(
      //TITLE
      padding: EdgeInsets.only(top: 100, left: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 600,
                      child: AutoSizeText(
                        _classesController
                            ._classes[_indexController._index].name,
                        overflow: TextOverflow.ellipsis,
                        minFontSize: 50,
                        maxFontSize: 100,
                        maxLines: 1,
                        style: GoogleFonts.mPlusRounded1c(
                          color: Colors.white,
                          fontSize: 100,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              //CHECKLIST
              Container(
                width: MediaQuery.of(context).size.width / 3,
                height: MediaQuery.of(context).size.height / 4,
                child: _classesController
                        ._classes[_indexController._index].tasks.isEmpty
                    ? Text(
                        'Click + to create task',
                        style:
                            GoogleFonts.sora(color: Colors.white, fontSize: 24),
                      )
                    : ListView.builder(
                        itemCount: _classesController
                            ._classes[_indexController._index]
                            .tasks
                            .length, // Number of items in the list
                        itemBuilder: (context, index) {
                          int difference(from, to) {
                            from = DateTime.now();
                            to = _classesController
                                ._classes[_indexController._index]
                                .tasks[index]
                                .dueDate;
                            from = DateTime(from.year, from.month, from.day);
                            to = DateTime(to.year, to.month, to.day);
                            return (to.difference(from).inHours / 24).round();
                          }

                          return CheckboxListTile(
                            title: Text(
                              // checklist name and due date
                              _classesController
                                      ._classes[_indexController._index]
                                      .tasks[index]
                                      .name +
                                  ':   Task due in ${difference(0, 0).toString()} day(s)',
                              style: GoogleFonts.mPlusRounded1c(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                            value: _classesController
                                ._classes[_indexController._index]
                                .tasks[index]
                                .isCompleted,
                            onChanged: (bool? value) {
                              // if the checkbox is changed

                              // completed tasks list (for tracking task completion percentage)
                              List<ClassTask> completedTasks = [];
                              // set the bool to opposite of itself
                              value != value;

                              setState(() {
                                // change the task attribute of isCompleted to the value
                                _classesController
                                    ._classes[_indexController._index]
                                    .tasks[index]
                                    .isCompleted = value ?? false;
                              });
                              // for every task in _classsescontroler...tasks
                              for (int task = 0;
                                  task <
                                      _classesController
                                          ._classes[_indexController._index]
                                          .tasks
                                          .length;
                                  task++) {
                                    // if the task is completed
                                if (_classesController
                                        ._classes[_indexController._index]
                                        .tasks[task]
                                        .isCompleted ==
                                    true) {
                                      // add it to the completed tasks list 
                                  completedTasks.add(_classesController
                                      ._classes[_indexController._index]
                                      .tasks[task]);
                                }
                              }
                              // calculate class completion percentage
                              _classesController
                                      ._classes[_indexController._index]
                                      .taskCompletion =
                                  completedTasks.length /
                                      _classesController
                                          ._classes[_indexController._index]
                                          .tasks
                                          .length *
                                      100;
                            },
                            // checkbox colors
                            checkColor: Colors.white,
                            activeColor: Colors.blue,
                          );
                        },
                      ),
              ),
            ],
          ),
          // TIMER
          Container(
            alignment: Alignment.center,
            width: 500,
            height: 800,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        
                        setState(() {
                          if (_classesController
                                  ._classes[_indexController._index]
                                  .tasks
                                  .isEmpty ==
                              true) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Add Task to Access Timer"),
                                );
                              },
                            );
                          } else {
                            _toggleTimer();
                            timerMessage = '$_hours : $_minutes : $_seconds';
                          }
                        });
                      },
                      child: 
                      // TIMER GAUGE
                      AnimatedContainer(
                        alignment: Alignment.center,
                        duration: Duration(milliseconds: 200),
                        height: 160,
                        width: 160,
                        decoration: BoxDecoration(
                            color: _timerManager.isRunning()
                                ? Colors.green
                                : Colors.red,
                            borderRadius: BorderRadius.circular(100)),
                        child: Text(
                          '$_hours : $_minutes : $_seconds',
                          style: GoogleFonts.mPlusRounded1c(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    // TASK COMPLETION GAUGE
                    AnimatedRadialGauge(
                      duration: Duration(seconds: 1),
                      value: _hours * 60 * 60 +
                          _minutes * 60 +
                          _seconds.toDouble(),
                      radius: 120,
                      axis: GaugeAxis(
                        progressBar: GaugeProgressBar.rounded(
                          gradient: GaugeAxisGradient(
                            colors: [
                              Color(0xFF9600FF),
                              Color(0xFFAEBAf8),
                            ],
                          ),
                        ),
                        min: 0,
                        max: startingTime,
                        degrees: 360,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 200,
                ),
                // display task completion
                Container(
                  alignment: Alignment.center,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Text(
                        _classesController
                            ._classes[_indexController._index].taskCompletion
                            .round()
                            .toString(),
                        style: GoogleFonts.mPlusRounded1c(
                            color: Colors.white, fontSize: 30),
                      ),
                      AnimatedRadialGauge(
                        curve: Curves.easeInOutCirc,
                        duration: Duration(seconds: 1),
                        value: _classesController
                            ._classes[_indexController._index].taskCompletion,
                        radius: 120,
                        axis: GaugeAxis(
                          pointer: GaugePointer.needle(
                              width: 0, height: 0, color: Colors.white),
                          progressBar: const GaugeProgressBar.rounded(
                              gradient: GaugeAxisGradient(colors: [
                            Color(0xFFF6EA41),
                            Color(0xFFF048C6),
                          ])),
                          min: 0,
                          max: 100,
                          degrees: 360,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  //dispose of timer
  void dispose() {
    _timerManager.dispose(); 
    super.dispose();
  }
}

// class StatisticsPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Text(
//         'Statistics Page',
//         style: TextStyle(fontSize: 24, color: Colors.white),
//       ),
//     );
//   }
// }

// ADDING CLASSES PAGE
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
    // set color settings for color picker
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
                // CLASS NAME TEXT FIELD
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
              // COLOR PICKER
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
                  // add new class to the _classes list
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

// ADD TASK PAGE
class AddTaskPage extends StatefulWidget {
  final String index;

  const AddTaskPage({super.key, required this.index});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {

  // adding task
  DateTime? _pickedDate;
  final _classesController = Get.find<ClassesController>();
  final _indexController = Get.find<IndexController>();
  String taskName = 'NO TASK NAME';

  String textFieldEntry = 'No Task Name';

  Future<void> _selectDate(BuildContext context) async {

    // date picker function
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
    );

    if (pickedDate != null) {
      // null check
      setState(() {
        _pickedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 100),
            child: 
            // TASK NAME FIELD
            TextField(
              onChanged: (text) {
                // _classesController._classes[_indexController._index].tasks
                //     .add(ClassTask(name: text, isCompleted: false));
                taskName = text;
                // context.go('/study/' + _indexController._index.toString());
              },
              style: GoogleFonts.sora(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Task Name',
                hintStyle: GoogleFonts.sora(color: Colors.grey),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade400)),
              ),
            ),
          ),
          SizedBox(
            height: 100,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 100),
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.circular(10),

              ),
                child: IconButton(
              icon: Icon(Icons.date_range, color: Colors.white,),
              onPressed: () {
                // date picker
                _selectDate(context);
              },
            )),
          ),
          SizedBox(
            height: 100,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 100),
            child: GestureDetector(
              onTap: () {
                // if the user picked a date
                if (_pickedDate != null) {
                  _classesController._classes[_indexController._index].tasks.add(

                    // add the task to the tasks list
                    ClassTask(
                        name: taskName,
                        isCompleted: false,
                        dueDate: _pickedDate ?? DateTime(2025)));

                // tracking completed tasks again
                List<ClassTask> completedTasks = [];
                for (int task = 0;
                    task <
                        _classesController
                            ._classes[_indexController._index].tasks.length;
                    task++) {
                  if (_classesController._classes[_indexController._index]
                          .tasks[task].isCompleted ==
                      true) {
                    completedTasks.add(_classesController
                        ._classes[_indexController._index].tasks[task]);
                  }
                }
                _classesController
                        ._classes[_indexController._index].taskCompletion =
                    completedTasks.length /
                        _classesController
                            ._classes[_indexController._index].tasks.length *
                        100;
                context.go('/study/:${_indexController._index}');

                } 
                // if the user didn't pick a date
                else {
                  showDialog(context: context, builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Enter date to continue"),
                    );
                  });
                }
                
              },
              child: Container(
                child: Text("Submit", style: GoogleFonts.sora(color: Colors.white),),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
