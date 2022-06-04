import 'dart:async';
import 'dart:convert';
import 'dart:ffi';

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

bool isSearchLoading = false;
bool isStartSearch = false;

final _taskNameController = TextEditingController();
final _taskCreatedDateController = TextEditingController();
final _taskStatusController = TextEditingController();
final _taskIDController = TextEditingController();

class AdminTaskViewPage extends StatefulWidget {
  const AdminTaskViewPage({Key? key}) : super(key: key);

  @override
  _AdminTaskViewPageState createState() => _AdminTaskViewPageState();
}

class _AdminTaskViewPageState extends State<AdminTaskViewPage> {
  callBack() {
    setState(() {});
    getTaskData();
  }

  @override
  initState() {
    super.initState();
    // /getData();
  }

  final _subTaskController = TextEditingController();

  var count = 0;
  late var subTaskJSON;
  late var response;
  var taskDate = '';

  String subTask = '';
  int subTaskCount = 0;

  List<Todo2> detailsTable = [];
  var icnSize = 18.0;
  var dropColor = Colors.blue;
  List<String> subTaskTiteList = [];
  List<String> subTaskDateList = [];
  List<String> subTaskTimeList = [];
  List<String> subTaskStatusList = [];
  List<String> subTaskIDList = [];

  late Todo2 detailsModel;

  var taskTime = '';
  bool gotTaskData = false;
  //String _task = '';

  String id = '';

  getDigitalToBoolValue(String state) {
    if (state == '1') {
      return 'Done';
    } else {
      return 'Not Done';
    }
  }

  Future<bool> onPageRefresh() async {
    await getTaskData();
    print('refressh going on');
    return true;
  }

  getTaskData() async {
    subTaskTiteList = [];
    subTaskDateList = [];
    subTaskTimeList = [];
    subTaskStatusList = [];
    subTaskIDList = [];
    setState(() {
      isSearchLoading = false;
      gotTaskData = false;
    });
    String token = await getLocalToken();
    String URL_GetTaskData =
        'https://trueaviation.aero/FairEx/api/v1/meet/task/' +
            _taskIDController.text;
    print('Inside Get Data');
    response = await http.get(
      //Uri.parse('https://10.100.17.234/FairEx/api/v1/meet/task'),
      Uri.parse(URL_GetTaskData),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': token
      },
    );
    subTaskJSON = jsonDecode(response.body)['task']['subtask'];
    //print(subTaskJSON[0].toString());

    subTaskCount = subTaskJSON.length;
    print(subTaskCount.toString());

    _taskStatusController.text =
        jsonDecode(response.body)['task']['status'].toString();

    for (int i = 0; i < subTaskCount; i++) {
      //String middle = subTaskJSON[i]['title'].toString();

      subTaskTiteList.add(subTaskJSON[i]['title'].toString());
      subTaskDateList.add(subTaskJSON[i]['date'].toString());
      subTaskTimeList.add(subTaskJSON[i]['time'].toString());
      String subtaskState =
          getDigitalToBoolValue(subTaskJSON[i]['status'].toString());
      subTaskStatusList.add(subtaskState);
      subTaskIDList.add(subTaskJSON[i]['id'].toString());
    }
    print('taskTitleList');
    setState(() {
      gotTaskData = true;
      isSearchLoading = true;
    });

