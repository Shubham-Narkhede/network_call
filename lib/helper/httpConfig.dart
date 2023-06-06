import 'dart:convert';

import 'package:http/http.dart' as http;

import 'ApiHelper.dart';

enum ErrorType { Error, Success }

class HttpMethod {
  String apiUrl;
  Map<String, dynamic>? body;
  String? stringBody;

  HttpMethod({required this.apiUrl, this.body, this.stringBody});

  Future<dynamic> getData() async {
    final url = Uri.parse(apiUrl);
    print("URL: $url");

    final response = await http.get(
      url,
    );
    print("Response: ${response.body}");

    try {
      dynamic data = json.decode(response.body);
      return response.statusCode != 200
          ? [ErrorType.Error, response.body]
          : [ErrorType.Success, data];
    } catch (e) {
      return [ErrorType.Error, e];
    }
  }
}

// https://github.com/r-spacex/SpaceX-API/blob/master/docs/rockets/v4/all.md
