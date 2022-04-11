import 'package:shared_preferences/shared_preferences.dart';
import 'package:true_aviation_task/constants.dart';

Future storeLocalSetUserType(String key, String value) async {
  final _sharedPreferences = await SharedPreferences.getInstance();

  await _sharedPreferences.setString(key, value);
}

Future storeLocalSetUserName(String key, String value) async {
  final _sharedPreferences = await SharedPreferences.getInstance();

  await _sharedPreferences.setString(key, value);
}

Future storeLocalSetUserEmailID(String key, String value) async {
  final _sharedPreferences = await SharedPreferences.getInstance();

  await _sharedPreferences.setString(key, value);
}

Future storeLocalSetAccessToken(String key, String value) async {
  final _sharedPreferences = await SharedPreferences.getInstance();

  await _sharedPreferences.setString(key, value);
}

Future storeLocalSetLogInStatus(String key, String value) async {
  final _sharedPreferences = await SharedPreferences.getInstance();

  await _sharedPreferences.setString(key, value);
}

Future<bool> getLocalLoginStatus() async {
  final _sharedPreferences = await SharedPreferences.getInstance();
  var value = _sharedPreferences.getString(Constants.logInStatusKey);
  print('checked status =>' + value.toString());
  if (value == 'true') {
    return true;
  } else {
    return false;
  }
  //return value !=null?true:false;
}

Future<String> getLocalUserName() async {
  final _sharedPreferences = await SharedPreferences.getInstance();
  var value = _sharedPreferences.getString(Constants.userNameKey);
  //bool valueCheck = value!.isEmpty;
  print('checked user name =>' + value.toString());

  return value.toString();

  //return value !=null?true:false;
}

Future<String> getLocalUserEmailID() async {
  final _sharedPreferences = await SharedPreferences.getInstance();
  var value = _sharedPreferences.getString(Constants.userEmailKey);
  //bool valueCheck = value!.isEmpty;
  print('checked user phone =>' + value.toString());

  return value.toString();

  //return value !=null?true:false;
}

Future<String> getLocalUserTpe() async {
  final _sharedPreferences = await SharedPreferences.getInstance();
  var value = _sharedPreferences.getString(Constants.userTypeKey);
  //bool valueCheck = value!.isEmpty;
  print('checked user Type =>' + value.toString());

  return value.toString();

  //return value !=null?true:false;
}

Future<String> getLocalToken() async {
  final _sharedPreferences = await SharedPreferences.getInstance();
  var value = _sharedPreferences.getString(Constants.accessTokenKey);
  //bool valueCheck = value!.isEmpty;
  print('checked token =>' + value.toString());

  return value.toString();

  //return value !=null?true:false;
}
