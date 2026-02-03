import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sportaqs/models/court_response.dart';

class CourtService {

  static const String _baseUrl = 'http://localhost:8090';

  Future<CourtsResponse> getCourts(int id, String token) async {
    Uri url = Uri.parse('$_baseUrl/courts/facility/$id');

    final response = await http.get(
      url,
      headers: {'Accept' : 'application/json', 'Authorization' : 'Bearer $token' , 'Content-Type' : 'application/json'}
    );

    final courtResponse = CourtsResponse.fromJson(json.decode(response.body));

    return courtResponse;

  }

  Future<CourtsResponse> getCourtById(int id, String token) async {
    Uri url = Uri.parse('$_baseUrl/courts/$id');

    final response = await http.get(
      url,
      headers: {'Accept' : 'application/json', 'Authorization' : 'Bearer $token' , 'Content-Type' : 'application/json'}      
    );

    final courtResponse = CourtsResponse.fromJson(json.decode(response.body));

    return courtResponse;

  }

  Future<CourtsResponse> addCourt(String name, String category, int bookingDuration, int facilityId, String token) async {
    Uri url = Uri.parse('$_baseUrl/courts');

    final response = await http.post(
      url,
      body: ({'name' : name, 'category' : category, 'bookingDuration' : bookingDuration, 'facilityId' : facilityId}),
      headers: {'Accept' : 'application/json', 'Authorization' : 'Bearer $token' , 'Content-Type' : 'application/json'}
    );

    final courtResponse = CourtsResponse.fromJson(json.decode(response.body));

    return courtResponse;
  }

  Future<CourtsResponse> updateCourt(int id, String name, String category, int bookingDuration, int facilityId, String token) async {
    Uri url = Uri.parse('$_baseUrl/courts/$id');

    final response = await http.put(
      url,
      body: ({'name' : name, 'category' : category, 'bookingDuration' : bookingDuration, 'facilityId' : facilityId}),
      headers: {'Accept' : 'application/json', 'Authorization' : 'Bearer $token' , 'Content-Type' : 'application/json'}
    );

    final courtResponse = CourtsResponse.fromJson(json.decode(response.body));

    return courtResponse;
  }

  Future<CourtsResponse> deleteCourt(int id, String token) async {
    Uri url = Uri.parse('$_baseUrl/courts/$id');

    final response = await http.delete(
      url,
      headers: {'Accept' : 'application/json', 'Authorization' : 'Bearer $token' , 'Content-Type' : 'application/json'}
    );

    final courtResponse = CourtsResponse.fromJson(json.decode(response.body));

    return courtResponse;
  }

  Future<CourtsResponse> activateCourt(int id, String token) async {
    Uri url = Uri.parse('$_baseUrl/courts/$id/activate');

    final response = await http.put(
      url,
      headers: {'Accept' : 'application/json', 'Authorization' : 'Bearer $token' , 'Content-Type' : 'application/json'}
    );

    final courtResponse = CourtsResponse.fromJson(json.decode(response.body));

    return courtResponse;
  }

  Future<CourtsResponse> deactivateCourt(int id, String token) async {
    Uri url = Uri.parse('$_baseUrl/courts/$id/deactivate');

    final response = await http.put(
      url,
      headers: {'Accept' : 'application/json', 'Authorization' : 'Bearer $token' , 'Content-Type' : 'application/json'}
    );

    final courtResponse = CourtsResponse.fromJson(json.decode(response.body));

    return courtResponse;
  }

}