import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert' as convert;
import 'package:http_auth/http_auth.dart';

class PaypalServices {
  // String domain = "https://api.sandbox.paypal.com"; // for sandbox mode
  String domain = "https://api.paypal.com"; // for production mode

  // for getting the access token from Paypal
  Future<String?> getAccessToken({
    @required String? clientId,
    @required String? secret,
    @required String? mode,
  }) async {
    if (mode == "sandbox") domain = "https://api.sandbox.paypal.com";
    try {
      var client = BasicAuthClient(clientId!, secret!);
      var response = await client.post(
          Uri.parse('$domain/v1/oauth2/token?grant_type=client_credentials'));
      if (response.statusCode == 200) {
        final body = convert.jsonDecode(response.body);
        return body["access_token"];
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  // for creating the payment request with Paypal
  Future<Map<String, String>?> createPaypalPayment(
      transactions, accessToken, mode) async {
    if (mode == "sandbox") domain = "https://api.sandbox.paypal.com";
    try {
      var response = await http.post(
        Uri.parse("$domain/v1/payments/payment"),
        body: convert.jsonEncode(transactions),
        headers: {
          "content-type": "application/json",
          'Authorization': 'Bearer ' + accessToken
        },
      );

      final body = convert.jsonDecode(response.body);
      if (response.statusCode == 201) {
        if (body["links"] != null && body["links"].length > 0) {
          List links = body["links"];

          String executeUrl = "";
          String approvalUrl = "";
          final item = links.firstWhere((o) => o["rel"] == "approval_url",
              orElse: () => null);
          if (item != null) {
            approvalUrl = item["href"];
          }
          final item1 = links.firstWhere((o) => o["rel"] == "execute",
              orElse: () => null);
          if (item1 != null) {
            executeUrl = item1["href"];
          }
          return {"executeUrl": executeUrl, "approvalUrl": approvalUrl};
        }
        return null;
      } else {
        throw Exception(body["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }

  // for executing the payment transaction
  Future<List<String>?> executePayment(url, payerId, accessToken) async {
    try {
      var response = await http.post(
        Uri.parse(url),
        body: convert.jsonEncode({"payer_id": payerId}),
        headers: {
          "content-type": "application/json",
          'Authorization': 'Bearer ' + accessToken
        },
      );

      final body = convert.jsonDecode(response.body);
      if (response.statusCode == 200) {
        var saleId =
            "${body['transactions'][0]['related_resources'][0]['sale']['id']}";
        List<String> ls = ["${body['id']}", saleId];
        return ls;
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }
}
