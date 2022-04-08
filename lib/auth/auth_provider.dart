import 'dart:convert';

import 'package:endeavour22/auth/user_model.dart';
import 'package:endeavour22/helper/constants.dart';
import 'package:endeavour22/helper/http_exception.dart';
import 'package:endeavour22/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String _token = '';
  UserModel? _userModel;

  bool get isAuth {
    return _token != '';
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
        Uri.parse('$serverURL/api/auth/login'),
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

  Future<void> tryAutoLogin(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userToken')) {
      return;
    }
    final extractedData =
        json.decode(prefs.getString('userToken')!) as Map<String, dynamic>;
    _token = extractedData['token'];
    var status = await fetchUserData(_token);
    if (!status) {
      _token = '';
      showErrorFlush(
        context: context,
        message: "User Session Expired please login again!",
      );
      return;
    }
    notifyListeners();
  }

  Future<bool> fetchUserData(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$serverURL/api/user/getUser'),
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
      notifyListeners();
      return true;
    } catch (error) {
      rethrow;
    }
  }

  Future<void> signUp(String email, String password, String phoneNumber,
      String name, BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse('$serverURL/api/auth/signup'),
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
      showNormalFlush(
        context: context,
        message:
            "Account Created Successfully, please very you email and then longin!",
      );
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> forgotPassword(String email, BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse('$serverURL/api/auth/forgotpassword'),
        headers: {"Content-Type": "application/json"},
        body: json.encode({'email': email}),
      );
      final responseData = json.decode(response.body);
      if (responseData['error']) {
        throw HttpException(responseData['msg']);
      }
      // REQUEST SEND
      showNormalFlush(
        context: context,
        message: responseData['msg'],
      );
    } catch (error) {
      print(error.toString());
    }
  }

  Future<void> changePassword(String email, String oldPass, String newPass,
      BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse('$serverURL/api/user/changePassword'),
        headers: {"content-Type": "application/json"},
        body: json.encode({
          'email': email,
          'oldPassword': oldPass,
          'newPassword': newPass,
        }),
      );
      final responseData = json.decode(response.body);
      if (responseData['error']) {
        throw HttpException(responseData['msg']);
      }
      // CHANGE PASSWORD LINK SEND
      showNormalFlush(
        context: context,
        message: responseData['msg'],
      );
    } catch (error) {
      print(error.toString());
    }
  }

  Future<void> updateProfile(String clgName, String clgId, String branch,
      String sem, String name, BuildContext context, bool isFirstTime) async {
    try {
      final response = await http.post(
        Uri.parse('$serverURL/api/user/updateProfile'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": token,
        },
        body: json.encode({
          'college': clgName,
          'libId': clgId,
          'branch': branch,
          'semester': sem,
          'name': name,
        }),
      );
      final responseData = json.decode(response.body);
      if (responseData['hasError']) {
        throw HttpException(responseData['msg']);
      }
      // Again Fetch UserData
      await fetchUserData(_token);
      // Update Successful
      if (isFirstTime) {
        showNormalFlush(
          context: context,
          message: "Profile Completed Successfully!",
        );
      } else {
        Navigator.of(context).pop();
        showNormalFlush(
          context: context,
          message: "Profile Updated Successfully!",
        );
      }
      notifyListeners();
    } catch (error) {
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
