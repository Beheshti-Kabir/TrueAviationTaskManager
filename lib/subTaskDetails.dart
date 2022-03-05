import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';
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

  // getProduct() async {
  //   print("inside getData");
  //   final response = await http
  //       .get(Uri.parse('http://202.84.44.234:9085/rbd/leadInfoApi/getData'));

  //   produtcListJSON = json.decode(response.body)['productList'];

  //   productListNumber = produtcListJSON.length;

  //   // print(salesPersonJSON[4]['empCode'].toString() +
  //   //     ' ' +
  //   //     salesPersonJSON[4]['empName']);
  //   // print("leaving getData");
  //   for (var i = 0; i < productListNumber; i++) {
  //     int productLenght = produtcListJSON[i]['name'].length;
  //     double productLengthHalf = productLenght.toDouble() / 2;
  //     int productHalfLenght = productLengthHalf.toInt();
  //     if (productLenght > 30) {
  //       if (productLenght.isEven) {
  //         produtcListJSON[i]['name'] =
  //             produtcListJSON[i]['name'].substring(0, productHalfLenght) +
  //                 produtcListJSON[i]['name'].substring(productHalfLenght);
  //       } else {
  //         produtcListJSON[i]['name'] =
  //             produtcListJSON[i]['name'].substring(0, productHalfLenght + 1) +
  //                 produtcListJSON[i]['name'].substring(productHalfLenght + 1);
  //       }
  //     }
  //     String productListMiddle = produtcListJSON[i]['name'] +
  //         ' & Code: ' +
  //         produtcListJSON[i]['code'].toString();
  //     product_list.insert(0, productListMiddle);
  //   }

  //   print("Leaing Lead Loop");
  // }

  final _subTaskController = TextEditingController();

  var count = 0;
  late var produtcListJSON;
  late var productListNumber;

  String subTask = '';
  String _taskTimeController = '';

  List<Todo2> detailsTable = [];
  var icnSize = 18.0;
  var dropColor = Colors.blue;
  List<String> subTaskList = [''];

  late Todo2 detailsModel;

  bool _quantityValidate = false;
  bool _subTaskValidate = false;
  var taskTime = '';

  void clearController() {
    _subTaskController.clear();
    _taskTimeController = '';
  }

  formValidator() {
    String subTaskValidation = _subTaskController.text;

    setState(() {
      if (subTaskValidation == null || subTaskValidation.isEmpty) {
        _subTaskValidate = true;
      } else {
        _subTaskValidate = false;
      }
    });
    if (!_subTaskValidate) {
      return true;
    } else {
      return false;
    }
    ;
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments as List<Todo2>;
    detailsTable = arguments;
    print('value:' + arguments.length.toString());
    setState(() {
      //count = arguments;
    });
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white10,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Text(
                'Givving Sub Tasks',
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
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 10.0, right: 10.0),
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
              padding: const EdgeInsets.only(top: 10, left: 10.0, right: 10.0),
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
                    "Task Time* : $_taskTimeController",
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
                      bool isValid = formValidator();
                      if (isValid) {
                        count += 1;
                        subTask = _subTaskController.text.toString();
                        taskTime = _taskTimeController.toString();
                        detailsModel = Todo2(subTasks: subTask, time: taskTime);
                        detailsTable.add(detailsModel);
                        clearController();
                        setState(() {});
                      }
                    },
                    child: Container(
                      height: 30.0,
                      width: 80.0,
                      child: Material(
                        borderRadius: BorderRadius.circular(20.0),
                        shadowColor: Colors.lightGreen[600],
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
                      print('count:' + count.toString());
                      Navigator.of(context).pop(detailsTable);
                    },
                    child: Container(
                      height: 30.0,
                      width: 80.0,
                      child: Material(
                        borderRadius: BorderRadius.circular(20.0),
                        shadowColor: Colors.lightGreen[600],
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
              padding: const EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0,bottom: 0.0),
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
    );
  }
}
