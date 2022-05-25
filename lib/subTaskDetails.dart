import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:true_aviation_task/constants.dart';

import 'package:true_aviation_task/modelSubTasks.dart';
import 'package:true_aviation_task/utils/session_maneger.dart';

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

class SubTasksPage extends StatefulWidget {
  const SubTasksPage({Key? key}) : super(key: key);

  @override
  _SubTasksPageState createState() => _SubTasksPageState();
}

class _SubTasksPageState extends State<SubTasksPage> {
  @override
  initState() {
    super.initState();
    //getProduct();
  }

  final _subTaskController = TextEditingController();

  var count = 0;
  late var produtcListJSON;
  late var productListNumber;

  String subTask = '';
  String _taskTimeController = '';
  String _taskDateController = '';

  List<Todo2> detailsTable = [];
  var icnSize = 18.0;
  var dropColor = Colors.blue;
  List<String> subTaskList = [''];

  late Todo2 detailsModel;

  bool _taskTimeValidate = false;
  bool _taskDateValidate = false;
  bool _subTaskValidate = false;
  var taskTime = '';
  var taskDate = '';
  bool isLoad = true;
  String taskID = '';

  void clearController() {
    _subTaskController.clear();
    _taskTimeController = '';
    _taskDateController = '';
  }

  formValidator() {
    String subTaskValidation = _subTaskController.text;
    String taskDateValidation = _taskDateController.toString();
    String taskTimeValidation = _taskTimeController.toString();
    setState(() {
      if (subTaskValidation == null || subTaskValidation.isEmpty) {
        _subTaskValidate = true;
      } else {
        _subTaskValidate = false;
      }
      if (taskTimeValidation == null || taskTimeValidation.isEmpty) {
        _taskTimeValidate = true;
      } else {
        _taskTimeValidate = false;
      }
      if (taskDateValidation == null || taskDateValidation.isEmpty) {
        _taskDateValidate = true;
      } else {
        _taskDateValidate = false;
      }
    });
    if (!_subTaskValidate && !_taskDateValidate && !_taskTimeValidate) {
      return true;
    } else {
      return false;
    }
  }

