import 'dart:convert';

import 'package:http/http.dart' as http;

String url = 'https://droid-test-server.doubletapp.ru/api/habit';
String urlForPost = 'https://droid-test-server.doubletapp.ru/api/habit_done';

final Map<String, String> headers = {
  'Authorization': "efb79c8f-3e90-4115-8982-8bf11cc398ef",
  'accept': 'application/json',
  'Content-Type': 'application/json'
};

class NetworkUtils {
  Future<List<dynamic>> get() async {
    final Uri fullUrl = Uri.parse(url);

    final response = await http.get(fullUrl, headers: headers);
    return jsonDecode(response.body);
  }

  Future<String> put({Map<String, dynamic> habit}) async {
    final Uri fullUrl = Uri.parse(url);
    final String body = jsonEncode(habit);
    final response = await http.put(fullUrl, headers: headers, body: body);
    return jsonDecode(response.body)['uid'];
  }

  Future<int> delete({String habitUid}) async {
    final Uri fullUrl = Uri.parse(url);
    final String body = jsonEncode({"uid": habitUid});
    final response = await http.delete(fullUrl, headers: headers, body: body);
    return response.statusCode;
  }

  void post({int date, String habitUid}) async {
    final Uri fullUrl = Uri.parse(urlForPost);
    final String body = jsonEncode({"date": date, "habit_uid": habitUid});
    final response = await http.post(fullUrl, headers: headers, body: body);
  }
}
