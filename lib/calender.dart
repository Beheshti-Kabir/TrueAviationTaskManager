// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers

import 'dart:convert';
import 'dart:ui';

import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:true_aviation_task/lobby.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class CalenderPage extends StatefulWidget {
  @override
  _calender createState() => _calender();

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
    );
  }
}

class _calender extends State<CalenderPage> {
  CalendarFormat format = CalendarFormat.month;

  bool isLoading = false;
  bool gotData = false;

  var startDate = '';
  var endDate = '';

  late dynamic response;
  late var totalInvoice = '';
  late var totalPna = '';
  late var totalFollowUp = '';
  late var totalLead = '';
  late var totalCancel = '';
  late var totalInProgress = '';
  late var totalNoAnswer = '';
  late String stepType = '';
  List<dynamic> room1 = [];
  List<dynamic> room2 = [];
  List<dynamic> room3 = [];

  String _startDateController = '';
  String _endDateController = '';

  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();
  // @override
  // initState() {
  //   super.initState();
  //   print('init');
  // }

  getStepType() async {
    // setState(() {
    //   isLoading = true;
    //   print("isLoading");
    //   //print(json.decode(response.body)['totalLead']);
    //   //result = json.decode(response.body);
    //   //print("lead=" + json.decode(response.body)['totalLead']);
    //   // result['leadInfo'];
    // });

    response = await http.post(
        Uri.parse('http://202.84.44.234:9085/rbd/leadInfoApi/getDataByStatus'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: jsonEncode(<String, String>{
          // 'userID': Constants.employeeId,
          'stepType': stepType,
        }));

    room1 = jsonDecode(response.body)['room1'];
    room2 = jsonDecode(response.body)['room2'];
    room3 = jsonDecode(response.body)['room3'];
    //print(statusValue[0]['customerName'].toString());
  }

  @override
  Widget build(BuildContext context) {
    if (!gotData) {
      getStepType();
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
              child: Text(
                'Calendar',
                style: GoogleFonts.mcLaren(
                  fontSize: 35.0,
                  color: Colors.pink[100],
                  fontWeight: FontWeight.bold,
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
                    focusedDay = focusDay;
                  });
                  print(selectedDay);
                },
                calendarStyle: CalendarStyle(
                    isTodayHighlighted: true,
                    // defaultDecoration: BoxDecoration(
                    //     color: Colors.amberAccent, shape: BoxShape.circle),
                    selectedTextStyle:
                        TextStyle(color: Colors.red[100]),
                    selectedDecoration: BoxDecoration(color: Colors.red[900],shape:BoxShape.circle),
                    todayDecoration: BoxDecoration(color: Colors.red[400],shape:BoxShape.circle)
                    
                        ),
                headerStyle: HeaderStyle(formatButtonVisible: false,titleCentered: true),
                selectedDayPredicate: (DateTime date) {
                  return isSameDay(selectedDay, date);
                },
                
              ),
            )
            //if (room1.isNotEmpty)
          ]))),
    );
  }


}
