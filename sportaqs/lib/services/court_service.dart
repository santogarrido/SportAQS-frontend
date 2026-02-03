import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sportaqs/models/court_response.dart';

class CourtService {

  static const String _baseUrl = 'http://localhost:8090';

  Future<CourtsResponse> getCourts(int id, String token) async {
    Uri url = Uri.parse('$_baseUrl/courts/facility/');

    final response = await http.post(
      url,
      body: json.encode({'id' : id}),
      headers: {'Accept' : 'application/json', 'Authorization' : 'Bearer $token' , 'Content-Type' : 'application/json'}
    );

    final courtResponse = CourtsResponse.fromJson(json.decode(response.body));

    return courtResponse;

  }

}