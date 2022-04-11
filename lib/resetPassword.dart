import 'dart:convert';
import 'dart:ui';

import 'package:true_aviation_task/adminLobby.dart';
import 'package:true_aviation_task/main.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:true_aviation_task/utils/session_maneger.dart';

class ResetPasswordPage extends StatefulWidget {
  @override
  _resetPassword createState() {
    return _resetPassword();
  }
}

class _resetPassword extends State<ResetPasswordPage> {
  @override
  void initState() {
    // TODO: implement initState
    getEmail();
    super.initState();
  }

  final _emailID = TextEditingController();
  // final _oldPassword = TextEditingController();
  // final _newPassword = TextEditingController();
  // final _reNewPassword = TextEditingController();

  bool _emailIDValidate = false;
  // bool _oldPasswordValidate = false;
  // bool _newPasswordValidate = false;
  // bool _reNewPasswordValidate = false;

  bool isLoad = true;

  String emailID = '';
  // String oldPassword = '';
  // String newPassword = '';
  // String reNewPassword = '';

  getEmail() async {
    emailID = await getLocalUserEmailID();
    setState(() {});
  }

  formValidator() {
    String emailIDVal = _emailID.toString();
    // //String meetDate = _meetDateController.text;
    // String oldPasswordVal = _oldPassword.toString();
    // String newPasswordVal = _newPassword.toString();
    // String reNewpasswordVal = _reNewPassword.toString();
    setState(() {
      // if (employIDVal == null || employIDVal.isEmpty) {
      //   _employIDValidate = true;
      // } else {
      //   _employIDValidate = false;
      // }
      // if (oldPasswordVal == null || oldPasswordVal.isEmpty) {
      //   _oldPasswordValidate = true;
      // } else {
      //   _oldPasswordValidate = false;
      // }
      // if (newPasswordVal == null || newPasswordVal.isEmpty) {
      //   _newPasswordValidate = true;
      // } else {
      //   _newPasswordValidate = false;
      // }
      // if (reNewpasswordVal == null || reNewpasswordVal.isEmpty) {
      //   _reNewPasswordValidate = true;
      // } else {
      //   _reNewPasswordValidate = false;
      // }
      // if (meetDate == null || meet_date.isEmpty) {
      //   _meetDateVaidate = true;
      // } else {
      //   _meetDateVaidate = false;
      // }
    });
    if (!_emailIDValidate
        //  && !_oldPasswordValidate &&
        //!_newPasswordValidate && !_reNewPasswordValidate
        ) {
      return true;
    } else {
      return false;
    }
  }

  Future<String> createAlbum() async {
    String token = await getLocalToken();
    var response = await http.post(
        Uri.parse(
            'https://trueaviation.aero/FairEx/api/v1/admin/change-password'),
        //Uri.parse('https://10.100.17.234/FairEx/api/v1/admin/change-password'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': token
        },
        body: jsonEncode(<String, String>{
          //'new_lead_transaction': jsonEncode(<String, String>{
          //'username': employID,
          'email': emailID,
          'password': '123456'
        }
            // ),}

            ));
    var responsee = json.decode(response.body)['status'];
    if (response.statusCode == 200) {
      if (responsee.toString().toLowerCase().trim() == 'fail') {
        return 'Email ID Does Not Exist';
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
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Reset Password',
                  style: GoogleFonts.mcLaren(
                    fontSize: 35.0,
                    color: Colors.orange[100],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              alignment: Alignment.center,
              color: Colors.orange[600],
              height: 100.0,
              width: MediaQuery.of(context).size.width,
            ),

            // Padding(
            //     padding: const EdgeInsets.only(top:100, left: 10.0,right: 10.0),
            //     child: Container(
            //       padding: EdgeInsets.only(left:5.0),
            //       decoration: BoxDecoration(
            //                         border: Border.all(
            //                           color: Colors.orangeAccent,
            //                           width: 3.0,
            //                         ),
            //                         borderRadius: BorderRadius.circular(10)),
            //         child:
            //           TextField(
            //             controller: _employID,
            //             style: GoogleFonts.mcLaren(color: Colors.orange[100]),
            //             decoration: InputDecoration(
            //                border: InputBorder.none,
            //               errorText:
            //                   _employIDValidate ? 'Value Can\'t Be Empty' : null,
            //               labelText: 'EmployID* : ',
            //               labelStyle: GoogleFonts.mcLaren(
            //                   fontWeight: FontWeight.bold, color: Colors.orange[100]),

            //             ),

            //           )
            //         ,),

            //   ),
            Padding(
              padding: const EdgeInsets.only(top: 40, left: 10.0, right: 10.0),
              child: Container(
                padding: EdgeInsets.only(left: 5.0),
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.orangeAccent,
                      width: 3.0,
                    ),
                    borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  controller: _emailID,
                  style: GoogleFonts.mcLaren(color: Colors.orange[100]),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    errorText:
                        _emailIDValidate ? 'Value Can\'t Be Empty' : null,
                    labelText: 'Email ID* : ',
                    labelStyle: GoogleFonts.mcLaren(
                        fontWeight: FontWeight.bold, color: Colors.orange[100]),
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
                      color: Colors.orangeAccent,
                      width: 3.0,
                    ),
                    borderRadius: BorderRadius.circular(10)),
                child: Text('Password : 123456',
                    style: GoogleFonts.mcLaren(
                      color: Colors.orange[100],
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
            //           color: Colors.orangeAccent,
            //           width: 3.0,
            //         ),
            //         borderRadius: BorderRadius.circular(10)),
            //     child: TextField(
            //       controller: _oldPassword,
            //       style: GoogleFonts.mcLaren(color: Colors.orange[100]),
            //       decoration: InputDecoration(
            //         border: InputBorder.none,
            //         errorText:
            //             _oldPasswordValidate ? 'Value Can\'t Be Empty' : null,
            //         labelText: 'Old Password* : ',
            //         labelStyle: GoogleFonts.mcLaren(
            //             fontWeight: FontWeight.bold, color: Colors.orange[100]),
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
            //           color: Colors.orangeAccent,
            //           width: 3.0,
            //         ),
            //         borderRadius: BorderRadius.circular(10)),
            //     child: TextField(
            //       controller: _reNewPassword,
            //       style: GoogleFonts.mcLaren(color: Colors.orange[100]),
            //       decoration: InputDecoration(
            //         border: InputBorder.none,
            //         errorText:
            //             _reNewPasswordValidate ? 'Value Can\'t Be Empty' : null,
            //         labelText: 'Re-type New Password* : ',
            //         labelStyle: GoogleFonts.mcLaren(
            //             fontWeight: FontWeight.bold, color: Colors.orange[100]),
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
                      //isLoad = true;
                      bool isValid = formValidator();
                      if (isValid) {
                        Fluttertoast.showToast(
                            msg: "Saving Change..",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.TOP,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.orangeAccent,
                            textColor: Colors.white,
                            fontSize: 16.0);

                        setState(() {
                          isLoad = false;
                        });

                        //employID = _employID.text;
                        //oldPassword = _oldPassword.text;
                        emailID = _emailID.text;

                        var response = await createAlbum();

                        if (response.toString().toLowerCase().trim() ==
                            'true') {
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => new LobbyPage()),
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
                              backgroundColor: Colors.orangeAccent,
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
                      shadowColor: Colors.orange[600],
                      color: Colors.orange[600],
                      elevation: 7.0,
                      child: Center(
                        child: Text(
                          "Save Change",
                          style: TextStyle(
                              color: Colors.orange[100],
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
