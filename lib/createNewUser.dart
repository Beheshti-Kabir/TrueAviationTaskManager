import 'dart:convert';
import 'dart:ui';

import 'package:true_aviation_task/main.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:true_aviation_task/utils/session_maneger.dart';

class CreateNewUserPage extends StatefulWidget {
  @override
  _createNewUser createState() {
    return _createNewUser();
  }
}

class _createNewUser extends State<CreateNewUserPage> {
  //@override

  final _phoneNumberController = TextEditingController();
  final _nameController = TextEditingController();
  final _newEmailIDController = TextEditingController();
  final _newEmployIDPasswordController = TextEditingController();
  final _reNewEmployIDPasswordController = TextEditingController();

  bool _phoneNumberValidate = false;
  bool _nameValidate = false;
  bool _newEmailIDValidate = false;
  bool _newEmployIDPasswordValidate = false;
  bool _reNewEmployIDPasswordValidate = false;

  bool isLoad = true;

  String name = '';
  String phoneNumber = '';
  String newEmailID = '';
  String newEmployIDPassword = '';
  String reNewEmployIDPassword = '';

  String? _userType;
  String filterType = 'user';
  //String URL = 'https://10.100.17.47/FairEx/api/v1/user/register';
  String URL = 'https://trueaviation.aero/FairEx/api/v1/user/register';

  List<String> userType = [
    'User Type : Admin',
    'User Type : Employee',
  ];

  formValidator() {
    String nameVal = _nameController.toString();
    String phoneNumberVal = _phoneNumberController.toString();
    String newEmailIDVal = _newEmailIDController.toString();
    String passwordVal = _newEmployIDPasswordController.toString();
    String rePasswordVal = _reNewEmployIDPasswordController.toString();
    setState(() {
      if (nameVal == null || nameVal.isEmpty) {
        _nameValidate = true;
      } else {
        _nameValidate = false;
      }
      if (phoneNumberVal == null || phoneNumberVal.isEmpty) {
        _phoneNumberValidate = true;
      } else {
        _phoneNumberValidate = false;
      }
      if (newEmailIDVal == null || newEmailIDVal.isEmpty) {
        _newEmailIDValidate = true;
      } else {
        _newEmailIDValidate = false;
      }
      // if (passwordVal == null || passwordVal.isEmpty) {
      //   _newEmployIDPasswordValidate = true;
      // } else {
      //   _newEmployIDPasswordValidate = false;
      // }
      // if (rePasswordVal == null || rePasswordVal.isEmpty) {
      //   _reNewEmployIDPasswordValidate = true;
      // } else {
      //   _reNewEmployIDPasswordValidate = false;
      // }
      // if (meetDate == null || meet_date.isEmpty) {
      //   _meetDateVaidate = true;
      // } else {
      //   _meetDateVaidate = false;
      // }
    });
    if (!_nameValidate && !_phoneNumberValidate && !_newEmailIDValidate
        // !_newEmployIDPasswordValidate &&
        // !_reNewEmployIDPasswordValidate
        ) {
      return true;
    } else {
      return false;
    }
  }

  changeFilter(String filter) {
    filterType = filter;
    setState(() {});
  }

