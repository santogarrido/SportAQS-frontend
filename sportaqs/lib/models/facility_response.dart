import 'package:sportaqs/models/facility.dart';

class FacilitiesResponse {
  final bool success;
  final List<Facility> data;
  final String message;

  FacilitiesResponse({
    required this.success,
    required this.data,
    required this.message,
  });

  factory FacilitiesResponse.fromJson(Map<String, dynamic> json) => FacilitiesResponse(
    success: json["success"],
    data: (json["data"] as List)
        .map((facilityJson) => Facility.fromFacilitiesJson(facilityJson))
        .toList(),
    message: json["message"],
  );
}