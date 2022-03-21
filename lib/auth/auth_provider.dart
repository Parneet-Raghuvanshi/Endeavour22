import 'dart:convert';

import 'package:endeavour22/auth/user_model.dart';
import 'package:endeavour22/helper/http_exception.dart';
import 'package:endeavour22/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String _token = '';
  UserModel? _userModel;

  bool get isAuth {
    return token != '';
  }

  String get token {
    return _token;
  }

  UserModel? get userModel {
    return _userModel;
  }

  Future<void> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(
            'http://protected-chamber-92948.herokuapp.com/api/auth/login'),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );
      final responseData = json.decode(response.body);
      if (responseData['hasError']) {
        throw HttpException(responseData['msg']);
      }
      // LOGIN SUCCESSFUL
      _token = responseData['data']['token'];
      final userData = UserModel.fromMap(responseData['data']['user'] as Map);
      _userModel = userData;
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userToken = json.encode({'token': _token});
      prefs.setString('userToken', userToken);
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userToken')) {
      return false;
    }
    final extractedData =
        json.decode(prefs.getString('userToken')!) as Map<String, dynamic>;
    _token = extractedData['token'];
    var status = await fetchUserData(_token);
    if (!status) {
      return false;
    }
    notifyListeners();
    return true;
  }

  Future<bool> fetchUserData(String token) async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://protected-chamber-92948.herokuapp.com/api/user/getUser'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": token,
        },
      );
      final responseData = json.decode(response.body);
      if (responseData['hasError']) {
        return false;
      }
      // update userModel
      final userData = UserModel.fromMap(responseData['data'] as Map);
      _userModel = userData;
    } catch (error) {
      rethrow;
    }
    return true;
  }

  Future<void> signUp(String email, String password, String phoneNumber,
      String name, BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse(
            'http://protected-chamber-92948.herokuapp.com/api/auth/signup'),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          'email': email,
          'password': password,
          'phoneNumber': phoneNumber,
          'name': name,
        }),
      );
      final responseData = json.decode(response.body);
      if (responseData['hasError']) {
        throw HttpException(responseData['msg']);
      }
      // SIGNUP SUCCESSFUL
      CustomSnackbar().showFloatingFlushBar(
        context: context,
        message:
            "Account Created Successfully, please very you email and then longin!",
        color: Colors.lightGreen,
      );
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateProfile(String clgName, String clgId, String branch,
      String sem, BuildContext context, bool isFirstTime) async {
    try {
      final response = await http.post(
        Uri.parse(
            'http://protected-chamber-92948.herokuapp.com/api/user/updateProfile'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": token,
        },
        body: json.encode({
          'college': clgName,
          'libId': clgId,
          'branch': branch,
          'semester': sem,
        }),
      );
      final responseData = json.decode(response.body);
      print(responseData['hasError']);
      if (responseData['hasError']) {
        print(responseData['msg']);
        throw HttpException(responseData['msg']);
      }
      // Update Successful
      _userModel!.profile = true;
      CustomSnackbar().showFloatingFlushBar(
        context: context,
        message: "Profile Completed Successfully!",
        color: Colors.lightGreen,
      );
      notifyListeners();
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  Future<void> logout() async {
    _token = '';
    _userModel = null;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
