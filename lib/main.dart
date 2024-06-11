import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
// import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gauge_indicator/gauge_indicator.dart';
import 'package:go_router/go_router.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';


void main() {
  Get.put(ClassesController());
  Get.put(IndexController());
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
            path: '/study/:index',
            builder: (context, state) =>
                StudyPage(index: state.pathParameters["index"] ?? "0"),
          ),
          GoRoute(
            path: '/statistics',
            builder: (context, state) => StatisticsPage(),
          ),
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
    StudyClass(
        name: "Maths", taskCompletion: 0, color: Colors.deepPurple, tasks: [])
  ].obs;
}

class IndexController extends GetxController {
  var _index = 0;
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


  List totalTasks = [];
  List completedTasks = [];
  List hourlyTasks = [];
  double maxValue = 1;
  double value = 0;
  bool _isAddingClass = false;
  TextEditingController _classNameController = TextEditingController();
  Color _selectedColor = Colors.blue;

  Timer? _timer;
  Timer? _hourlyTimer;

  int _currentSeconds = DateTime.now().second;
  String _currentTime = 'Finding Timezone...';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
    _startTimer();
    
    

    for (var item in Get.find<ClassesController>()._classes) {
     value = value + item.taskCompletion;
    }
    // if (totalTasks.length == 0) {
    //   maxValue = maxValue;
    //   value = 0;
    // } else {
    //   maxValue = totalTasks.length.toDouble() - 1;
    //   value = completedTasks.length / totalTasks.length;
    // }

