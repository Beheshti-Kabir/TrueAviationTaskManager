// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers

//import 'dart:ffi';
//import 'dart:ui';
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:true_aviation_task/assignTask.dart';
import 'package:true_aviation_task/changePassword.dart';
import 'package:true_aviation_task/constants.dart';
import 'package:true_aviation_task/createNewUser.dart';
import 'package:true_aviation_task/justSubTaskAdd.dart';
import 'package:true_aviation_task/adminLobby.dart';
import 'package:true_aviation_task/adminCalender.dart';
import 'package:true_aviation_task/logInPage.dart';
import 'package:true_aviation_task/resetPassword.dart';
import 'package:true_aviation_task/subTaskDetails.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:true_aviation_task/adminTask.dart';
import 'package:true_aviation_task/upgradePage.dart';
import 'package:true_aviation_task/userCalender.dart';
import 'package:true_aviation_task/userLobby.dart';
import 'package:true_aviation_task/userTask.dart';
import 'package:true_aviation_task/utils/session_maneger.dart';
import 'package:url_launcher/url_launcher.dart';

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
        '/adminCalender': (BuildContext context) => AdminCalenderPage(),
        '/userCalender': (BuildContext context) => UserCalenderPage(),
        '/assignTask': (BuildContext context) => AssignTask(),
        '/subTaskPage': (BuildContext context) => SubTasksPage(),
        '/justSubTaskPage': (BuildContext context) => JustSubTasksPage(),
        '/logINPage': (BuildContext context) => LogInPage(),
        '/resetPassword': (BuildContext context) => ResetPasswordPage(),
        '/adminTask': (BuildContext context) => AdminTaskViewPage(),
        '/userTask': (BuildContext context) => UserTaskViewPage(),
        '/upgradePage': (BuildContext context) => UpgradePage(),
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
    // Timer(Duration(seconds: 3),
    //     () =>
    //      Navigator.of(context).pushReplacementNamed(route));
  }

  getVersion() async {
    final response = await http.get(
      Uri.parse('https://trueaviation.aero/FairEx/api/v1/meet/virsion'),
      //Uri.parse('http://10.100.18.167:8090/rbd/leadInfoApi/getProductList'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );
    var versionJSON = jsonDecode(response.body);
    print(response.statusCode.toString());

    String version = versionJSON['virsion'].toString();
    String versionCount = versionJSON['versionCount'].toString();
    Constants.upgradeURL = versionJSON['url'].toString();

    print(version.toString());

    if (response.statusCode.toString() == '200') {
      if (version != Constants.version) {
        Navigator.of(context).pushReplacementNamed('/upgradePage');
      } else {
        Navigator.of(context).pushReplacementNamed(route);
      }
    } else {
      Fluttertoast.showToast(
          msg: "You Don\'t Have Internet Connection",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.lightGreenAccent,
          textColor: Colors.white,
          fontSize: 16.0);
    }

    ///logic for version check & create url for the upgrade throw play store
    ///pop up for no internet connection
    ///pop up for upgrade
  }

  getRoutePath() async {
    bool logINStatus = await getLocalLoginStatus();
    print('status=> ' + logINStatus.toString());
    String userType = await getLocalUserTpe();
    print('type=> ' + userType);
    Constants.name = await getLocalUserName();
    if (logINStatus) {
      if (userType == 'admin') {
        route = '/lobby';
      } else {
        route = '/userLobby';
      }
    } else {
      route = '/logINPage';
    }
    await getVersion();
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
