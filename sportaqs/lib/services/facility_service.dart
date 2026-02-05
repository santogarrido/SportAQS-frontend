import "dart:convert";

import "package:http/http.dart" as http;
import "package:sportaqs/models/facility_response.dart";

class FacilityService {

  //static const String _baseUrl = 'http://localhost:8090'; 
  static const String _baseUrl = 'http://10.0.2.2:8090';

  Future<FacilitiesResponse> getFacilities(String token) async {

    Uri url = Uri.parse('$_baseUrl/getAll');

    final response = await http.get(
      url,
      headers: {'Accept' : 'application/json', 'Authorization' : 'Bearer $token' , 'Content-Type' : 'application/json'}
    );

    final facilityResponse = FacilitiesResponse.fromJson(json.decode(response.body));

    return facilityResponse;
  }

  Future<FacilitiesResponse> getFacilityById(int id, String token) async {
    Uri url = Uri.parse('$_baseUrl/getFacility/$id');

    final response = await http.get(
      url,
      headers: {'Accept' : 'application/json', 'Authorization' : 'Bearer $token' , 'Content-Type' : 'application/json'}
    );

    final facilityResponse = FacilitiesResponse.fromJson(json.decode(response.body));

    return facilityResponse; 

  }

  Future<FacilitiesResponse> addFacility(String name, String openTime, String closeTime, String location, String token) async {
    Uri url = Uri.parse('$_baseUrl/addFacility');

    final response = await http.post(
      url,
      body: ({'name' : name, 'openTime' : openTime, 'closeTime' : closeTime, 'location' : location}),
      headers: {'Accept' : 'application/json', 'Authorization' : 'Bearer $token' , 'Content-Type' : 'application/json'}
    );

    final facilityResponse = FacilitiesResponse.fromJson(json.decode(response.body));

    return facilityResponse;

  }  

  Future<FacilitiesResponse> deleteFacility(int id, String token) async {
    Uri url = Uri.parse('$_baseUrl/deleteFacility/$id');

    final response = await http.delete(
      url,
      headers: {'Accept' : 'application/json', 'Authorization' : 'Bearer $token' , 'Content-Type' : 'application/json'}
    );

    final facilityResponse = FacilitiesResponse.fromJson(json.decode(response.body));

    return facilityResponse;

  }

  Future<FacilitiesResponse> activateFacility(int id, String token) async {
    Uri url = Uri.parse('$_baseUrl/activateFacility/$id');

    final response = await http.post(
      url,
      headers: {'Accept' : 'application/json', 'Authorization' : 'Bearer $token' , 'Content-Type' : 'application/json'}
    );

    final facilityResponse = FacilitiesResponse.fromJson(json.decode(response.body));

    return facilityResponse;

  }

  Future<FacilitiesResponse> deactivateFacility(int id, String token) async {
    Uri url = Uri.parse('$_baseUrl/deactivateFacility/$id');

    final response = await http.post(
      url,
      headers: {'Accept' : 'application/json', 'Authorization' : 'Bearer $token' , 'Content-Type' : 'application/json'}
    );

    final facilityResponse = FacilitiesResponse.fromJson(json.decode(response.body));

    return facilityResponse;

  }

  Future<FacilitiesResponse> updateFacility(int id, String name, String openTime, String closeTime, String location, String token) async {
    Uri url = Uri.parse('$_baseUrl/updateFacility/$id');

    final response = await http.put(
      url,
      headers: {'Accept' : 'application/json', 'Authorization' : 'Bearer $token' , 'Content-Type' : 'application/json'}
    );

    final facilityResponse = FacilitiesResponse.fromJson(json.decode(response.body));

    return facilityResponse;
    
  }

}