    maxValue = Get.find<ClassesController>()._classes.length * 100;
    
  }
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
  void dispose() {
    _timer?.cancel();
    _hourlyTimer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _currentSeconds = DateTime.now().second;
        _currentTime = '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}';
        if (DateTime.now().minute == 0) {
          hourlyTasks.clear();
        }
      });
    });

    // _hourlyTimer = Timer.periodic(Duration(hours: 1))
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
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                            Text('Total Tasks: ${value/maxValue * 100.round()}', style: GoogleFonts.mPlusRounded1c(color: Colors.white, fontSize: 15),),
                              AnimatedRadialGauge(
                                duration: Duration(seconds: 1),
                                value: value,
                                radius: 150,
                                
                                curve: Curves.elasticOut,
                                axis: GaugeAxis(
                                  degrees: 270,
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
                                  max: maxValue,
                                  progressBar: GaugeProgressBar.rounded(
                                    color: Colors.deepPurple,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 150,
                        ),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Text(_currentTime, style: GoogleFonts.sora(color: Colors.white, fontSize: _currentTime == 'Finding Timezone...' ? 11 : 20),),
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

class MainShell extends StatefulWidget {
  final Widget child;

  const MainShell({required this.child});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  final _index = Get.find<IndexController>()._index;

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

          if (GoRouter.of(context)
              .routeInformationProvider
              .value
              .uri
              .toString()
              .startsWith('/study/')) {
            context.go('/add_task/$_index');
          } else if (GoRouter.of(context)
              .routeInformationProvider
              .value
              .uri
              .toString()
              .startsWith('/add_task')) {
            null;
          } else if (GoRouter.of(context)
              .routeInformationProvider
              .value
              .uri
              .toString()
              .startsWith('/add_class')) {
            null;
          } else {
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
  double taskCompletion;
  final Color color;
  final List<ClassTask> tasks;

  StudyClass({
    required this.name,
    required this.taskCompletion,
    required this.color,
    required this.tasks,
  });

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

class ClassTask {
  final String name;
  bool isCompleted;

  ClassTask({
    required this.name,
    required this.isCompleted,
  });

  ClassTask.fromMap(Map map) 
    : this.name = map["name"],
      this.isCompleted = map["isCompleted"];
  

  Map toMap() {
    return {
      "name": this.name,
      "isCompleted": this.isCompleted,
    };
  }
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

    //initialise
    
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
        Future<void> saveData(String key, String value) async {
          final prefs = await SharedPreferences.getInstance();
          List<String> usrList = _classesController._classes.map((item) => jsonEncode(item.toMap())).toList();

          // await prefs.setStringList("classes", _classesController._classes.toList());
}
      });
    }
  }

  @override
  final _indexController = Get.find<IndexController>();

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

class TimerManager {
  late Timer _timer;
  late int _remainingSeconds;
  late bool _isRunning = false;
  String timerStatus = 'stopped';
  // bool timerRunFirstTime;
  // late int timerFTStart = 200;

  TimerManager(int hours, int minutes, int seconds) {
    _remainingSeconds = hours * 3600 + minutes * 60 + seconds;
  }

  void startTimer(Function(int, int, int) callback) {
    if (!_isRunning) {
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (_remainingSeconds > 0) {
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

  void pauseTimer() {
    timerStatus = 'paused';
    _timer.cancel();
    _isRunning = false;
  }

  void resumeTimer(Function(int, int, int) callback) {
    timerStatus = 'running';
    startTimer(callback);
  }

  bool isRunning() {
    return _isRunning;
  }

  int getStartingTime (hours, minutes, seconds) {
    // if (timerRunFirstTime == false) {
    //   timerRunFirstTime == true;
      // print(hours * 3600 + minutes * 60 + seconds);
      
      return hours * 3600 + minutes * 60 + seconds;
    // } else {
    //   return timerFTStart;
    // }
    
  }

  void dispose() {
    _timer.cancel(); // Cancel the timer when disposing
    _isRunning = false;
  }
}



class StudyPage extends StatefulWidget {
  final String index;

  StudyPage({
    required this.index,
  });

  @override
  State<StudyPage> createState() => _StudyPageState();
}

class _StudyPageState extends State<StudyPage> {

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
    super.initState();
    // int secondsLeft = 0;
    // int minutesLeft = 45;
    // int hoursLeft = 1;
    _timerManager = TimerManager(0, _startingMinutes, 0);
    _timerManager.startTimer((hours, minutes, seconds) {
      setState(() {
        _hours = hours;
        _minutes = minutes;
        _seconds = seconds;
        
      });
    // startingTime = _timerManager.getStartingTime(_startingHours, _startingMinutes, _startingSeconds).toDouble();
    print("initstate called");
  
  
    
  });

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   if (!_isInitialized) {
  //     // Run your one-time initialization code here
  //     // This code will only run the first time the widget is built
      
  //     _isInitialized = true; // Update the flag
  //     print("didchangedependencies called");
  //   }
  // }
    
  }

  // void _startCountdown() {
  //   if (_timer != null && _timer!.isActive)
  //     return; // Prevent multiple timers from running

  //   setState(() {
  //     timerStarted = true;
  //   });

  //   _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      
  //     setState(() {
  //       if (secondsLeft > 0) {
  //         secondsLeft--;
  //       } else {
  //         if (minutesLeft > 0) {
  //           minutesLeft--;
  //           secondsLeft = 59;
  //         } else {
  //           if (hoursLeft > 0) {
  //             hoursLeft--;
  //             minutesLeft = 59;
  //             secondsLeft = 59;
  //           } else {
  //             timer.cancel();
  //           }
  //         }
  //       }
  //     });
  //   });
  // }
  void _toggleTimer() {
  if (_timerManager.isRunning()) {
    _timerManager.pauseTimer();
  } else {
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
  final _indexController = Get.find<IndexController>();
  String timerMessage = 'Tap for info';
  // String timerInfo = 'Create all your tasks before starting timer';
  
  Widget build(BuildContext context) {
    return Container(
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
                      // color: Colors.deepPurple,
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
                    // SizedBox(
                    //   width: MediaQuery.of(context).size.width / 4,
                    // ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                // alignment: Alignment.topCenter,
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
                          return CheckboxListTile(
                            title: Text(
                              _classesController
                                  ._classes[_indexController._index]
                                  .tasks[index]
                                  .name,
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
                              List<ClassTask> completedTasks = [];

                              value != value;
                              // print(value.toString());
                              setState(() {
                                _classesController
                                    ._classes[_indexController._index]
                                    .tasks[index]
                                    .isCompleted = value ?? false;
                              });
                              for (int task = 0;
                                  task <
                                      _classesController
                                          ._classes[_indexController._index]
                                          .tasks
                                          .length;
                                  task++) {
                                if (_classesController
                                        ._classes[_indexController._index]
                                        .tasks[task]
                                        .isCompleted ==
                                    true) {
                                  completedTasks.add(_classesController
                                      ._classes[_indexController._index]
                                      .tasks[task]);
                                }
                              }
                              _classesController
                                      ._classes[_indexController._index]
                                      .taskCompletion =
                                  completedTasks.length /
                                      _classesController
                                          ._classes[_indexController._index]
                                          .tasks
                                          .length * 100;
                              print(completedTasks.length);
                              print(_classesController
                                  ._classes[_indexController._index]
                                  .tasks
                                  .length);
                              print(_classesController
                                  ._classes[_indexController._index]
                                  .taskCompletion);
                            },
                            checkColor: Colors.white,
                            activeColor: Colors.blue,
                          );
                        },
                      ),
              ),
            ],
          ),
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
                        print("tapped");
                        setState(() {
                          if (_classesController._classes[_indexController._index].tasks.isEmpty == true) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Add Task to Access Timer"),
                                );
                              },
                              // title: Text("Add Task to Access Timer"),
                            );
                        } else {
                          _toggleTimer();
                          timerMessage = '$_hours : $_minutes : $_seconds';
                        }
                        });
                      },
                      child: AnimatedContainer(
                        alignment: Alignment.center,
                      duration: Duration(milliseconds: 200),
                      height: 160,
                      width: 160,
                      decoration: BoxDecoration(
                        color: _timerManager.isRunning() ? Colors.green : Colors.red,
                        borderRadius: BorderRadius.circular(100)
                      ),
                        child: Text(
                         '$_hours : $_minutes : $_seconds',
                          style: GoogleFonts.mPlusRounded1c(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    // IconButton(
                    //   onPressed: _startCountdown,
                    //   icon: Icon(Icons.timer),
                    // ),
                    AnimatedRadialGauge(
                      duration: Duration(seconds: 1),
                      value: _hours * 60 * 60 +
                          _minutes * 60 +
                          _seconds.toDouble(),
                      radius: 120,
                      axis: GaugeAxis(
                        progressBar:
                            GaugeProgressBar.rounded(gradient: GaugeAxisGradient(colors: [
                              Color(0xFF9600FF),
                              Color(0xFFAEBAf8),
                            ],),),
                        min: 0,
                        max: startingTime,
                        degrees: 360,
                        // pointer: GaugePointer.circle(radius: 10)
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 200,
                ),
                Container(
                  alignment: Alignment.center,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Text(_classesController
                            ._classes[_indexController._index].taskCompletion.round().toString(), style: GoogleFonts.mPlusRounded1c(color: Colors.white, fontSize: 30),),
                      
                      AnimatedRadialGauge(
                        curve: Curves.easeInOutCirc,
                        duration: Duration(seconds: 1),
                        value: _classesController
                            ._classes[_indexController._index].taskCompletion,
                        radius: 120,
                        axis: GaugeAxis(
                          pointer: GaugePointer.needle(width: 0, height: 0, color: Colors.white),
                          progressBar: const GaugeProgressBar.rounded(gradient: GaugeAxisGradient(colors: [
                              Color(0xFFF6EA41),
                              Color(0xFFF048C6),
                            ])),
                          min: 0,
                          max: 100,
                          degrees: 360,
                          // pointer: GaugePointer.circle(radius: 10)
                        
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
void dispose() {
  _timerManager.dispose(); // Cancel the timer
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

class AddTaskPage extends StatefulWidget {
  final String index;

  const AddTaskPage({super.key, required this.index});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final _classesController = Get.find<ClassesController>();
  final _indexController = Get.find<IndexController>();

  String textFieldEntry = 'No Task Name';

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 100),
            child: TextField(
              onSubmitted: (text) {
                _classesController._classes[_indexController._index].tasks
                    .add(ClassTask(name: text, isCompleted: false));
                context.go('/study/' + _indexController._index.toString());
                // print(_indexController._index);
                // print(_classesController._classes[int.parse(widget.index)].name);
                // print(_classesController._classes[int.parse(widget.index)].tasks.last.name);
                List<ClassTask> completedTasks =  [];
                for (int task = 0;
                                  task <
                                      _classesController
                                          ._classes[_indexController._index]
                                          .tasks
                                          .length;
                                  task++) {
                                if (_classesController
                                        ._classes[_indexController._index]
                                        .tasks[task]
                                        .isCompleted ==
                                    true) {
                                  completedTasks.add(_classesController
                                      ._classes[_indexController._index]
                                      .tasks[task]);
                                }
                              }
                              _classesController
                                      ._classes[_indexController._index]
                                      .taskCompletion =
                                  completedTasks.length /
                                      _classesController
                                          ._classes[_indexController._index]
                                          .tasks
                                          .length * 100;
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
        ],
      ),
    );
  }
}
