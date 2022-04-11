import 'dart:convert';

import 'package:endeavour22/auth/user_model.dart';
import 'package:endeavour22/events/regietered_model.dart';
import 'package:endeavour22/helper/constants.dart';
import 'package:endeavour22/helper/http_exception.dart';
import 'package:endeavour22/widgets/custom_snackbar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  String _token = '';
  UserModel? _userModel;
  List<RegisteredModel> _registered = [];

  bool get isAuth {
    return _token != '';
  }

  String get token {
    return _token;
  }

  UserModel? get userModel {
    return _userModel;
  }

  List<RegisteredModel> get registered {
    return _registered;
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
      await fetchRegistered(token);
      // SUBSCRIBE TO FIREBASE MESSAGING SERVICE
      await FirebaseMessaging.instance.subscribeToTopic('Listen');
      // SETTING UP LOCAL DATA
      const storage = FlutterSecureStorage();
      await storage.write(key: 'userToken', value: _token);
      await storage.write(key: 'userId', value: _userModel!.id);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> tryAutoLogin(BuildContext context) async {
    const storage = FlutterSecureStorage();
    var check = await storage.containsKey(key: 'userToken');
    if (!check) {
      // UNSUBSCRIBE FROM THE FIREBASE MESSAGING SERVICE
      await FirebaseMessaging.instance.unsubscribeFromTopic('Listen');
      return;
    }
    var userToken = await storage.read(key: 'userToken');
    _token = userToken.toString();
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
        // UNSUBSCRIBE FROM THE FIREBASE MESSAGING SERVICE
        await FirebaseMessaging.instance.unsubscribeFromTopic('Listen');
        return false;
      }
      // update userModel
      final userData = UserModel.fromMap(responseData['data'] as Map);
      _userModel = userData;
      await fetchRegistered(token);
      notifyListeners();
      return true;
    } catch (error) {
      rethrow;
    }
  }

  Future<void> fetchRegistered(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$serverURL/api/user/registeredEvents'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": token,
        },
      );
      final responseData = json.decode(response.body);
      if (responseData['hasError']) {
        return;
      }
      // update registered...
      final List<RegisteredModel> tempList = [];
      for (var element in responseData['data']) {
        tempList.add(RegisteredModel.fromMap(element));
      }
      _registered = tempList;
      notifyListeners();
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
    } catch (error) {
      rethrow;
    }
  }

  Future<void> forgotPassword(String email, BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse('$serverURL/api/auth/forgotpassword'),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          'email': email,
        }),
      );
      final responseData = json.decode(response.body);
      if (responseData['hasError']) {
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

  Future<void> changePassword(
      String oldPass, String newPass, BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse('$serverURL/api/user/changePassword'),
        headers: {
          "content-Type": "application/json",
          "Authorization": token,
        },
        body: json.encode({
          'oldPassword': oldPass,
          'newPassword': newPass,
        }),
      );
      final responseData = json.decode(response.body);
      print(responseData);
      if (responseData['hasError']) {
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
    _registered = [];
    notifyListeners();
    const storage = FlutterSecureStorage();
    storage.deleteAll();
    // UNSUBSCRIBE FROM THE FIREBASE MESSAGING SERVICE
    await FirebaseMessaging.instance.unsubscribeFromTopic('Listen');
  }
}