  saveSubTaskData() async {
    if (isLoad) {
      bool isValid = formValidator();
      if (isValid) {
        print('isvalid from formdata');
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

        subTask = _subTaskController.text;
        taskTime = _taskTimeController.toString();
        taskDate = _taskDateController.toString();

        var response = await createAlbum();

        if (response.trim() == '200') {
          Fluttertoast.showToast(
              msg: "Saving Sub Task..",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.lightGreenAccent,
              textColor: Colors.white,
              fontSize: 16.0);
          detailsModel =
              Todo2(subTasks: subTask, time: taskTime, date: taskDate);
          detailsTable.add(detailsModel);
          clearController();
          setState(() {});
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

  Future<String> createAlbum() async {
    print('inhttp');
    String token = await getLocalToken();
    var response = await http.post(
        //Uri.parse('https://10.100.17.234/FairEx/api/v1/meet/sub-task'),
        Uri.parse('https://trueaviation.aero/FairEx/api/v1/meet/sub-task'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': token
        },
        body: jsonEncode(<String, String>{
          //'new_lead_transaction': jsonEncode(<String, String>{
          'task_id': taskID,
          'title': subTask,
          'time': taskTime,
          'status': '0',
          'date': taskDate
          //'newPassword': newPassword
        }
            // ),}

            ));
    print(json.decode(response.body));
    var responsee = json.decode(response.body)['success'];
    if (response.statusCode == 200) {
      return json.decode(response.body)['success'].toString();
    } else {
      return 'Server issues';
    }
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments as String;
    taskID = arguments;
    setState(() {
      //count = arguments;
    });
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white10,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Giving Sub Tasks',
                    style: GoogleFonts.mcLaren(
                      fontSize: 35.0,
                      color: Colors.lightGreen[100],
                      fontWeight: FontWeight.bold,
                    ),
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
                    controller: _subTaskController,
                    style: GoogleFonts.mcLaren(color: Colors.lightGreen[100]),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      errorText:
                          _subTaskValidate ? 'Value Can\'t Be Empty' : null,
                      labelText: 'Sub Task Title* : ',
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
                        var taskDateDay = date.day.toInt() < 10
                            ? '0' + date.day.toString()
                            : date.day.toString();
                        var taskDateMonth = date.month.toInt() < 10
                            ? '0' + date.month.toString()
                            : date.month.toString();
                        setState(() {
                          _taskDateController = date.year.toString() +
                              '-' +
                              taskDateMonth.toString() +
                              '-' +
                              taskDateDay.toString();
                        });
                      }, currentTime: DateTime.now());
                    },
                    child: Text(
                      "Sub Task Date* : $_taskDateController",
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
                      DatePicker.showTimePicker(context, showTitleActions: true,
                          //     onChanged: (date) {
                          //   print('change $date in time zone ' +
                          //       date.timeZoneOffset.inHours.toString());
                          // },
                          onConfirm: (date) {
                        print('confirm meating date $date');
                        taskTime = date.toString();

                        var startTimeMinute = date.minute.toInt() < 10
                            ? '0' + date.minute.toString()
                            : date.minute.toString();
                        // var antiPost = date.hour.toInt() < 12 ? 'AM' : 'PM';
                        // var startTimeHour = date.hour.toInt() > 12
                        //     ? (date.hour - 12).toString()
                        //     : date.hour.toString();

                        setState(() {
                          _taskTimeController = date.hour.toString() +
                              ':' +
                              startTimeMinute.toString();
                        });
                      }, currentTime: DateTime.now());
                    },
                    child: Text(
                      "Sub Task Time* : $_taskTimeController",
                      style: GoogleFonts.mcLaren(
                          fontSize: 17,
                          color: Colors.lightGreen[100],
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  alignment: Alignment.topLeft,
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 0.0, left: 20.0, right: 20.0),
                    child: GestureDetector(
                      onTap: () {
                        //bool isValid = formValidator();
                        //if (isValid) {
                        count += 1;
                        subTask = _subTaskController.text;
                        taskTime = _taskTimeController.toString();
                        taskDate = _taskDateController.toString();
                        print(subTask + ' => ' + taskTime);

                        saveSubTaskData();
                        isLoad = true;
                        //}
                      },
                      child: Container(
                        height: 30.0,
                        width: 80.0,
                        child: Material(
                          borderRadius: BorderRadius.circular(20.0),
                          //// shadowColor: Colors.lightGreen[600],
                          color: Colors.green[800],
                          elevation: 7.0,
                          child: Center(
                            child: Text(
                              "Add Task",
                              style: GoogleFonts.mcLaren(
                                  color: Colors.lightGreen[100],
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 0.0, left: 20.0, right: 20.0),
                    child: GestureDetector(
                      onTap: () {
                        saveSubTaskData();
                        Navigator.of(context).pushNamed('/lobby');
                      },
                      child: Container(
                        height: 30.0,
                        width: 80.0,
                        child: Material(
                          borderRadius: BorderRadius.circular(20.0),
                          // shadowColor: Colors.lightGreen[600],
                          color: Colors.green[800],
                          elevation: 7.0,
                          child: Center(
                            child: Text(
                              "Done",
                              style: GoogleFonts.mcLaren(
                                  color: Colors.lightGreen[100],
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 35.0),
              Padding(
                padding: const EdgeInsets.only(
                    top: 15.0, left: 15.0, right: 15.0, bottom: 0.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Sl No',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.mcLaren(
                            fontWeight: FontWeight.bold,
                            color: Colors.lightGreen[100]),
                      ),
                      flex: 1,
                    ),
                    Expanded(
                      child: Text(
                        'Sub Tasks',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.mcLaren(
                            fontWeight: FontWeight.bold,
                            color: Colors.lightGreen[100]),
                      ),
                      flex: 1,
                    ),
                    Expanded(
                      child: Text(
                        'Date',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.mcLaren(
                            fontWeight: FontWeight.bold,
                            color: Colors.lightGreen[100]),
                      ),
                      flex: 1,
                    ),
                    Expanded(
                      child: Text(
                        'Time',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.mcLaren(
                            fontWeight: FontWeight.bold,
                            color: Colors.lightGreen[100]),
                      ),
                      flex: 1,
                    ),
                  ],
                ),
              ),
              ListView.builder(
                  itemCount: detailsTable.length,
                  //scrollDirection: ScrollController:,
                  primary: false,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    var model = detailsTable[index];
                    return Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              (index + 1).toString(),
                              textAlign: TextAlign.center,
                              style: GoogleFonts.mcLaren(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.lightGreen[100]),
                            ),
                            flex: 1,
                          ),
                          Expanded(
                            child: Text(
                              model.subTasks.toString(),
                              textAlign: TextAlign.center,
                              style: GoogleFonts.mcLaren(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.lightGreen[100]),
                            ),
                            flex: 1,
                          ),
                          Expanded(
                            child: Text(
                              model.date.toString(),
                              textAlign: TextAlign.center,
                              style: GoogleFonts.mcLaren(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.lightGreen[100]),
                            ),
                            flex: 1,
                          ),
                          Expanded(
                            child: Text(
                              model.time.toString(),
                              textAlign: TextAlign.center,
                              style: GoogleFonts.mcLaren(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.lightGreen[100]),
                            ),
                            flex: 1,
                          ),
                        ],
                      ),
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }
}
