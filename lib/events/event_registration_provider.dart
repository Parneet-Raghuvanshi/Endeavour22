import 'dart:convert';

import 'package:endeavour22/helper/constants.dart';
import 'package:endeavour22/helper/http_exception.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EventRegistrationProvider with ChangeNotifier {
  Future<PayResponse?> registerEvent(String leaderId, List<String> members,
      String eventId, String token) async {
    // member [0] = leaderId itself
    try {
      final response = await http.post(
        Uri.parse('$serverURL/api/user/register/$eventId'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": token,
        },
        body: json.encode({
          'leaderId': leaderId,
          'members': members,
        }),
      );
      final responseData = json.decode(response.body);
      if (responseData['hasError']) {
        throw HttpException(responseData['msg']);
      }
      final payRes = PayResponse.fromMap(responseData['data'] as Map);
      return payRes;
    } catch (error) {
      rethrow;
    }
  }
}

class PayResponse {
  String id;
  int amount;
  String currency;

  PayResponse({
    required this.id,
    required this.amount,
    required this.currency,
  });

  factory PayResponse.fromMap(Map map) {
    return PayResponse(
      id: map['id'],
      amount: map['amount'],
      currency: map['currency'],
    );
  }
}
