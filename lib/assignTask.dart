import 'dart:convert';
import 'dart:ui';

import 'package:true_aviation_task/constants.dart';
import 'package:true_aviation_task/main.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:true_aviation_task/modelSubTasks.dart';

class CustomPicker extends CommonPickerModel {
  String digits(int value, int length) {
    return '$value'.padLeft(length, "0");
  }

  CustomPicker({DateTime? currentTime, LocaleType? locale})
      : super(locale: locale) {
    this.currentTime = currentTime ?? DateTime.now();
    this.setLeftIndex(this.currentTime.hour);
    this.setMiddleIndex(this.currentTime.minute);
    this.setRightIndex(this.currentTime.second);
  }

  @override
  String? leftStringAtIndex(int index) {
    if (index >= 0 && index < 24) {
      return this.digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String? middleStringAtIndex(int index) {
    if (index >= 0 && index < 60) {
      return this.digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String? rightStringAtIndex(int index) {
    if (index >= 0 && index < 60) {
      return this.digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String leftDivider() {
    return "|";
  }

  @override
  String rightDivider() {
    return "|";
  }

  @override
  List<int> layoutProportions() {
    return [1, 2, 1];
  }

  @override
  DateTime finalTime() {
    return currentTime.isUtc
        ? DateTime.utc(
            currentTime.year,
            currentTime.month,
            currentTime.day,
            this.currentLeftIndex(),
            this.currentMiddleIndex(),
            this.currentRightIndex())
        : DateTime(
            currentTime.year,
            currentTime.month,
            currentTime.day,
            this.currentLeftIndex(),
            this.currentMiddleIndex(),
            this.currentRightIndex());
  }
}

class AssignTask extends StatefulWidget {
  @override
  _assignTask createState() {
    return _assignTask();
  }
}

class _assignTask extends State<AssignTask> {
  //@override
  final _creatorsEmployID = TextEditingController();
  final _chairedBy = TextEditingController();
  final _bookedBy = TextEditingController();
  final _agenda = TextEditingController();
  final _reNewEmployIDPassword = TextEditingController();
  final _taskTitleController = TextEditingController();

  bool _creatorsEmployIDValidate = false;
  bool _chairedByValidate = false;
  bool _bookedByValidate = false;
  bool _agendaValidate = false;
  bool _taskTitleControllerValidate = false;
  bool isLoad = true;

  var taskTitle = '';
  var taskDate = '';

  String id = '';
  String passID = '';

  // String chairedby = '';
  // String bookedBy = '';
  // String agenda = '';
  String _taskDateController = '';
  // String _startTimeController = '';
  // String _endTimeController = '';
  String antiPost = '';

  List<Todo2> detailsTable = [];

  saveTaskData(String route) async {
    if (isLoad) {
      bool isValid = formValidator();
      if (isValid) {
        Fluttertoast.showToast(
            msg: "Saving Change..",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.lightGreenAccent,
            textColor: Colors.white,
            fontSize: 16.0);

        setState(() {
          isLoad = false;
        });

        print(taskTitle + '=>' + taskDate);

        var response = await createAlbum();

        if (response.toLowerCase().trim() == '200') {
          Constants.taskID = id;
          if (route == '/subTaskPage') {
            Navigator.pushNamed(context, route, arguments: passID);
          } else {
            Navigator.of(context).pushNamed(route);
          }
        } else {
          setState(
            () {
              isLoad = true;
            },
          );
          Fluttertoast.showToast(
              msg: response,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        }

        print('MyResponse=>$response');
      }
    }
  }

  formValidator() {
    String creatorsEmployIDVal = _creatorsEmployID.toString();
    String creatorsPasswordVal = _chairedBy.toString();
    String newEmployIDVal = _bookedBy.toString();
    String newEmployIDPasswordVal = _agenda.toString();
    String reNewEmployIDPasswordVal = _reNewEmployIDPassword.toString();
    setState(() {
      if (creatorsEmployIDVal == null || creatorsEmployIDVal.isEmpty) {
        _creatorsEmployIDValidate = true;
      } else {
        _creatorsEmployIDValidate = false;
      }
      if (creatorsPasswordVal == null || creatorsPasswordVal.isEmpty) {
        _chairedByValidate = true;
      } else {
        _chairedByValidate = false;
      }
      if (newEmployIDVal == null || newEmployIDVal.isEmpty) {
        _bookedByValidate = true;
      } else {
        _bookedByValidate = false;
      }
      if (newEmployIDPasswordVal == null || newEmployIDPasswordVal.isEmpty) {
        _agendaValidate = true;
      } else {
        _agendaValidate = false;
      }
      // if (reNewEmployIDPasswordVal == null ||
      //     reNewEmployIDPasswordVal.isEmpty) {
      //   _reNewEmployIDPasswordValidate = true;
      // } else {
      //   _reNewEmployIDPasswordValidate = false;
      // }
      // if (meetDate == null || taskDate.isEmpty) {
      //   _meetDateVaidate = true;
      // } else {
      //   _meetDateVaidate = false;
      // }
    });
    if (!_creatorsEmployIDValidate &&
        !_chairedByValidate &&
        !_bookedByValidate &&
        !_agendaValidate &&
        !_taskTitleControllerValidate) {
      return true;
    } else {
      return false;
    }
  }

  Future<String> createAlbum() async {
    taskDate = _taskDateController.toString();
    taskTitle = _taskTitleController.text;
    print('task =>' + taskTitle);
    print('taskdate =>' + taskDate);
    var response = await http.post(
        Uri.parse('https://10.100.17.47/FairEx/api/v1/meet/task'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczpcL1wvMTAuMTAwLjE3LjQ3XC9GYWlyRXhcL2FwaVwvdjFcL2FkbWluXC9sb2dpbiIsImlhdCI6MTY0ODQ2MjY4NywibmJmIjoxNjQ4NDYyNjg3LCJqdGkiOiI0OVk1OEN5dkhrbUxsc25XIiwic3ViIjoyLCJwcnYiOiJkZjg4M2RiOTdiZDA1ZWY4ZmY4NTA4MmQ2ODZjNDVlODMyZTU5M2E5In0.7pmt6Tjglssmuf_qMMggA8NvLG4x1rTU0GfyjcXVp0w'
        },
        body: jsonEncode(<String, String>{
          'title': taskTitle,
          'time': taskDate
          //'newPassword': newPassword
        }
            // ),}

            ));
    //var responsee = json.decode(response.body)['success'];
    //print('status Code =' + responsee.toString());
    // //id = json.decode(response.body)['task']['id'];
    // print(json.decode(response.body)['task']['id'].toString());
    Constants.taskID = json.decode(response.body)['task']['id'].toString();
    passID = json.decode(response.body)['task']['id'].toString();
    if (response.statusCode == 200) {
      print(json.decode(response.body).toString());

      return json.decode(response.body)['success'].toString();
    } else {
      return 'Server issues';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white10,
      // appBar: AppBar(
      //   title: const Text('Change Password'),
      // ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Text(
                  'Assigning A Task',
                  style: GoogleFonts.mcLaren(
                    fontSize: 35.0,
                    color: Colors.lightGreen[100],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                alignment: Alignment.center,
                color: Colors.green,
                height: 100.0,
                width: MediaQuery.of(context).size.width,
              ),
              SizedBox(
                height: 50.0,
              ),
              // GestureDetector(
              //   onTap: () async{
              //       Navigator.of(context).pushNamed('/checkAvalability');
              //   },
              //   child: Padding(
              //   padding: const EdgeInsets.all(15.0),
              //   child: Container(
              //     child: Text(
              //       'Check Meeting Scedule',
              //       style: GoogleFonts.mcLaren(
              //         fontSize: 20.0,
              //         color: Colors.lightGreen[100],
              //         fontWeight: FontWeight.bold,
              //       ),
              //     ),
              //     alignment: Alignment.center,
              //     color: Colors.lightGreen,
              //     height: 50.0,
              //     width: MediaQuery.of(context).size.width-20,
              //   ),
              // ),
              // ),

              Padding(
                padding:
                    const EdgeInsets.only(top: 10, left: 10.0, right: 10.0),
                child: Container(
                  padding: EdgeInsets.only(left: 5.0),
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.lightGreenAccent,
                        width: 3.0,
                      ),
                      borderRadius: BorderRadius.circular(10)),
                  child: TextField(
                    controller: _taskTitleController,
                    style: GoogleFonts.mcLaren(color: Colors.lightGreen[100]),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      errorText: _taskTitleControllerValidate
                          ? 'Value Can\'t Be Empty'
                          : null,
                      labelText: 'Task Title* : ',
                      labelStyle: GoogleFonts.mcLaren(
                          fontWeight: FontWeight.bold,
                          color: Colors.lightGreen[100]),
                    ),
                  ),
                ),
              ),

              Padding(
                padding:
                    const EdgeInsets.only(top: 10, left: 10.0, right: 10.0),
                child: Container(
                  padding: EdgeInsets.only(left: 5.0),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.lightGreenAccent,
                        width: 3.0,
                      ),
                      borderRadius: BorderRadius.circular(10)),
                  child: TextButton(
                    onPressed: () {
                      DatePicker.showDatePicker(context, showTitleActions: true,
                          //     onChanged: (date) {
                          //   print('change $date in time zone ' +
                          //       date.timeZoneOffset.inHours.toString());
                          // },
                          onConfirm: (date) {
                        print('confirm meating date $date');
                        taskDate.toString();

                        var taskDate_day = date.day.toInt() < 10
                            ? '0' + date.day.toString()
                            : date.day.toString();
                        var taskDate_month = date.month.toInt() < 10
                            ? '0' + date.month.toString()
                            : date.month.toString();

                        setState(() {
                          _taskDateController = date.year.toString() +
                              '-' +
                              taskDate_month.toString() +
                              '-' +
                              taskDate_day.toString();
                        });
                      }, currentTime: DateTime.now());
                    },
                    child: Text(
                      "Task Date* : $_taskDateController",
                      style: GoogleFonts.mcLaren(
                          fontSize: 17,
                          color: Colors.lightGreen[100],
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  alignment: Alignment.topLeft,
                ),
              ),
              // Padding(
              //   padding:
              //       const EdgeInsets.only(top: 10, left: 10.0, right: 10.0),
              //   child: Container(
              //     padding: EdgeInsets.only(left: 5.0),
              //     width: double.infinity,
              //     decoration: BoxDecoration(
              //         border: Border.all(
              //           color: Colors.lightGreenAccent,
              //           width: 3.0,
              //         ),
              //         borderRadius: BorderRadius.circular(10)),
              //     child: TextButton(
              //       onPressed: () {
              //         DatePicker.showTimePicker(context, showTitleActions: true,
              //             //     onChanged: (date) {
              //             //   print('change $date in time zone ' +
              //             //       date.timeZoneOffset.inHours.toString());
              //             // },
              //             onConfirm: (date) {
              //           print('confirm meating date $date');
              //           startTime = date.toString();
              //           var startTimeMinute = date.minute.toInt() < 10
              //               ? '0' + date.minute.toString()
              //               : date.minute.toString();
              //           var antiPost = date.hour.toInt() < 12 ? 'AM' : 'PM';
              //           var startTimeHour = date.hour.toInt() > 12
              //               ? (date.hour - 12).toString()
              //               : date.hour.toString();
              //           setState(() {
              //             _startTimeController = startTimeHour.toString() +
              //                 ':' +
              //                 startTimeMinute.toString() +
              //                 ' ' +
              //                 antiPost;
              //           });
              //         }, currentTime: DateTime.now());
              //       },
              //       child: Text(
              //         "Task Date* : $_startTimeController",
              //         style: GoogleFonts.mcLaren(
              //             fontSize: 17,
              //             color: Colors.lightGreen[100],
              //             fontWeight: FontWeight.bold),
              //       ),
              //     ),
              //     alignment: Alignment.topLeft,
              //   ),
              // ),
              // // Padding(
              //   padding: const EdgeInsets.only(top: 10, left: 10.0, right: 10.0),
              //   child: Container(
              //     padding: EdgeInsets.only(left: 5.0),
              //     width: double.infinity,
              //     decoration: BoxDecoration(
              //         border: Border.all(
              //           color: Colors.lightGreenAccent,
              //           width: 3.0,
              //         ),
              //         borderRadius: BorderRadius.circular(10)),
              //     child: TextButton(
              //       onPressed: () {
              //         DatePicker.showTimePicker(context, showTitleActions: true,
              //             //     onChanged: (date) {
              //             //   print('change $date in time zone ' +
              //             //       date.timeZoneOffset.inHours.toString());
              //             // },
              //             onConfirm: (date) {
              //           print('confirm meating date $date');
              //           endtTime = date.toString();
              //           var endTimeMinute = date.minute.toInt() < 10
              //               ? '0' + date.minute.toString()
              //               : date.minute.toString();
              //           var postAnti = date.hour.toInt() < 12 ? 'AM' : 'PM';
              //           var endTimeHour = date.hour.toInt() > 12
              //               ? (date.hour - 12).toString()
              //               : date.hour.toString();
              //           setState(() {
              //             _endTimeController = endTimeHour.toString() +
              //                 ':' +
              //                 endTimeMinute.toString() +
              //                 ' ' +
              //                 postAnti;
              //           });
              //         }, currentTime: DateTime.now());
              //       },
              //       child: Text(
              //         "End Time* : $_endTimeController",
              //         style: GoogleFonts.mcLaren(
              //             fontSize: 17,
              //             color: Colors.lightGreen[100],
              //             fontWeight: FontWeight.bold),
              //       ),
              //     ),alignment: Alignment.topLeft,
              //   ),
              // ),
              SizedBox(
                height: 20.0,
              ),
              GestureDetector(
                onTap: () async {
                  print(taskTitle + '=>' + taskDate);
                  //isLoad = true;
                  saveTaskData('/subTaskPage');
                },
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    child: Text(
                      'Add Sub Tasks',
                      style: GoogleFonts.mcLaren(
                        fontSize: 20.0,
                        color: Colors.lightGreen[100],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    alignment: Alignment.center,
                    color: Colors.lightGreen,
                    height: 50.0,
                    width: MediaQuery.of(context).size.width - 20,
                  ),
                ),
              ),

              SizedBox(height: 40.0),

              SizedBox(height: 15.0),
              // save
              Container(
                child: Center(
                  child: GestureDetector(
                    onTap: () async {
                      saveTaskData('/lobby');
                    },
                    child: Container(
                      height: 40.0,
                      width: 150.0,
                      child: Material(
                        borderRadius: BorderRadius.circular(20.0),
                        shadowColor: Colors.lightGreen[600],
                        color: Colors.green[800],
                        elevation: 7.0,
                        child: Center(
                          child: Text(
                            "Create",
                            style: GoogleFonts.mcLaren(
                                color: Colors.lightGreen[100],
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              )
            ],
          ),
        ),
      ),
    );
  }
}
