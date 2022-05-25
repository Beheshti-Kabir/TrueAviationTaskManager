import 'dart:convert';
//import 'dart:html';
import 'package:true_aviation_task/constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

import 'package:flutter/material.dart';
import 'package:true_aviation_task/utils/session_maneger.dart';

class LogInPage extends StatefulWidget {
  @override
  _LogINPageState createState() => _LogINPageState();
}

class _LogINPageState extends State<LogInPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _emailValidate = false;
  bool _passwordValidate = false;
  String filterType = "user";
  //String URL = 'https://10.100.17.234/FairEx/api/v1/user/login';
  String URL = 'http://trueaviation.aero/FairEx/api/v1/user/login';
  String email = '';
  String password = '';
  String token = '';
  String userName = '';
  String emailID = '';
  String userType = 'user';
  String route = '/userLobby';
  String message = '';
  //logInValidator(){}

  bool formValidator() {
    String email = _emailController.text;
    String password = _passwordController.text;

    setState(() {
      if (email == null || email.isEmpty) {
        _emailValidate = true;
      } else {
        _emailValidate = false;
      }
      if (password == null || password.isEmpty) {
        _passwordValidate = true;
      } else {
        _passwordValidate = false;
      }
    });
    if (!_emailValidate && !_passwordValidate) {
      return true;
    } else {
      return false;
    }
  }

  changeFilter(String filter) {
    filterType = filter;
    setState(() {});
  }

  setData() async {
    print('in store data');

    // Constants.employeeId = _emailController.text.trim();
    storeLocalSetUserName(Constants.userNameKey, userName);
    storeLocalSetUserEmailID(Constants.userEmailKey, emailID);
    storeLocalSetAccessToken(Constants.accessTokenKey, token);
    storeLocalSetUserType(Constants.userTypeKey, userType);
    Fluttertoast.showToast(
        msg: "Logged In",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.green[100],
        fontSize: 16.0);
    storeLocalSetLogInStatus(Constants.logInStatusKey, 'true');
    print('$userName $emailID  $userType $token');
    message = 'Logging In';

    Navigator.of(context).pushNamed(route);
  }

  Future<String> createAlbum() async {
    var response = await http.post(Uri.parse(URL),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: jsonEncode(<String, String>{
          //'new_lead_transaction': jsonEncode(<String, String>{
          'email': email,
          'password': password,
        }
            // ),}

            ));

    print(json.decode(response.body).toString());
    var responsee = json.decode(response.body)['status'];
    token = json.decode(response.body)['token_type'].toString() +
        ' ' +
        json.decode(response.body)['access_token'].toString();
    emailID = json.decode(response.body)['user']['email'].toString();
    userName = json.decode(response.body)['user']['name'].toString();

    print(responsee);
    if (response.statusCode == 200) {
      if (responsee.toString().toLowerCase().trim() == 'true') {
        print('all in ');
        setData();
        message = 'Logging In';
      } else {
        Fluttertoast.showToast(
            msg: "Email ID & Password Don\'t Match..",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.green[100],
            fontSize: 16.0);
      }
    } else {
      Fluttertoast.showToast(
          msg: "Server Issue..",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.green[100],
          fontSize: 16.0);
    }
    return 'nothing';
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
                    padding: EdgeInsets.fromLTRB(15.0, 110.0, 0.0, 0.0),
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
                    padding: EdgeInsets.fromLTRB(20.0, 175.0, 0.0, 0.0),
                    child: Text(
                      'Aviation',
                      style: GoogleFonts.mcLaren(
                          color: Colors.green[200],
                          fontSize: 60,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(20.0, 270.0, 0.0, 0.0),
                    child: Text(
                      'Task',
                      style: GoogleFonts.mcLaren(
                          color: Colors.green[200],
                          fontSize: 45,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(20.0, 310.0, 0.0, 0.0),
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
            SizedBox(
              height: 105,
            ),
            Container(
              height: 70,
              //color: Colors.cyan,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          URL =
                              //'https://10.100.17.234/FairEx/api/v1/user/login';
                              'http://trueaviation.aero/FairEx/api/v1/user/login';
                          route = '/userLobby';
                          userType = 'user';
                          changeFilter("user");
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),

                          decoration: BoxDecoration(
                              border: Border.all(
                                color: (filterType == "user")
                                    ? Colors.green
                                    : Colors.transparent,
                                width: 3.0,
                              ),
                              borderRadius: BorderRadius.circular(20)),
                          // color: (filterType == "user")
                          //     ? Colors.greenAccent
                          //     : Colors.white,
                          child: Text(
                            "I am Employee",
                            style: GoogleFonts.mcLaren(
                                color: (filterType == "user")
                                    ? Colors.white
                                    : Colors.greenAccent,
                                fontSize: 18),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          URL =
                              //'https://10.100.17.234/FairEx/api/v1/admin/login';
                              'http://trueaviation.aero/FairEx/api/v1/admin/login';
                          route = '/lobby';
                          userType = 'admin';
                          changeFilter("admin");
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: (filterType == "admin")
                                    ? Colors.green
                                    : Colors.transparent,
                                width: 3.0,
                              ),
                              borderRadius: BorderRadius.circular(20)),
                          // color: (filterType == "user")
                          //     ? Colors.greenAccent
                          //     : Colors.white,
                          child: Text(
                            "I am Admin",
                            style: GoogleFonts.mcLaren(
                                color: (filterType == "admin")
                                    ? Colors.white
                                    : Colors.greenAccent,
                                fontSize: 18),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 20),
              child: Container(
                  padding: EdgeInsets.only(left: 5.0),
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Color.fromARGB(255, 135, 230, 138),
                        width: 3.0,
                      ),
                      borderRadius: BorderRadius.circular(10)),
                  child: TextField(
                    controller: _emailController,
                    style: GoogleFonts.mcLaren(color: Colors.green[100]),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      errorText:
                          _emailValidate ? 'Value Can\'t Be Empty' : null,

                      // hintText: "email",
                      // hintStyle: GoogleFonts.mcLaren(color: Colors.green[100]),
                      labelText: 'Email :',
                      labelStyle: GoogleFonts.mcLaren(
                          fontWeight: FontWeight.bold,
                          color: Colors.green[100]),
                    ),
                  )),
            ),
            SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: Container(
                padding: EdgeInsets.only(left: 5.0),
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.green,
                      width: 3.0,
                    ),
                    borderRadius: BorderRadius.circular(10)),
                child: TextField(
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
                ),
              ),
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
                    //Navigator.of(context).pushNamed('/lobby');
                    bool isValid = formValidator();
                    print(_emailController.text);
                    print(_passwordController.text);
                    if (isValid) {
                      email = _emailController.text;
                      password = _passwordController.text;
                      var fau = createAlbum();
                      // if (result == 'true') {
                      // Fluttertoast.showToast(
                      //     msg: message,
                      //     toastLength: Toast.LENGTH_SHORT,
                      //     gravity: ToastGravity.TOP,
                      //     timeInSecForIosWeb: 1,
                      //     backgroundColor: Colors.red,
                      //     textColor: Colors.green[100],
                      //     fontSize: 16.0);
                      // }
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
                              color: Colors.green[100],
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