    // room1 = jsonDecode(response.body)['room1'];
    // room2 = jsonDecode(response.body)['room2'];
    // room3 = jsonDecode(response.body)['room3'];
    //print(statusValue[0]['customerName'].toString());
  }

  changeStatus(String state, String sub_task_id) async {
    String boolState = '';
    print('SUBTASK ID =>' + sub_task_id.toString());
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
      getTaskData();
      print('Leaving getdata');
      return true;
    } else {
      return false;
    }
  }

  // formValidator() {
  //   String subTaskValidation = _subTaskController.text;
  //   String taskValidation = _task.text;
  //   String taskDateValidation = _taskDateController.toString();
  //   String taskTimeValidation = _taskTimeController.toString();
  //   setState(() {
  //     if (subTaskValidation == null || subTaskValidation.isEmpty) {
  //       _subTaskValidate = true;
  //     } else {
  //       _subTaskValidate = false;
  //     }
  //     if (taskTimeValidation == null || taskTimeValidation.isEmpty) {
  //       _taskTimeValidate = true;
  //     } else {
  //       _taskTimeValidate = false;
  //     }
  //     if (taskDateValidation == null || taskDateValidation.isEmpty) {
  //       _taskDateValidate = true;
  //     } else {
  //       _taskDateValidate = false;
  //     }
  //     if (taskValidation == null || taskValidation.isEmpty) {
  //       _taskValidate = true;
  //     } else {
  //       _taskValidate = false;
  //     }
  //   });
  //   if (!_subTaskValidate &&
  //       !_taskValidate &&
  //       !_taskDateValidate &&
  //       !_taskTimeValidate) {
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }
  // saveSubTaskData() async {
  //   if (isLoad) {
  //     bool isValid = formValidator();
  //     if (isValid) {
  //       print('isvalid from formdata');
  //       Fluttertoast.showToast(
  //           msg: "Saving Change..",
  //           toastLength: Toast.LENGTH_SHORT,
  //           gravity: ToastGravity.TOP,
  //           timeInSecForIosWeb: 1,
  //           backgroundColor: Colors.tealAccent,
  //           textColor: Colors.white,
  //           fontSize: 16.0);
  //       setState(() {
  //         isLoad = false;
  //       });
  //       subTask = _subTaskController.text;
  //       taskTime = _taskTimeController.toString();
  //       taskDate = _taskDateController.toString();
  //       var response = await createAlbum();
  //       if (response.trim() == '200') {
  //         Fluttertoast.showToast(
  //             msg: "Saving Sub Task..",
  //             toastLength: Toast.LENGTH_SHORT,
  //             gravity: ToastGravity.TOP,
  //             timeInSecForIosWeb: 1,
  //             backgroundColor: Colors.tealAccent,
  //             textColor: Colors.white,
  //             fontSize: 16.0);
  //         detailsModel =
  //             Todo2(subTasks: subTask, time: taskTime, date: taskDate);
  //         detailsTable.add(detailsModel);
  //         clearController();
  //         setState(() {});
  //       } else {
  //         setState(
  //           () {
  //             isLoad = true;
  //           },
  //         );
  //         Fluttertoast.showToast(
  //             msg: response,
  //             toastLength: Toast.LENGTH_SHORT,
  //             gravity: ToastGravity.TOP,
  //             timeInSecForIosWeb: 1,
  //             backgroundColor: Colors.red,
  //             textColor: Colors.white,
  //             fontSize: 16.0);
  //       }
  //       print('MyResponse=>$response');
  //     }
  //   }
  // }

  // Future<String> createAlbum() async {
  //   print('inhttp');
  //   print('object' + id);
  //   String token = await getLocalToken();
  //   var response = await http.post(
  //       //Uri.parse('https://10.100.17.234/FairEx/api/v1/meet/sub-task'),
  //       Uri.parse('https://trueaviation.aero/FairEx/api/v1/meet/sub-task'),
  //       headers: <String, String>{
  //         'Content-Type': 'application/json',
  //         'Authorization': token
  //       },
  //       body: jsonEncode(<String, String>{
  //         //'new_lead_transaction': jsonEncode(<String, String>{
  //         'task_id': id,
  //         'title': subTask,
  //         'time': taskTime,
  //         'status': '0',
  //         'date': taskDate
  //         //'newPassword': newPassword
  //       }
  //           // ),}
  //           ));
  //   print(json.decode(response.body));
  //   var responsee = json.decode(response.body)['success'];
  //   if (response.statusCode == 200) {
  //     return json.decode(response.body)['success'].toString();
  //   } else {
  //     return 'Server issues';
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    setState(() {
      //count = arguments;
    });
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white10,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: onPageRefresh,
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
                      'Task Search',
                      style: GoogleFonts.mcLaren(
                        fontSize: 35.0,
                        color: Colors.tealAccent[400],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  alignment: Alignment.center,
                  color: Colors.teal,
                  height: 100.0,
                  width: MediaQuery.of(context).size.width,
                ),
                SizedBox(
                  height: 30.0,
                ),
                // Padding(
                //   padding:
                //       const EdgeInsets.only(top: 10, left: 10.0, right: 10.0),
                //   child: Container(
                //     padding: EdgeInsets.only(left: 5.0),
                //     decoration: BoxDecoration(
                //         border: Border.all(
                //           color: Colors.tealAccent,
                //           width: 3.0,
                //         ),
                //         borderRadius: BorderRadius.circular(10)),
                //     child: TextField(
                //       style: GoogleFonts.mcLaren(color: Colors.tealAccent[400]),
                //       decoration: InputDecoration(
                //         border: InputBorder.none,
                //         filled: true,
                //         // fillColor: Colors.white24,
                //         hintText: 'Search Task Title..',
                //         // labelText: 'Search Task Title',
                //         // labelStyle:
                //         //     GoogleFonts.mcLaren(color: Colors.tealAccent[400]),
                //         hintStyle:
                //             GoogleFonts.mcLaren(color: Colors.tealAccent[400]),
                //         prefixIcon:
                //             const Icon(Icons.search, color: Colors.teal),
                //         // prefixIconColor: Colors.teal,
                //       ),
                //     ),
                //   ),
                // ),
                // SizedBox(
                //   height: 20.0,
                // ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 10, left: 10.0, right: 10.0),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.tealAccent,
                          width: 3.0,
                        ),
                        borderRadius: BorderRadius.circular(10)),
                    padding: EdgeInsets.all(10),
                    child: Row(
                      // ignore: prefer_const_literals_to_create_immutables
                      children: <Widget>[
                        // TextField(
                        //   controller: _personNameController,
                        //   decoration: InputDecoration(
                        //     errorText:
                        //         _personNameValidate ? 'Value Can\'t Be Empty' : null,
                        //     labelText: 'Person Name*',
                        //     labelStyle: TextStyle(
                        //         fontWeight: FontWeight.bold, color: Colors.green),
                        //     focusedBorder: UnderlineInputBorder(
                        //       borderSide: BorderSide(color: Colors.blue),
                        //     ),
                        //   ),
                        // )
                        Expanded(
                          child: Text(
                            "Task Title : " + _taskNameController.text,
                            style: GoogleFonts.mcLaren(
                                color: Colors.tealAccent[400], fontSize: 18.0),
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            setState(() {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) => Dialog(
                                    child: ShowDialog(
                                  callBackFunction: callBack,
                                )),
                              );
                            });
                          },
                          icon: const Icon(
                            Icons.search,
                            color: Colors.teal,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 10, left: 10.0, right: 10.0),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.tealAccent,
                          width: 3.0,
                        ),
                        borderRadius: BorderRadius.circular(10)),
                    padding: EdgeInsets.all(10),
                    child: Row(
                      // ignore: prefer_const_literals_to_create_immutables
                      children: <Widget>[
                        // TextField(
                        //   controller: _personNameController,
                        //   decoration: InputDecoration(
                        //     errorText:
                        //         _personNameValidate ? 'Value Can\'t Be Empty' : null,
                        //     labelText: 'Person Name*',
                        //     labelStyle: TextStyle(
                        //         fontWeight: FontWeight.bold, color: Colors.green),
                        //     focusedBorder: UnderlineInputBorder(
                        //       borderSide: BorderSide(color: Colors.blue),
                        //     ),
                        //   ),
                        // )
                        Expanded(
                          child: Text(
                            "Task Created At : " +
                                _taskCreatedDateController.text,
                            style: GoogleFonts.mcLaren(
                                color: Colors.tealAccent[400], fontSize: 18.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 10, left: 10.0, right: 10.0),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.tealAccent,
                          width: 3.0,
                        ),
                        borderRadius: BorderRadius.circular(10)),
                    padding: EdgeInsets.all(10),
                    child: Row(
                      // ignore: prefer_const_literals_to_create_immutables
                      children: <Widget>[
                        // TextField(
                        //   controller: _personNameController,
                        //   decoration: InputDecoration(
                        //     errorText:
                        //         _personNameValidate ? 'Value Can\'t Be Empty' : null,
                        //     labelText: 'Person Name*',
                        //     labelStyle: TextStyle(
                        //         fontWeight: FontWeight.bold, color: Colors.green),
                        //     focusedBorder: UnderlineInputBorder(
                        //       borderSide: BorderSide(color: Colors.blue),
                        //     ),
                        //   ),
                        // )
                        Expanded(
                          child: Text(
                            "Task Status : " + _taskStatusController.text,
                            style: GoogleFonts.mcLaren(
                                color: Colors.tealAccent[400], fontSize: 18.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(
                  height: 20.0,
                ),
                (isSearchLoading)
                    ? (gotTaskData)
                        ? (subTaskCount > 0)
                            ? Padding(
                                padding: const EdgeInsets.only(
                                    top: 10, left: 10.0, right: 10.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.tealAccent,
                                        width: 3.0,
                                      ),
                                      borderRadius: BorderRadius.circular(10)),
                                  padding: EdgeInsets.all(10),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Column(
                                              children: <Widget>[
                                                Text('Sub-Task Date',
                                                    textAlign: TextAlign.center,
                                                    style: GoogleFonts.mcLaren(
                                                        color:
                                                            Colors.tealAccent,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Column(
                                              children: <Widget>[
                                                Text('Sub-Task Title',
                                                    style: GoogleFonts.mcLaren(
                                                        color:
                                                            Colors.tealAccent,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Column(
                                              children: <Widget>[
                                                Text('Sub-Task Time',
                                                    textAlign: TextAlign.center,
                                                    style: GoogleFonts.mcLaren(
                                                        color:
                                                            Colors.tealAccent,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Column(
                                              children: <Widget>[
                                                Text('Sub-Task Status',
                                                    textAlign: TextAlign.center,
                                                    style: GoogleFonts.mcLaren(
                                                        color:
                                                            Colors.tealAccent,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        // ignore: prefer_const_literals_to_create_immutables
                                        children: <Widget>[
                                          Expanded(
                                              child: ListView.builder(
                                                  itemCount: subTaskCount,
                                                  //scrollDirection: ScrollController:,
                                                  primary: false,
                                                  shrinkWrap: true,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5.0),
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                              subTaskDateList[
                                                                      index]
                                                                  .toString(),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: GoogleFonts.mcLaren(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .teal),
                                                            ),
                                                            flex: 1,
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                              subTaskTiteList[
                                                                      index]
                                                                  .toString(),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: GoogleFonts.mcLaren(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                          .teal[
                                                                      100]),
                                                            ),
                                                            flex: 2,
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                              subTaskTimeList[
                                                                      index]
                                                                  .toString(),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: GoogleFonts.mcLaren(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                          .teal[
                                                                      100]),
                                                            ),
                                                            flex: 1,
                                                          ),
                                                          Expanded(
                                                            flex: 1,
                                                            child: Column(
                                                              children: <
                                                                  Widget>[
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    print(
                                                                        'tapped');
                                                                    showDialog(
                                                                        context:
                                                                            context,
                                                                        builder: (context) =>
                                                                            AlertDialog(
                                                                              // elevation:
                                                                              //     20.0,
                                                                              // backgroundColor:
                                                                              //     Colors.,
                                                                              // shape:
                                                                              //     CircleAvatar
                                                                              title: Text('Change Status', style: GoogleFonts.mcLaren(color: Colors.tealAccent[400], fontWeight: FontWeight.bold)),
                                                                              content: Text('Sub Task: ' + subTaskTiteList[index].toString() + '\nThis Sub Task is ' + subTaskStatusList[index].toString() + '\nDo you wanna change the status?', style: GoogleFonts.mcLaren(color: Colors.tealAccent[400])),
                                                                              actions: <Widget>[
                                                                                TextButton(
                                                                                  onPressed: () => Navigator.pop(context),
                                                                                  child: Text('No', style: GoogleFonts.mcLaren(color: Colors.teal, fontWeight: FontWeight.bold)),
                                                                                ),
                                                                                TextButton(
                                                                                  onPressed: () {
                                                                                    print('before sending id=>' + subTaskIDList[index].toString());
                                                                                    changeStatus(subTaskStatusList[index], subTaskIDList[index]);
                                                                                    setState(() {});
                                                                                    Navigator.pop(context);
                                                                                  },
                                                                                  child: Text('Yes', style: GoogleFonts.mcLaren(color: Colors.teal, fontWeight: FontWeight.bold)),
                                                                                )
                                                                              ],
                                                                            ));
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    alignment:
                                                                        Alignment
                                                                            .centerLeft,
                                                                    padding:
                                                                        EdgeInsets
                                                                            .all(5),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                            border:
                                                                                Border.all(
                                                                              color: Colors.tealAccent,
                                                                              width: 1.0,
                                                                            ),
                                                                            borderRadius: BorderRadius.circular(5)),
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        subTaskStatusList[index]
                                                                            .toString(),
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        style: GoogleFonts.mcLaren(
                                                                            color:
                                                                                Colors.tealAccent),
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
                                                  })),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : Container(
                                padding: EdgeInsets.all(15),
                                alignment: Alignment.center,
                                child: Text(
                                  'No Task',
                                  style: GoogleFonts.mcLaren(
                                      color: Colors.teal[400],
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                        : Center(
                            child: CircularProgressIndicator(
                              color: Colors.teal,
                            ),
                          )
                    : Container()

                // ListView.builder(
                //     itemCount: detailsTable.length,
                //     //scrollDirection: ScrollController:,
                //     primary: false,
                //     shrinkWrap: true,
                //     itemBuilder: (BuildContext context, int index) {
                //       var model = detailsTable[index];
                //       return Padding(
                //         padding: const EdgeInsets.all(5.0),
                //         child: Row(
                //           children: [
                //             Expanded(
                //               child: Text(
                //                 (index + 1).toString(),
                //                 textAlign: TextAlign.center,
                //                 style: GoogleFonts.mcLaren(
                //                     fontWeight: FontWeight.bold,
                //                     color: Colors.tealAccent[400]),
                //               ),
                //               flex: 1,
                //             ),
                //             Expanded(
                //               child: Text(
                //                 model.subTasks.toString(),
                //                 textAlign: TextAlign.center,
                //                 style: GoogleFonts.mcLaren(
                //                     fontWeight: FontWeight.bold,
                //                     color: Colors.tealAccent[400]),
                //               ),
                //               flex: 1,
                //             ),
                //             Expanded(
                //               child: Text(
                //                 model.date.toString(),
                //                 textAlign: TextAlign.center,
                //                 style: GoogleFonts.mcLaren(
                //                     fontWeight: FontWeight.bold,
                //                     color: Colors.tealAccent[400]),
                //               ),
                //               flex: 1,
                //             ),
                //             Expanded(
                //               child: Text(
                //                 model.time.toString(),
                //                 textAlign: TextAlign.center,
                //                 style: GoogleFonts.mcLaren(
                //                     fontWeight: FontWeight.bold,
                //                     color: Colors.tealAccent[400]),
                //               ),
                //               flex: 1,
                //             ),
                //           ],
                //         ),
                //       );
                //     })
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ShowDialog extends StatefulWidget {
  final Function callBackFunction;

  const ShowDialog({Key? key, required this.callBackFunction})
      : super(key: key);

  @override
  State<ShowDialog> createState() => _ShowDialogState();
}

class _ShowDialogState extends State<ShowDialog> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  List<dynamic> taskNameList = [];
  List<dynamic> taskCreateDateList = [];
  List<dynamic> taskStatusList = [];
  List<dynamic> taskIDList = [];
  bool _productValidator = false;
  final _searchController = TextEditingController();
  int subTaskCount = 0;

  getSearchData() async {
    setState(() {
      isSearchLoading = false;
    });

    String token = await getLocalToken();
    taskNameList = [];
    taskCreateDateList = [];
    print("inside getData " + _taskIDController.text);
    String URL = 'https://trueaviation.aero/FairEx/api/v1/meet/search/' +
        _searchController.text;
    final response = await http.get(
      Uri.parse(URL),
      //Uri.parse('http://10.100.18.167:8090/rbd/leadInfoApi/getProductList'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': token
      },
    );

    var taskListJSON = json.decode(response.body);

    subTaskCount = taskListJSON.length;
    print('getProduct value=' + taskListJSON.toString());

    // // print(salesPersonJSON[4]['empCode'].toString() +
    // //     ' ' +
    // //     salesPersonJSON[4]['empName']);
    // // print("leaving getData");
    // for (int i = 0; i < productListNumber; i++) {
    //   int productLenght = produtcListJSON[i]['name'].length;
    //   double productLengthHalf = productLenght.toDouble() / 2;
    //   int productHalfLenght = productLengthHalf.toInt();
    //   if (productLenght > 30) {
    //     if (productLenght.isEven) {
    //       produtcListJSON[i]['name'] =
    //           produtcListJSON[i]['name'].substring(0, productHalfLenght) +
    //               produtcListJSON[i]['name'].substring(productHalfLenght);
    //     } else {
    //       produtcListJSON[i]['name'] =
    //           produtcListJSON[i]['name'].substring(0, productHalfLenght + 1) +
    //               produtcListJSON[i]['name'].substring(productHalfLenght + 1);
    //     }
    //   }
    //   String productListMiddle = produtcListJSON[i]['name'] +
    //       ' & Code: ' +
    //       produtcListJSON[i]['code'].toString();
    //   product_list.insert(0, productListMiddle);
    // }
    for (int i = 0; i < subTaskCount; i++) {
      taskNameList.add(taskListJSON[i]['title'].toString());
      taskCreateDateList
          .add(taskListJSON[i]['created_at'].toString().split('T')[0]);
      taskStatusList.add(taskListJSON[i]['status']);
      taskIDList.add(taskListJSON[i]['id'].toString());
    }

    setState(() {
      isSearchLoading = true;
    });
    print("Leaing Lead Loop");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 450,
      width: 150,
      padding: EdgeInsets.all(10.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 10.0, right: 10.0),
            child: Container(
              padding: EdgeInsets.only(left: 5.0),
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.green,
                    width: 3.0,
                  ),
                  borderRadius: BorderRadius.circular(10)),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {});
                  if (_searchController.text.length > 2) {
                    isSearchLoading = false;
                    setState(() {});
                    getSearchData();
                  }
                },
                style: GoogleFonts.mcLaren(color: Colors.lightGreen[900]),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  filled: true,
                  // fillColor: Colors.white24,
                  hintText: 'Search Task Title..',
                  // labelText: 'Search Task Title',
                  // labelStyle:
                  //     GoogleFonts.mcLaren(color: Colors.tealAccent[400]),
                  hintStyle: GoogleFonts.mcLaren(color: Colors.lightGreen[900]),
                  prefixIcon: const Icon(Icons.search, color: Colors.green),
                  // prefixIconColor: Colors.teal,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          (_searchController.text.length > 2)
              ? (isSearchLoading)
                  ? (subTaskCount > 0)
                      ? Expanded(
                          child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: subTaskCount,
                              primary: false,
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                  onTap: () {
                                    _taskNameController.text =
                                        taskNameList[index];
                                    _taskCreatedDateController.text =
                                        taskCreateDateList[index];
                                    _taskStatusController.text =
                                        taskStatusList[index];
                                    _taskIDController.text = taskIDList[index];
                                    print(_taskIDController.text);

                                    widget.callBackFunction();
                                    Navigator.of(context).pop();
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(bottom: 5.0),
                                    child: Container(
                                      padding: EdgeInsets.all(5.0),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          border: Border.all(
                                            color: Colors.green,
                                            width: 1.0,
                                          )),
                                      child: Column(
                                        children: <Widget>[
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  'Task Title : ' +
                                                      taskNameList[index],
                                                  style: TextStyle(
                                                      color: Colors.green,
                                                      fontSize: 15),
                                                ),
                                              )
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  'Task Created : ' +
                                                      taskCreateDateList[index],
                                                  style: TextStyle(
                                                      color: Colors.green,
                                                      fontSize: 15),
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        )
                      : Center(
                          child: Column(
                            children: [
                              //Text('No Suggestion'),
                              SizedBox(
                                height: 30.0,
                              ),
                              // TextField(
                              //   controller: _productNameController2,
                              //   decoration: InputDecoration(
                              //     errorText: _productValidator
                              //         ? 'Value Can\'t Be Empty'
                              //         : null,
                              //     labelText: 'Type Product Name*',
                              //     labelStyle: TextStyle(
                              //       //fontWeight: FontWeight.normal,
                              //       color: Colors.green, fontSize: 15,
                              //     ),
                              //     focusedBorder: UnderlineInputBorder(
                              //       borderSide: BorderSide(color: Colors.blue),
                              //     ),
                              //   ),
                              // ),

                              GestureDetector(
                                onTap: () => {
                                  Navigator.of(context).pop(),
                                  setState(() {
                                    isSearchLoading = false;
                                  })
                                },
                                child: Container(
                                  padding: EdgeInsets.only(
                                      top: 0.0, left: 20.0, right: 20.0),
                                  child: Container(
                                    height: 30.0,
                                    width: 300.0,
                                    child: Material(
                                      borderRadius: BorderRadius.circular(20.0),
                                      shadowColor: Colors.green,
                                      color: Colors.green[600],
                                      elevation: 7.0,
                                      child: Center(
                                        child: Text(
                                          "No Such Task",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 10.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                  : Center(
                      child: CircularProgressIndicator(),
                    )
              : Center(
                  child: Text(
                    'Type Minimum 3 Character',
                  ),
                )
        ],
      ),
      // (productLoaded)
      //     ?

      //
    );
  }
}
