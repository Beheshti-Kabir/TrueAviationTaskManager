// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers

//import 'dart:ffi';
//import 'dart:ui';
import 'dart:async';
import 'dart:io';

import 'package:true_aviation_task/assignTask.dart';
import 'package:true_aviation_task/changePassword.dart';
import 'package:true_aviation_task/createNewUser.dart';
import 'package:true_aviation_task/justSubTaskAdd.dart';
import 'package:true_aviation_task/adminLobby.dart';
import 'package:true_aviation_task/calender.dart';
import 'package:true_aviation_task/logInPage.dart';
import 'package:true_aviation_task/resetPassword.dart';
import 'package:true_aviation_task/subTaskDetails.dart';

import 'package:flutter/material.dart';
import 'package:true_aviation_task/userLobby.dart';
import 'package:true_aviation_task/utils/session_maneger.dart';

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
        '/userLobby': (BuildContext context) => UserLobbyPage(),
        '/changePassword': (BuildContext context) => ChangePasswordPage(),
        '/createNewUser': (BuildContext context) => CreateNewUserPage(),
        '/calender': (BuildContext context) => CalenderPage(),
        '/assignTask': (BuildContext context) => AssignTask(),
        '/subTaskPage': (BuildContext context) => SubTasksPage(),
        '/justSubTaskPage': (BuildContext context) => JustSubTasksPage(),
        '/logINPage': (BuildContext context) => LogInPage(),
        '/resetPassword': (BuildContext context) => ResetPasswordPage()
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
    bool logINStatus = await getLocalLoginStatus();
    print('status=> ' + logINStatus.toString());
    String userType = await getLocalUserTpe();
    print('type=> ' + userType);
    if (logINStatus) {
      if (userType == 'admin') {
        route = '/lobby';
      } else {
        route = '/userLobby';
      }
    } else {
      route = '/logINPage';
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset('asset/trueAviationWhiteJPG.jpg'),
            ],
          ),
        ),
      ),
    );
  }
}
