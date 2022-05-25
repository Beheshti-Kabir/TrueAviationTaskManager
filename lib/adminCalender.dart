// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers

import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:true_aviation_task/adminLobby.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:true_aviation_task/utils/session_maneger.dart';

class AdminCalenderPage extends StatefulWidget {
  @override
  _adminCalender createState() => _adminCalender();

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
    );
  }
}

class _adminCalender extends State<AdminCalenderPage> {
  CalendarFormat format = CalendarFormat.month;

  bool isLoading = false;
  bool gotData = false;

  String dateFind = DateTime.now().toString().substring(0, 10);

  var taskNumber = 0;
  late dynamic response;
  late var taskJSON;
  late String stepType = '';
  List<dynamic> taskTitle = [];
  List<dynamic> taskID = [];
  List<dynamic> taskStatus = [];

  List<dynamic> taskWiseSubtaskTitle = [];
  List<dynamic> taskWiseSubtaskTime = [];
  List<dynamic> taskWiseSubtaskStatus = [];
  List<dynamic> taskWiseSubtaskID = [];

  List<dynamic> subTaskTitleList = [];
  List<dynamic> subTaskTimeList = [];
  List<dynamic> subTaskStatusList = [];
  List<dynamic> subTaskID = [];

  String _startDateController = '';
  String _endDateController = '';

  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();
  // @override
  // initState() {
  //   super.initState();
  //   print('init');
  // }
  changeStatus(String state, String sub_task_id) async {
    String boolState = '';
    String token = await getLocalToken();
    if (state == 'Done') {
      boolState = '0';
    } else {
      boolState = '1';
    }
    //String URL = 'https://10.100.17.234/FairEx/api/v1/meet/sub-task/status/' +
    String URL =
        'https://trueaviation.aero/FairEx/api/v1/meet/sub-task/status/' +
            sub_task_id;
    response = await http.post(Uri.parse(URL),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': token,
        },
        body: jsonEncode(<String, String>{
          // 'userID': Constants.employeeId,
          'status': boolState,
        }));
    print(json.decode(response.body)['success'].toString());
    if (json.decode(response.body)['success'].toString() == '200') {
      print('sending to get data');
      getData();
      print('Leaving getdata');
      return true;
    } else {
      return false;
    }
  }

  getData() async {
    // setState(() {
    //   isLoading = true;
    //   print("isLoading");
    //   //print(json.decode(response.body)['totalLead']);
    //   //result = json.decode(response.body);
    //   //print("lead=" + json.decode(response.body)['totalLead']);
    //   // result['leadInfo'];
    // });
    bool logINStatus = await getLocalLoginStatus();
    print('status=' + logINStatus.toString());
    String userType = await getLocalUserTpe();
    print('type=> ' + userType);
    String token = await getLocalToken();
    print('token=> ' + token);
    isLoading = false;
    print('desired:' + dateFind);
    response = await http.post(
        //Uri.parse('https://10.100.17.234/FairEx/api/v1/meet/task/date'),
        Uri.parse('https://trueaviation.aero/FairEx/api/v1/meet/task/date'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': token
        },
        body: jsonEncode(<String, String>{
          // 'userID': Constants.employeeId,
          'date': dateFind,
        }));
    taskJSON = jsonDecode(response.body)['subtask'];
    //print(taskJSON[0].toString());

    taskNumber = taskJSON.length;
    taskTitle = [];
    taskID = [];
    taskStatus = [];
    subTaskTitleList = [];
    subTaskTimeList = [];
    subTaskStatusList = [];
    subTaskID = [];
    if (taskNumber == 0) {
      setState(() {
        isLoading = true;
      });
    }
    if (taskNumber > 0) {
      for (int i = 0; i < taskNumber; i++) {
        //print(taskJSON[i]['task']['title']);
        taskTitle.add(taskJSON[i]['task'][0]['title'].toString());
        taskID.add(taskJSON[i]['task'][0]['id'].toString());
        //taskStatus.add(taskJSOx`N[i]['status']);
        print(taskStatus);
        //int subTaskCount = taskJSON[i]['subtask'].length;
        subTaskTitleList.add(taskJSON[i]['title']);
        subTaskTimeList.add(taskJSON[i]['time']);
        String state = getValue(taskJSON[i]['status'].toString());
        subTaskStatusList.add(state);
        subTaskID.add(taskJSON[i]['id'].toString());
        // .add(taskWiseSubtaskTitle);
        // .add(taskWiseSubtaskTime);
        // .add(taskWiseSubtaskStatus);
        // .add(taskWiseSubtaskID);
      }
    }
    print(subTaskTitleList);
    print(subTaskTimeList);
    print(subTaskStatusList);
    print(subTaskID);

    setState(() {
      isLoading = true;
    });

    // room1 = jsonDecode(response.body)['room1'];
    // room2 = jsonDecode(response.body)['room2'];
    // room3 = jsonDecode(response.body)['room3'];
    //print(statusValue[0]['customerName'].toString());
  }

  getValue(String state) {
    if (state == '1') {
      return 'Done';
    } else {
      return 'Not Done';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!gotData) {
      getData();
      gotData = true;
    }

    return Scaffold(
      backgroundColor: Colors.white10,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Calendar',
                    style: GoogleFonts.mcLaren(
                      fontSize: 35.0,
                      color: Colors.pink[100],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                alignment: Alignment.center,
                color: Colors.pink,
                height: 100.0,
                width: MediaQuery.of(context).size.width,
              ),

              Container(
                color: Colors.pink[100],
                child: TableCalendar(
                  focusedDay: focusedDay,
                  firstDay: DateTime(1990),
                  lastDay: DateTime(2030),
                  calendarFormat: format,
                  onFormatChanged: (CalendarFormat _format) {
                    setState(() {
                      format = _format;
                    });
                  },
                  startingDayOfWeek: StartingDayOfWeek.saturday,
                  daysOfWeekVisible: true,
                  onDaySelected: (DateTime selectDay, DateTime focusDay) {
                    setState(() {
                      selectedDay = selectDay;
                      dateFind = selectedDay.toString().split(' ')[0];
                      isLoading = false;
                      getData();
                      //focusedDay = focusDay;
                    });
                    print(selectedDay);
                  },
                  calendarStyle: CalendarStyle(
                      //isTodayHighlighted: true,
                      // defaultDecoration: BoxDecoration(
                      //     color: Colors.amberAccent, shape: BoxShape.circle),
                      selectedTextStyle: TextStyle(color: Colors.red[100]),
                      selectedDecoration: BoxDecoration(
                          color: Colors.red[900], shape: BoxShape.circle),
                      todayDecoration: BoxDecoration(
                          color: Colors.red[400], shape: BoxShape.circle)),
                  headerStyle: HeaderStyle(
                      formatButtonVisible: false, titleCentered: true),
                  selectedDayPredicate: (DateTime date) {
                    return isSameDay(selectedDay, date);
                  },
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              (isLoading)
                  ? (taskNumber > 0)
                      ? Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    children: <Widget>[
                                      Text('Sub Task Title',
                                          style: GoogleFonts.mcLaren(
                                              color: Colors.pinkAccent,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    children: <Widget>[
                                      Text('Sub Task Time',
                                          style: GoogleFonts.mcLaren(
                                              color: Colors.pinkAccent,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    children: <Widget>[
                                      Text('Sub Task Status',
                                          style: GoogleFonts.mcLaren(
                                              color: Colors.pinkAccent,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            // ListView.builder(
                            //     itemCount: taskNumber,
                            //     primary: false,
                            //     shrinkWrap: true,
                            //     itemBuilder: (BuildContext context, int index) {
                            //       return Column(
                            //         children: <Widget>[
                            //           Padding(
                            //             padding: const EdgeInsets.only(
                            //                 top: 10,
                            //                 left: 10.0,
                            //                 right: 10.0,
                            //                 bottom: 10.0),
                            //             child: Container(
                            //               alignment: Alignment.center,
                            //               padding: EdgeInsets.only(
                            //                   left: 5.0, right: 5.0),
                            //               decoration: BoxDecoration(
                            //                   border: Border.all(
                            //                     color: Colors.pink,
                            //                     width: 3.0,
                            //                   ),
                            //                   borderRadius:
                            //                       BorderRadius.circular(10)),
                            //               child: Column(
                            //                 children: <Widget>[
                            //                   // Row(
                            //                   //   crossAxisAlignment:
                            //                   //       CrossAxisAlignment.center,
                            //                   //   mainAxisAlignment:
                            //                   //       MainAxisAlignment.center,
                            //                   //   children: <Widget>[
                            //                   //     Expanded(
                            //                   //       child: Text(
                            //                   //         'Task Title : ' +
                            //                   //             taskTitle[index] +
                            //                   //             ' [ ' +
                            //                   //             taskStatus[index] +
                            //                   //             ' ] ',
                            //                   //         textAlign: TextAlign.center,
                            //                   //         style: GoogleFonts.mcLaren(
                            //                   //             color: Colors.pink,
                            //                   //             fontSize: 20.0,
                            //                   //             fontWeight:
                            //                   //                 FontWeight.bold),
                            //                   //       ),
                            //                   //     ),
                            //                   //   ],
                            //                   // ),
                            //                   //
                            //                   // Row(
                            //                   //   children: [
                            //                   //     Expanded(
                            //                   //       flex: 2,
                            //                   //       child: Column(
                            //                   //         children: <Widget>[
                            //                   //           Text('Sub Task Title',
                            //                   //               style:
                            //                   //                   GoogleFonts.mcLaren(
                            //                   //                       color: Colors
                            //                   //                           .pinkAccent,
                            //                   //                       fontWeight:
                            //                   //                           FontWeight
                            //                   //                               .bold)),
                            //                   //         ],
                            //                   //       ),
                            //                   //     ),
                            //                   //     Expanded(
                            //                   //       flex: 1,
                            //                   //       child: Column(
                            //                   //         children: <Widget>[
                            //                   //           Text('Sub Task Time',
                            //                   //               style:
                            //                   //                   GoogleFonts.mcLaren(
                            //                   //                       color: Colors
                            //                   //                           .pinkAccent,
                            //                   //                       fontWeight:
                            //                   //                           FontWeight
                            //                   //                               .bold)),
                            //                   //         ],
                            //                   //       ),
                            //                   //     ),
                            //                   //     Expanded(
                            //                   //       flex: 1,
                            //                   //       child: Column(
                            //                   //         children: <Widget>[
                            //                   //           Text('Sub Task Status',
                            //                   //               style:
                            //                   //                   GoogleFonts.mcLaren(
                            //                   //                       color: Colors
                            //                   //                           .pinkAccent,
                            //                   //                       fontWeight:
                            //                   //                           FontWeight
                            //                   //                               .bold)),
                            //                   //         ],
                            //                   //       ),
                            //                   //     ),
                            //                   //   ],
                            //                   // ),
                            //                   // (subTaskTimeList[index].length > 0)
                            //                   // ? Container(
                            //                   //     padding: EdgeInsets.only(
                            //                   //         bottom: 5, top: 10.0),
                            //                   //     child:
                            //                   //     // Row(
                            //                   //     //   children: [
                            //                   //     //     Expanded(
                            //                   //     //       flex: 2,
                            //                   //     //       child: Column(
                            //                   //     //         children: <Widget>[
                            //                   //     //           Text('Sub Task Title',
                            //                   //     //               style: GoogleFonts.mcLaren(
                            //                   //     //                   color: Colors
                            //                   //     //                       .pinkAccent,
                            //                   //     //                   fontWeight:
                            //                   //     //                       FontWeight
                            //                   //     //                           .bold)),
                            //                   //     //         ],
                            //                   //     //       ),
                            //                   //     //     ),
                            //                   //     //     Expanded(
                            //                   //     //       flex: 1,
                            //                   //     //       child: Column(
                            //                   //     //         children: <Widget>[
                            //                   //     //           Text('Sub Task Time',
                            //                   //     //               style: GoogleFonts.mcLaren(
                            //                   //     //                   color: Colors
                            //                   //     //                       .pinkAccent,
                            //                   //     //                   fontWeight:
                            //                   //     //                       FontWeight
                            //                   //     //                           .bold)),
                            //                   //     //         ],
                            //                   //     //       ),
                            //                   //     //     ),
                            //                   //     //     Expanded(
                            //                   //     //       flex: 1,
                            //                   //     //       child: Column(
                            //                   //     //         children: <Widget>[
                            //                   //     //           Text(
                            //                   //     //               'Sub Task Status',
                            //                   //     //               style: GoogleFonts.mcLaren(
                            //                   //     //                   color: Colors
                            //                   //     //                       .pinkAccent,
                            //                   //     //                   fontWeight:
                            //                   //     //                       FontWeight
                            //                   //     //                           .bold)),
                            //                   //     //         ],
                            //                   //     //       ),
                            //                   //     //     ),
                            //                   //     //   ],
                            //                   //     // ),
                            //                   //   )
                            //                   // : Container(),
                            //                   // ListView.builder(
                            //                   //     itemCount:
                            //                   //         subTaskTitleList[index]
                            //                   //             .length,
                            //                   //     primary: false,
                            //                   //     shrinkWrap: true,
                            //                   //     itemBuilder:
                            //                   //         (BuildContext context,
                            //                   //             int index2) {
                            //                   //       return Container(
                            //                   //         padding: EdgeInsets.only(
                            //                   //             bottom: 2),
                            //                   //         child: Row(
                            //                   //           children: <Widget>[
                            //                   //             Expanded(
                            //                   //               flex: 2,
                            //                   //               child: Column(
                            //                   //                 children: <
                            //                   //                     Widget>[
                            //                   //                   Text(
                            //                   //                     subTaskTitleList[
                            //                   //                             index]
                            //                   //                         [index2],
                            //                   //                     style: GoogleFonts
                            //                   //                         .mcLaren(
                            //                   //                             color:
                            //                   //                                 Colors.pinkAccent),
                            //                   //                   )
                            //                   //                 ],
                            //                   //               ),
                            //                   //             ),
                            //                   //             Expanded(
                            //                   //               flex: 1,
                            //                   //               child: Column(
                            //                   //                 crossAxisAlignment:
                            //                   //                     CrossAxisAlignment
                            //                   //                         .start,
                            //                   //                 children: <
                            //                   //                     Widget>[
                            //                   //                   Text(
                            //                   //                     subTaskTimeList[
                            //                   //                             index]
                            //                   //                         [index2],
                            //                   //                     style: GoogleFonts
                            //                   //                         .mcLaren(
                            //                   //                             color:
                            //                   //                                 Colors.pinkAccent),
                            //                   //                   )
                            //                   //                 ],
                            //                   //               ),
                            //                   //             ),
                            //                   //             Expanded(
                            //                   //               flex: 1,
                            //                   //               child: Column(
                            //                   //                 children: <
                            //                   //                     Widget>[
                            //                   //                   GestureDetector(
                            //                   //                     onTap: () {
                            //                   //                       print(
                            //                   //                           'tapped');
                            //                   //                       showDialog(
                            //                   //                           context:
                            //                   //                               context,
                            //                   //                           builder: (context) =>
                            //                   //                               AlertDialog(
                            //                   //                                 // elevation:
                            //                   //                                 //     20.0,
                            //                   //                                 // backgroundColor:
                            //                   //                                 //     Colors.,
                            //                   //                                 // shape:
                            //                   //                                 //     CircleAvatar
                            //                   //                                 title: Text('Task Title: ' + taskTitle[index].toString(), style: GoogleFonts.mcLaren(color: Colors.pinkAccent, fontWeight: FontWeight.bold)),
                            //                   //                                 content: Text('Sub Task: ' + subTaskTitleList[index][index2].toString() + '\nThis Sub Task is ' + subTaskStatusList[index][index2].toString() + '\nDo you wanna change the status?', style: GoogleFonts.mcLaren(color: Colors.pinkAccent)),
                            //                   //                                 actions: <Widget>[
                            //                   //                                   TextButton(
                            //                   //                                     onPressed: () => Navigator.pop(context),
                            //                   //                                     child: Text('No', style: GoogleFonts.mcLaren(color: Colors.pink, fontWeight: FontWeight.bold)),
                            //                   //                                   ),
                            //                   //                                   TextButton(
                            //                   //                                     onPressed: () {
                            //                   //                                       changeStatus(subTaskStatusList[index][index2], subTaskID[index][index2]);
                            //                   //                                       Navigator.pop(context);
                            //                   //                                     },
                            //                   //                                     child: Text('Yes', style: GoogleFonts.mcLaren(color: Colors.pink, fontWeight: FontWeight.bold)),
                            //                   //                                   )
                            //                   //                                 ],
                            //                   //                               ));
                            //                   //                     },
                            //                   //                     child:
                            //                   //                         Container(
                            //                   //                       alignment:
                            //                   //                           Alignment
                            //                   //                               .centerLeft,
                            //                   //                       padding:
                            //                   //                           EdgeInsets
                            //                   //                               .all(5),
                            //                   //                       decoration:
                            //                   //                           BoxDecoration(
                            //                   //                               border:
                            //                   //                                   Border.all(
                            //                   //                                 color: Colors.pinkAccent,
                            //                   //                                 width: 1.0,
                            //                   //                               ),
                            //                   //                               borderRadius: BorderRadius.circular(5)),
                            //                   //                       child:
                            //                   //                           Center(
                            //                   //                         child:
                            //                   //                             Text(
                            //                   //                           subTaskStatusList[index][index2]
                            //                   //                               .toString(),
                            //                   //                           textAlign:
                            //                   //                               TextAlign.center,
                            //                   //                           style: GoogleFonts.mcLaren(
                            //                   //                               color:
                            //                   //                                   Colors.pinkAccent),
                            //                   //                         ),
                            //                   //                       ),
                            //                   //                     ),
                            //                   //                   )
                            //                   //                 ],
                            //                   //               ),
                            //                   //             ),
                            //                   //           ],
                            //                   //         ),
                            //                   //       );
                            //                   //     })
                            //                 ],
                            //               ),
                            //             ),
                            //           )
                            //         ],
                            //       );
                            //     }),
                            ListView.builder(
                                itemCount: subTaskTitleList.length,
                                primary: false,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                    padding: EdgeInsets.only(bottom: 2),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          flex: 2,
                                          child: Column(
                                            children: <Widget>[
                                              Text(
                                                subTaskTitleList[index],
                                                style: GoogleFonts.mcLaren(
                                                    color: Colors.pinkAccent),
                                              )
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Center(
                                                child: Text(
                                                  subTaskTimeList[index],
                                                  style: GoogleFonts.mcLaren(
                                                      color: Colors.pinkAccent),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Column(
                                            children: <Widget>[
                                              GestureDetector(
                                                onTap: () {
                                                  print('tapped');
                                                  showDialog(
                                                      context: context,
                                                      builder:
                                                          (context) =>
                                                              AlertDialog(
                                                                // elevation:
                                                                //     20.0,
                                                                // backgroundColor:
                                                                //     Colors.,
                                                                // shape:
                                                                //     CircleAvatar
                                                                title: Text(
                                                                    'Task Title: ' +
                                                                        taskTitle[index]
                                                                            .toString(),
                                                                    style: GoogleFonts.mcLaren(
                                                                        color: Colors
                                                                            .pinkAccent,
                                                                        fontWeight:
                                                                            FontWeight.bold)),
                                                                content: Text(
                                                                    'Sub Task: ' +
                                                                        subTaskTitleList[index]
                                                                            .toString() +
                                                                        '\nThis Sub Task is ' +
                                                                        subTaskStatusList[index]
                                                                            .toString() +
                                                                        '\nDo you wanna change the status?',
                                                                    style: GoogleFonts
                                                                        .mcLaren(
                                                                            color:
                                                                                Colors.pinkAccent)),
                                                                actions: <
                                                                    Widget>[
                                                                  TextButton(
                                                                    onPressed: () =>
                                                                        Navigator.pop(
                                                                            context),
                                                                    child: Text(
                                                                        'No',
                                                                        style: GoogleFonts.mcLaren(
                                                                            color:
                                                                                Colors.pink,
                                                                            fontWeight: FontWeight.bold)),
                                                                  ),
                                                                  TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      changeStatus(
                                                                          subTaskStatusList[
                                                                              index],
                                                                          subTaskID[
                                                                              index]);

                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    child: Text(
                                                                        'Yes',
                                                                        style: GoogleFonts.mcLaren(
                                                                            color:
                                                                                Colors.pink,
                                                                            fontWeight: FontWeight.bold)),
                                                                  )
                                                                ],
                                                              ));
                                                },
                                                child: Container(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  padding: EdgeInsets.all(5),
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color:
                                                            Colors.pinkAccent,
                                                        width: 1.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                  child: Center(
                                                    child: Text(
                                                      subTaskStatusList[index]
                                                          .toString(),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style:
                                                          GoogleFonts.mcLaren(
                                                              color: Colors
                                                                  .pinkAccent),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                })
                          ],
                        )
                      : Container(
                          padding: EdgeInsets.all(15),
                          alignment: Alignment.center,
                          child: Text(
                            'No Task',
                            style: GoogleFonts.mcLaren(
                                color: Colors.pink[400],
                                fontSize: 30,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                  // : Container(
                  //     padding: EdgeInsets.all(15),
                  //     alignment: Alignment.center,
                  //     child: Text(
                  //       'No Task',
                  //       style: GoogleFonts.mcLaren(
                  //           color: Colors.pink[400],
                  //           fontSize: 30,
                  //           fontWeight: FontWeight.bold),
                  //     ),
                  //   )
                  : Center(
                      child: CircularProgressIndicator(
                        color: Colors.pink,
                      ),
                    ),

              //if (room1.isNotEmpty)
            ],
          ),
        ),
      ),
    );
  }
}
