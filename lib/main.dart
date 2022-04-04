// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers

//import 'dart:ffi';
//import 'dart:ui';
import 'dart:async';
import 'dart:io';

import 'package:true_aviation_task/assignTask.dart';
import 'package:true_aviation_task/changePassword.dart';
import 'package:true_aviation_task/checkAvalability.dart';
import 'package:true_aviation_task/createNewUser.dart';
import 'package:true_aviation_task/justSubTaskAdd.dart';
import 'package:true_aviation_task/lobby.dart';
import 'package:true_aviation_task/calender.dart';
import 'package:true_aviation_task/logInPage.dart';
import 'package:true_aviation_task/subTaskDetails.dart';
import 'package:true_aviation_task/todaysTasks.dart';
import 'package:true_aviation_task/allTasks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

import 'package:flutter/material.dart';
import 'package:true_aviation_task/utils/session_maneger.dart';
import 'api_service.dart';
import 'controller.dart';

//void main() => runApp(MyApp());

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(MyApp());
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        /* dark theme settings */
      ),
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        '/lobby': (BuildContext context) => LobbyPage(),
        '/changePassword': (BuildContext context) => ChangePasswordPage(),
        '/createNewUser': (BuildContext context) => CreateNewUserPage(),
        '/calender': (BuildContext context) => CalenderPage(),
        '/todaysTasks': (BuildContext context) => TodaysTasks(),
        '/allTasks': (BuildContext context) => AllTasks(),
        '/assignTask': (BuildContext context) => AssignTask(),
        '/checkAvalability': (BuildContext context) => CheckAvailabilityPage(),
        '/subTaskPage': (BuildContext context) => SubTasksPage(),
        '/justSubTaskPage': (BuildContext context) => JustSubTasksPage(),
        '/logINPage': (BuildContext context) => LogInPage()
        // '/summery': (BuildContext context) => SummeryPage(),
        // '/newlead': (BuildContext context) => NewLead(),
        // '/newleadtransaction': (BuildContext context) => NewLeadTransaction(),
        // '/itemdetails': (BuildContext context) => ItemDetails(),
      },
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  String route = '';
  void initState() {
    super.initState();
    getRoutePath();
    Timer(Duration(seconds: 3),
        () => Navigator.of(context).pushReplacementNamed(route));
  }

  getRoutePath() async {
    String vari = await localGetEmployeeID();
    print('main=' + vari);
    bool logInStatus = await localLoginStatus();
    if (logInStatus) {
      route = '/lobby';
    } else {
      route = '/logINPage';
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset('assets/fairgroup_logo.jpg'),
            ],
          ),
        ),
      ),
    );
  }
}
