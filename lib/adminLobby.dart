// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers

import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_launcher_icons/ios.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:true_aviation_task/constants.dart';
import 'package:true_aviation_task/logInPage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:true_aviation_task/utils/session_maneger.dart';

class LobbyPage extends StatefulWidget {
  @override
  _lobbyPage createState() => _lobbyPage();

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{},
    );
  }

  void setState(Null Function() param0) {}
}

class _lobbyPage extends State<LobbyPage> {
  @override
  double buttonWidth = 300;
  double buttonHeight = 50;
  double textSize = 20;
  String userName = '';
  String emailID = '';

  @override
  initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    userName = Constants.name;
    emailID = await getLocalUserEmailID();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white10,

        // appBar: AppBar(
        //   backgroundColor: Colors.amber[400],
        //   title: Text('Lobby'),
        //   titleTextStyle:GoogleFonts.mcLaren(
        //     fontSize: 21,
        //     color: Colors.amberAccent[100],
        //     fontWeight: FontWeight.bold,
        //   ) ,

        // ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: Text(
                          'Lobby',
                          style: GoogleFonts.mcLaren(
                            fontSize: 35.0,
                            color: Colors.amberAccent[200],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        alignment: Alignment.center,
                        color: Colors.amber[700],
                        height: 100.0,
                        width: MediaQuery.of(context).size.width,
                      ),
                    ]),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        padding: EdgeInsets.only(top: 20),
                        child: Column(
                          children: <Widget>[
                            Text(
                              'Hi,',
                              style: GoogleFonts.mcLaren(
                                fontSize: 20.0,
                                color: Colors.amberAccent[200],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              userName,
                              style: GoogleFonts.mcLaren(
                                fontSize: 20.0,
                                color: Colors.amberAccent[200],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        )),

                    // Container(
                    //   // padding: EdgeInsets.fromLTRB(
                    //   //     (MediaQuery.of(context).size.width * 0.45) -
                    //   //         (buttonWidth / 2),
                    //   //     (MediaQuery.of(context).size.height * 0.15),
                    //   //     20.0,
                    //   //     0.0),
                    //   padding: EdgeInsets.only(top: 0),
                    //   child: GestureDetector(
                    //     onTap: () async {
                    //       const url =
                    //           'https://drive.google.com/uc?id=1tHZ1qqF1L_FImlkSccVL3pR_a4X1TSvS&export=download';
                    //       if (await canLaunch(url)) {
                    //         await launch(
                    //           url,
                    //           forceWebView: true,
                    //         );
                    //       }
                    //     },
                    //     child: Container(
                    //       height: buttonHeight,
                    //       width: buttonWidth,
                    //       child: Material(
                    //         borderRadius: BorderRadius.circular(35.0),
                    //         shadowColor: Colors.amberAccent,
                    //         color: Colors.amberAccent[700],
                    //         elevation: 7.0,
                    //         child: Center(
                    //           child: Text(
                    //             'Web',
                    //             style: GoogleFonts.mcLaren(
                    //               fontSize: textSize,
                    //               color: Colors.amber[50],
                    //               fontWeight: FontWeight.bold,
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),

                    Container(
                      // padding: EdgeInsets.fromLTRB(
                      //     (MediaQuery.of(context).size.width * 0.45) -
                      //         (buttonWidth / 2),
                      //     (MediaQuery.of(context).size.height * 0.15),
                      //     20.0,
                      //     0.0),
                      padding: EdgeInsets.only(top: 50),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed('/assignTask');
                        },
                        child: Container(
                          height: buttonHeight,
                          width: buttonWidth,
                          child: Material(
                            borderRadius: BorderRadius.circular(35.0),
                            shadowColor: Colors.amberAccent,
                            color: Colors.amberAccent[700],
                            elevation: 7.0,
                            child: Center(
                              child: Text(
                                'Assign A Task',
                                style: GoogleFonts.mcLaren(
                                  fontSize: textSize,
                                  color: Colors.amber[50],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      // padding: EdgeInsets.fromLTRB(
                      //     (MediaQuery.of(context).size.width * 0.45) -
                      //         (buttonWidth / 2),
                      //     (MediaQuery.of(context).size.height * 0.15),
                      //     20.0,
                      //     0.0),
                      padding: EdgeInsets.only(top: 20),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed('/justSubTaskPage');
                        },
                        child: Container(
                          height: buttonHeight,
                          width: buttonWidth,
                          child: Material(
                            borderRadius: BorderRadius.circular(35.0),
                            shadowColor: Colors.amberAccent,
                            color: Colors.amberAccent[700],
                            elevation: 7.0,
                            child: Center(
                              child: Text(
                                'Assign Sub-Tasks',
                                style: GoogleFonts.mcLaren(
                                  fontSize: textSize,
                                  color: Colors.amber[50],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    Container(
                      padding: EdgeInsets.only(top: 40),
                      //padding: EdgeInsets.fromLTRB(
                      // (MediaQuery.of(context).size.width * 0.45) -
                      //     (buttonWidth / 2),
                      // 40.0,
                      // 20.0,
                      // 0.0),
                      child: Stack(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed('/adminCalender');
                            },
                            child: SizedBox(
                              height: buttonHeight,
                              width: buttonWidth,
                              child: Material(
                                borderRadius: BorderRadius.circular(35.0),
                                shadowColor: Colors.amberAccent,
                                color: Colors.amberAccent[400],
                                elevation: 7.0,
                                child: Center(
                                  child: Text(
                                    'Calendar & Sub-Tasks',
                                    style: GoogleFonts.mcLaren(
                                      fontSize: textSize,
                                      color: Colors.yellow[100],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Container(
                    //   padding: EdgeInsets.fromLTRB(
                    //       (MediaQuery.of(context).size.width * 0.45) -
                    //           (buttonWidth * 0.5),
                    //       20.0,
                    //       20.0,
                    //       0.0),
                    //   child: GestureDetector(
                    //     onTap: () {
                    //       Navigator.of(context).pushNamed('/todaysTasks');
                    //     },
                    //     child: Container(
                    //       height: buttonHeight,
                    //       width: buttonWidth,
                    //       child: Material(
                    //         borderRadius: BorderRadius.circular(35.0),
                    //         shadowColor: Colors.amberAccent,
                    //         color: Colors.amberAccent[400],
                    //         elevation: 7.0,
                    //         child: Center(
                    //           child: Text(
                    //             'Today\'s Tasks',
                    //             style: GoogleFonts.mcLaren(
                    //               fontSize: textSize,
                    //               color: Colors.yellow[100],
                    //               fontWeight: FontWeight.bold,
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // Container(
                    //   padding: EdgeInsets.fromLTRB(
                    //       (MediaQuery.of(context).size.width * 0.45) -
                    //           (buttonWidth / 2),
                    //       20.0,
                    //       20.0,
                    //       0.0),
                    //   child: Stack(
                    //     children: <Widget>[
                    //       GestureDetector(
                    //         onTap: () {
                    //           Navigator.of(context).pushNamed('/allTasks');
                    //         },
                    //         child: SizedBox(
                    //           height: buttonHeight,
                    //           width: buttonWidth,
                    //           child: Material(
                    //             borderRadius: BorderRadius.circular(35.0),
                    //             shadowColor: Colors.amberAccent,
                    //             color: Colors.amberAccent[400],
                    //             elevation: 7.0,
                    //             child: Center(
                    //               child: Text(
                    //                 'All Tasks',
                    //                 style: GoogleFonts.mcLaren(
                    //                   fontSize: textSize,
                    //                   color: Colors.yellow[100],
                    //                   fontWeight: FontWeight.bold,
                    //                 ),
                    //               ),
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    Container(
                      padding: EdgeInsets.only(top: 20),
                      //padding: EdgeInsets.fromLTRB(
                      // (MediaQuery.of(context).size.width * 0.45) -
                      //     (buttonWidth / 2),
                      // 40.0,
                      // 20.0,
                      // 0.0),
                      child: Stack(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed('/adminTask');
                            },
                            child: SizedBox(
                              height: buttonHeight,
                              width: buttonWidth,
                              child: Material(
                                borderRadius: BorderRadius.circular(35.0),
                                shadowColor: Colors.amberAccent,
                                color: Colors.amberAccent[400],
                                elevation: 7.0,
                                child: Center(
                                  child: Text(
                                    'All Tasks',
                                    style: GoogleFonts.mcLaren(
                                      fontSize: textSize,
                                      color: Colors.yellow[100],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 40),
                      // padding: EdgeInsets.fromLTRB(
                      //     (MediaQuery.of(context).size.width * 0.45) -
                      //         (buttonWidth * 0.5),
                      //     40.0,
                      //     20.0,
                      //     0.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed('/createNewUser');
                        },
                        child: Container(
                          height: buttonHeight,
                          width: buttonWidth,
                          child: Material(
                            borderRadius: BorderRadius.circular(35.0),
                            shadowColor: Colors.amberAccent,
                            color: Colors.amberAccent,
                            elevation: 7.0,
                            child: Center(
                              child: Text(
                                'Create New User',
                                style: GoogleFonts.mcLaren(
                                  fontSize: textSize,
                                  color: Colors.amber[50],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      // padding: EdgeInsets.fromLTRB(
                      //     (MediaQuery.of(context).size.width * 0.45) -
                      //         (buttonWidth * 0.5),
                      //     20.0,
                      //     20.0,
                      //     0.0),
                      padding: EdgeInsets.only(top: 20),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed('/changePassword');
                        },
                        child: Container(
                          height: buttonHeight,
                          width: buttonWidth,
                          child: Material(
                            borderRadius: BorderRadius.circular(35.0),
                            shadowColor: Colors.amberAccent,
                            color: Colors.amberAccent,
                            elevation: 7.0,
                            child: Center(
                              child: Text(
                                'Change Password',
                                style: GoogleFonts.mcLaren(
                                  fontSize: textSize,
                                  color: Colors.amber[50],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      // padding: EdgeInsets.fromLTRB(
                      //     (MediaQuery.of(context).size.width * 0.45) -
                      //         (buttonWidth * 0.5),
                      //     20.0,
                      //     20.0,
                      //     0.0),
                      padding: EdgeInsets.only(top: 20),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed('/resetPassword');
                        },
                        child: Container(
                          height: buttonHeight,
                          width: buttonWidth,
                          child: Material(
                            borderRadius: BorderRadius.circular(35.0),
                            shadowColor: Colors.amberAccent,
                            color: Colors.amberAccent,
                            elevation: 7.0,
                            child: Center(
                              child: Text(
                                'Reset Password',
                                style: GoogleFonts.mcLaren(
                                  fontSize: textSize,
                                  color: Colors.amber[50],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    Container(
                      // padding: EdgeInsets.fromLTRB(
                      //     (MediaQuery.of(context).size.width * 0.45) -
                      //         (buttonWidth * 0.5),
                      //     20.0,
                      //     20.0,
                      //     0.0),
                      padding: EdgeInsets.only(top: 40),
                      child: GestureDetector(
                        onTap: () {
                          storeLocalSetAccessToken(
                              Constants.accessTokenKey, '');
                          storeLocalSetLogInStatus(
                              Constants.logInStatusKey, 'false');
                          storeLocalSetUserName(Constants.userNameKey, '');
                          storeLocalSetUserEmailID(Constants.userEmailKey, '');
                          storeLocalSetUserType(Constants.userTypeKey, '');
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => new LogInPage()),
                              (Route<dynamic> route) => false);
                        },
                        child: Container(
                          height: buttonHeight,
                          width: buttonWidth,
                          child: Material(
                            borderRadius: BorderRadius.circular(35.0),
                            shadowColor: Colors.amberAccent,
                            color: Colors.amberAccent,
                            elevation: 7.0,
                            child: Center(
                              child: Text(
                                'Log Out',
                                style: GoogleFonts.mcLaren(
                                  fontSize: textSize,
                                  color: Colors.amber[50],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
