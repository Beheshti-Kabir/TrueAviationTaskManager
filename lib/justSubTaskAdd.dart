import 'dart:async';
import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
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

class JustSubTasksPage extends StatefulWidget {
  const JustSubTasksPage({Key? key}) : super(key: key);

  @override
  _JustSubTasksPageState createState() => _JustSubTasksPageState();
}

class _JustSubTasksPageState extends State<JustSubTasksPage> {
  @override
  initState() {
    super.initState();
    getData();
  }

  final _subTaskController = TextEditingController();

  var count = 0;
  late var taskJSON;
  late var response;

  String subTask = '';
  String _taskTimeController = '';

  List<Todo2> detailsTable = [];
  var icnSize = 18.0;
  var dropColor = Colors.blue;
  List<String> subTaskList = [''];
  List<String> taskTitleList = [''];

  late Todo2 detailsModel;

  bool _quantityValidate = false;
  bool _subTaskValidate = false;
  bool _taskValidate = false;
  var taskTime = '';
  bool isLoad = true;
  //String _task = '';

  final _task = TextEditingController();
  String id = '';

  void clearController() {
    _subTaskController.clear();
    _taskTimeController = '';
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
    subTaskList = [''];
    taskTitleList = [''];
    String token = await getLocalToken();

    print('Inside Get Data');
    response = await http.get(
      //Uri.parse('https://10.100.17.234/FairEx/api/v1/meet/task'),
      Uri.parse('https://trueaviation.aero/FairEx/api/v1/meet/task'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': token
      },
    );
    taskJSON = jsonDecode(response.body);
    print(taskJSON[0].toString());

    int taskNumber = taskJSON.length;

    for (int i = 0; i < taskNumber; i++) {
      String middle = taskJSON[i]['id'].toString() +
          '-' +
          taskJSON[i]['title'].toString() +
          '( ' +
          taskJSON[i]['time'].toString() +
          ' )';

      taskTitleList.add(middle);
    }
    print(taskTitleList);

    // room1 = jsonDecode(response.body)['room1'];
    // room2 = jsonDecode(response.body)['room2'];
    // room3 = jsonDecode(response.body)['room3'];
    //print(statusValue[0]['customerName'].toString());
  }

  formValidator() {
    String subTaskValidation = _subTaskController.text;
    String taskValidation = _task.text;
    setState(() {
      if (subTaskValidation == null || subTaskValidation.isEmpty) {
        _subTaskValidate = true;
      } else {
        _subTaskValidate = false;
      }
      if (taskValidation == null || taskValidation.isEmpty) {
        _taskValidate = true;
      } else {
        _taskValidate = false;
      }
    });
    if (!_subTaskValidate && !_taskValidate) {
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
          detailsModel = Todo2(subTasks: subTask, time: taskTime);
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
    print('object' + id);
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
          'task_id': id,
          'title': subTask,
          'time': taskTime,
          'status': '0'
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
                  child:
                      // Container(
                      //   padding: EdgeInsets.only(left: 5.0),
                      //   decoration: BoxDecoration(
                      //       border: Border.all(
                      //         color: Colors.lightGreenAccent,
                      //         width: 3.0,
                      //       ),
                      //       borderRadius: BorderRadius.circular(10)),
                      //   child: DropdownButtonHideUnderline(
                      //     child: DropdownButton2(
                      //       hint: Text(
                      //         'Task ID & Title* : ',
                      //         style: GoogleFonts.mcLaren(
                      //             color: Colors.lightGreen[100],
                      //             fontWeight: FontWeight.bold),
                      //       ),
                      //       items: taskTitleList
                      //           .map((item) => DropdownMenuItem<String>(
                      //                 value: item,
                      //                 child: Text(
                      //                   'Task ID & Title : ' + item,
                      //                   style: GoogleFonts.mcLaren(
                      //                       color: Colors.lightGreen[100],
                      //                       fontWeight: FontWeight.bold),
                      //                 ),
                      //               ))
                      //           .toList(),
                      //       value: _task,
                      //       onChanged: (value) {
                      //         setState(() {
                      //           _task = value as String;
                      //         });
                      //       },
                      //       buttonHeight: 50,
                      //       buttonWidth: MediaQuery.of(context).size.width - 20,
                      //       itemHeight: 50,
                      //       dropdownDecoration: BoxDecoration(
                      //         borderRadius: BorderRadius.circular(20),
                      //         color: Colors.lightGreen,
                      //       ),
                      //     ),
                      //   ),
                      // ),

                      Container(
                    padding: const EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.lightGreenAccent,
                          width: 3.0,
                        ),
                        borderRadius: BorderRadius.circular(10)),
                    child: TypeAheadFormField(
                      suggestionsCallback: (pattern) => taskTitleList.where(
                        (item) => item.toLowerCase().contains(
                              pattern.toLowerCase(),
                            ),
                      ),
                      itemBuilder: (_, String item) => ListTile(
                        title: Text(
                          item,
                          style: GoogleFonts.mcLaren(
                              fontSize: 17,
                              color: Colors.lightGreen[900],
                              fontWeight: FontWeight.normal),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                      onSuggestionSelected: (String val) {
                        this._task.text = val;
                        setState(() {
                          //  / id = _task.toString().split('-')[0];
                        });
                      },
                      getImmediateSuggestions: true,
                      hideSuggestionsOnKeyboardHide: false,
                      hideOnEmpty: false,
                      noItemsFoundBuilder: (context) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'No Suggestion',
                          style: GoogleFonts.mcLaren(
                              fontSize: 17,
                              color: Colors.lightGreen[100],
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      textFieldConfiguration: TextFieldConfiguration(
                        style:
                            GoogleFonts.mcLaren(color: Colors.lightGreen[100]),
                        decoration: InputDecoration(
                          fillColor: Colors.white12,
                          errorText:
                              _taskValidate ? 'Value Can\'t Be Empty' : null,
                          hintText: 'Type',
                          hintStyle: GoogleFonts.mcLaren(
                              fontSize: 15,
                              color: Colors.lightGreen[100],
                              fontWeight: FontWeight.normal),
                          labelText: 'Task ID & Title*',
                          labelStyle: GoogleFonts.mcLaren(
                              fontSize: 17,
                              color: Colors.lightGreen[100],
                              fontWeight: FontWeight.bold),
                        ),
                        controller: this._task,
                      ),
                    ),
                  )),
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
                      labelText: 'Sub Task* : ',
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
                        var antiPost = date.hour.toInt() < 12 ? 'AM' : 'PM';
                        var startTimeHour = date.hour.toInt() > 12
                            ? (date.hour - 12).toString()
                            : date.hour.toString();

                        setState(() {
                          _taskTimeController = startTimeHour.toString() +
                              ':' +
                              startTimeMinute.toString() +
                              ' ' +
                              antiPost;
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
                        id = _task.text.toString().split('-')[0];
                        print('print from pressing ' + id);
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
                          // shadowColor: Colors.lightGreen[600],
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
                        if (_subTaskController.text == '') {
                          Navigator.of(context).pushNamed('/lobby');
                        } else {
                          count += 1;
                          subTask = _subTaskController.text;
                          taskTime = _taskTimeController.toString();
                          id = _task.text.toString().split('-')[0];

                          print(subTask + ' => ' + taskTime);

                          saveSubTaskData();
                          Navigator.of(context).pushNamed('/lobby');
                        }
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
