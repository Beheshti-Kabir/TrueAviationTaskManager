// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers

//import 'dart:ffi';
//import 'dart:ui';
import 'package:true_aviation_task/assignTask.dart';
import 'package:true_aviation_task/changePassword.dart';
import 'package:true_aviation_task/checkAvalability.dart';
import 'package:true_aviation_task/createNewUser.dart';
import 'package:true_aviation_task/lobby.dart';
import 'package:true_aviation_task/calender.dart';
import 'package:true_aviation_task/subTaskDetails.dart';
import 'package:true_aviation_task/todaysTasks.dart';
import 'package:true_aviation_task/allTasks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

import 'package:flutter/material.dart';
import 'api_service.dart';
import 'controller.dart';

void main() => runApp(MyApp());

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
        '/lobby':(BuildContext context) => LobbyPage(),
        '/changePassword':(BuildContext context) => ChangePasswordPage(),
        '/createNewUser':(BuildContext context) => CreateNewUserPage(),
        '/calender':(BuildContext context) => CalenderPage(),
        '/todaysTasks':(BuildContext context) => TodaysTasks(),
        '/allTasks':(BuildContext context) => AllTasks(),
        '/assignTask':(BuildContext context) => AssignTask(),
        '/checkAvalability':(BuildContext context) => CheckAvailabilityPage(),
        '/subTaskPage':(BuildContext context) => SubTasksPage()
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
  final _employIDController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _employIDValidate = false;
  bool _passwordValidate = false;
  //logInValidator(){}

  bool formValidator() {
    String employID = _employIDController.text;
    String password = _passwordController.text;
    setState(() {
      if (employID == null || employID.isEmpty) {
        _employIDValidate = true;
      } else {
        _employIDValidate = false;
      }
      if (password == null || password.isEmpty) {
        _passwordValidate = true;
      } else {
        _passwordValidate = false;
      }
    });
    if (!_employIDValidate && !_passwordValidate) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white10,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(15.0, 150.0, 0.0, 0.0),
                    child: Text(
                      'True',
                      style: GoogleFonts.mcLaren(
                          color: Colors.green[600],
                          fontSize: 60,
                          
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  // Container(
                  //   padding: EdgeInsets.fromLTRB(15.0, 175.0, 0.0, 0.0),
                  //   child: Text(
                  //     'Graph',
                  //     style: GoogleFonts.mcLaren(
                  //         color: Colors.blue[800],
                  //         fontSize: 80,
                  //         fontWeight: FontWeight.bold),
                  //   ),
                  // ),
      
                  Container(
                    padding: EdgeInsets.fromLTRB(20.0, 215.0, 0.0, 0.0),
                    child: Text(
                      'Aviation',
                      style: GoogleFonts.mcLaren(
                          color: Colors.green[200],
                          fontSize: 60,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(20.0, 310.0, 0.0, 0.0),
                    child: Text(
                      'Task',
                      style: GoogleFonts.mcLaren(
                          color: Colors.green[200],
                          fontSize: 45,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(20.0, 350.0, 0.0, 0.0),
                    child: Text(
                      'Manager',
                      style: GoogleFonts.mcLaren(
                          color: Colors.green[200],
                          fontSize: 45,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 105,),
            Padding(
              padding: const EdgeInsets.only(left: 10.0,right: 10.0),
              child: Container(
                padding: EdgeInsets.only(left:5.0),
                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Color.fromARGB(255, 135, 230, 138),
                                    width: 3.0,
                                  ),
                                  borderRadius: BorderRadius.circular(10)),
                
                  child:
                      TextField(
                        controller: _employIDController,
                        style: GoogleFonts.mcLaren(color: Colors.green[100]),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          errorText:
                              _employIDValidate ? 'Value Can\'t Be Empty' : null,
                          
                          // hintText: "EmployID",
                          // hintStyle: GoogleFonts.mcLaren(color: Colors.green[100]),
                          labelText: 'EmployID :',
                          labelStyle: GoogleFonts.mcLaren(
                              fontWeight: FontWeight.bold, color: Colors.green[100]),
                          
                        ),
                      )
                    
                ),
            ),
            
            
            SizedBox(height: 10.0,),
               Padding(
              padding: const EdgeInsets.only(left: 10.0,right: 10.0),
              child: Container(
                padding: EdgeInsets.only(left:5.0),
                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.green,
                                    width: 3.0,
                                  ),
                                  borderRadius: BorderRadius.circular(10)),
                  child:
                    TextField(
                      controller: _passwordController,
                      style: GoogleFonts.mcLaren(color: Colors.green[100]),
                      decoration: InputDecoration(
                         border: InputBorder.none,
                        errorText:
                            _passwordValidate ? 'Value Can\'t Be Empty' : null,
                        labelText: 'Password : ',
                        labelStyle: GoogleFonts.mcLaren(
                            fontWeight: FontWeight.bold, color: Colors.green[100]),
                        
                      ),
                      obscureText: true,
                    )
                  ,),
                
              
            ),
            SizedBox(height: 40.0),
            Container(
              child: Center(
                child: GestureDetector(
                  onTap: () async {
                    Fluttertoast.showToast(
                        msg: "Loging In..",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.TOP,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.green[100],
                        fontSize: 16.0);
                        Navigator.of(context).pushNamed('/lobby');
                    bool isValid = formValidator();
                    print(_employIDController.text);
                    print(_passwordController.text);
                    if (isValid) {
                      var model = LogInRequest(
                          password: _passwordController.text,
                          employID: _employIDController.text);
                      var response = await ApiService.login(model);
                      print(response.accessToken);
                      if (response.result.toLowerCase().trim() == 'success') {
                        if (_employIDController.toString() == 'room1') {
                          Fluttertoast.showToast(
                            msg: "Logging In To Meeting Room 1",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.TOP,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.green[100],
                            fontSize: 16.0);
                          Navigator.of(context).pushNamed('/room1');
                        } else if (_employIDController.toString() == 'room2') {
                          Fluttertoast.showToast(
                            msg: "Logging In To Meeting Room 2",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.TOP,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.green[100],
                            fontSize: 16.0);
                          Navigator.of(context).pushNamed('/room2');
                        } else if (_employIDController.toString() == 'room3') {
                          Fluttertoast.showToast(
                            msg: "Logging In To Meeting Room 3",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.TOP,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.green[100],
                            fontSize: 16.0);
                          Navigator.of(context).pushNamed('/room3');
                        } else {
                          Navigator.of(context).pushNamed('/lobby');
                        }
      
                        
                      } else {
                        Fluttertoast.showToast(
                            msg: "Wrong UserID or Password",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.TOP,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.green[100],
                            fontSize: 16.0);
                      }
                    }
      
                    
                  },
                  child: Container(
                    height: 40.0,
                    width: 150.0,
                    child: Material(
                      borderRadius: BorderRadius.circular(20.0),
                      //shadowColor: Colors.lightGreenAccent,
                      color: Colors.green[900],
                      elevation: 7.0,
                      child: Center(
                        child: Text(
                          "Log In",
                          style: GoogleFonts.mcLaren(
                              color: Colors.green[100], fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20,)
          ],
        ),
      ),
    );
  }
}