  Future<String> createAlbum() async {
    String token = await getLocalToken();
    var response = await http.post(
        //Uri.parse('https://10.100.17.234/FairEx/api/v1/meet/task'),
        Uri.parse('https://trueaviation.aero/FairEx/api/v1/meet/task'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': token
        },
        body: jsonEncode(<String, String>{
          //'new_lead_transaction': jsonEncode(<String, String>{
          'name': name,
          'email': newEmailID,
          'phone': phoneNumber,
          'password': '123456',
          //'newPassword': newPassword
        }
            // ),}

            ));
    var responsee = json.decode(response.body)['status'];
    if (response.statusCode == 200) {
      if (responsee.toString().toLowerCase().trim() == 'fail') {
        return 'Creator\'s EmployID & Password Don\'t Match';
      } else {
        return json.decode(response.body)['status'].toString();
      }
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
          child: Column(children: <Widget>[
            Container(
              child: Text(
                'Create New User',
                style: GoogleFonts.mcLaren(
                  fontSize: 35.0,
                  color: Colors.lightBlue[100],
                  fontWeight: FontWeight.bold,
                ),
              ),
              alignment: Alignment.center,
              color: Colors.lightBlue,
              height: 100.0,
              width: MediaQuery.of(context).size.width,
            ),
            Container(
              height: 70,
              color: Colors.lightBlue[400],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          URL =
                              'https://trueaviation.aero/FairEx/api/v1/user/register';
                          // 'https://10.100.17.47/FairEx/api/v1/user/register';
                          changeFilter("user");
                        },
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            "Account Create",
                            style: GoogleFonts.mcLaren(
                                color: Colors.lightBlue[100], fontSize: 18),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 4,
                        width: 120,
                        color: (filterType == "user")
                            ? Colors.white
                            : Colors.transparent,
                      )
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          URL =
                              'https://trueaviation.aero/FairEx/api/v1/admin/register';
                          //'https://10.100.17.47/FairEx/api/v1/admin/register';
                          changeFilter("admin");
                        },
                        child: Text(
                          "Create Admin",
                          style: GoogleFonts.mcLaren(
                              color: Colors.lightBlue[100], fontSize: 18),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 4,
                        width: 120,
                        color: (filterType == "admin")
                            ? Colors.lightBlue[100]
                            : Colors.transparent,
                      )
                    ],
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 50, left: 10.0, right: 10.0),
              child: Container(
                padding: EdgeInsets.only(left: 5.0),
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.lightBlueAccent,
                      width: 3.0,
                    ),
                    borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  controller: _newEmailIDController,
                  style: GoogleFonts.mcLaren(color: Colors.lightBlue[100]),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    errorText:
                        _newEmailIDValidate ? 'Value Can\'t Be Empty' : null,
                    labelText: 'New Employee Email ID* : ',
                    labelStyle: GoogleFonts.mcLaren(
                        fontWeight: FontWeight.bold,
                        color: Colors.lightBlue[100]),
                  ),
                  // /obscureText: true,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 10.0, right: 10.0),
              child: Container(
                padding: EdgeInsets.only(left: 5.0),
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.lightBlueAccent,
                      width: 3.0,
                    ),
                    borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  controller: _nameController,
                  style: GoogleFonts.mcLaren(color: Colors.lightBlue[100]),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    errorText: _nameValidate ? 'Value Can\'t Be Empty' : null,
                    labelText: 'Name* : ',
                    labelStyle: GoogleFonts.mcLaren(
                        fontWeight: FontWeight.bold,
                        color: Colors.lightBlue[100]),
                  ),
                  //obscureText: true,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 10.0, right: 10.0),
              child: Container(
                padding: EdgeInsets.only(left: 5.0),
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.lightBlueAccent,
                      width: 3.0,
                    ),
                    borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  controller: _phoneNumberController,
                  keyboardType: TextInputType.number,
                  style: GoogleFonts.mcLaren(color: Colors.lightBlue[100]),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    errorText:
                        _phoneNumberValidate ? 'Value Can\'t Be Empty' : null,
                    labelText: 'Phone Number* : ',
                    labelStyle: GoogleFonts.mcLaren(
                        fontWeight: FontWeight.bold,
                        color: Colors.lightBlue[100]),
                  ),
                  //obscureText: true,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 10.0, right: 10.0),
              child: Container(
                padding: EdgeInsets.only(left: 5.0),
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.lightBlueAccent,
                      width: 3.0,
                    ),
                    borderRadius: BorderRadius.circular(10)),
                child: Text('Password : 123456',
                    style: GoogleFonts.mcLaren(
                      color: Colors.lightBlue[100],
                      fontSize: 18,
                    )),
                height: 60,
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.centerLeft,
              ),
            ),

            // Padding(
            //   padding: const EdgeInsets.only(top: 10, left: 10.0, right: 10.0),
            //   child: Container(
            //     padding: EdgeInsets.only(left: 5.0),
            //     decoration: BoxDecoration(
            //         border: Border.all(
            //           color: Colors.lightBlueAccent,
            //           width: 3.0,
            //         ),
            //         borderRadius: BorderRadius.circular(10)),
            //     child: TextField(
            //       controller: _newEmployIDPasswordController,
            //       style: GoogleFonts.mcLaren(color: Colors.lightBlue[100]),
            //       decoration: InputDecoration(
            //         border: InputBorder.none,
            //         errorText: _newEmployIDPasswordValidate
            //             ? 'Value Can\'t Be Empty'
            //             : null,
            //         labelText: 'New Password* : ',
            //         labelStyle: GoogleFonts.mcLaren(
            //             fontWeight: FontWeight.bold,
            //             color: Colors.lightBlue[100]),
            //       ),
            //       obscureText: true,
            //     ),
            //   ),
            // ),

            // Padding(
            //   padding: const EdgeInsets.only(top: 10, left: 10.0, right: 10.0),
            //   child: Container(
            //     padding: EdgeInsets.only(left: 5.0),
            //     decoration: BoxDecoration(
            //         border: Border.all(
            //           color: Colors.lightBlueAccent,
            //           width: 3.0,
            //         ),
            //         borderRadius: BorderRadius.circular(10)),
            //     child: TextField(
            //       controller: _reNewEmployIDPasswordController,
            //       style: GoogleFonts.mcLaren(color: Colors.lightBlue[100]),
            //       decoration: InputDecoration(
            //         border: InputBorder.none,
            //         errorText: _reNewEmployIDPasswordValidate
            //             ? 'Value Can\'t Be Empty'
            //             : null,
            //         labelText: 'Re-type New Employ Password* : ',
            //         labelStyle: GoogleFonts.mcLaren(
            //             fontWeight: FontWeight.bold,
            //             color: Colors.lightBlue[100]),
            //       ),
            //       obscureText: true,
            //     ),
            //   ),
            // ),

            SizedBox(height: 40.0),
            // save
            Container(
              child: Center(
                child: GestureDetector(
                  onTap: () async {
                    if (isLoad) {
                      bool isValid = formValidator();
                      if (isValid) {
                        Fluttertoast.showToast(
                            msg: "Saving Change..",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.TOP,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.lightBlueAccent,
                            textColor: Colors.white,
                            fontSize: 16.0);

                        setState(() {
                          isLoad = false;
                        });

                        newEmailID = _newEmailIDController.toString();
                        newEmployIDPassword =
                            _newEmployIDPasswordController.toString();
                        phoneNumber = _phoneNumberController.toString();
                        name = _nameController.toString();

                        var response = await createAlbum();

                        //if (response.toLowerCase().trim() == '200') {
                        if (response.toString() == 'true') {
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => new MyHomePage()),
                              (Route<dynamic> route) => false);
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
                  },
                  child: Container(
                    height: 40.0,
                    width: 150.0,
                    child: Material(
                      borderRadius: BorderRadius.circular(20.0),
                      shadowColor: Colors.lightBlue[600],
                      color: Colors.blue[800],
                      elevation: 7.0,
                      child: Center(
                        child: Text(
                          "Create",
                          style: GoogleFonts.mcLaren(
                              color: Colors.lightBlue[100],
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
          ]),
        ),
      ),
    );
  }
}
