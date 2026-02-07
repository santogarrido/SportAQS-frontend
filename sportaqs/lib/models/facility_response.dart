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

  factory FacilitiesResponse.fromJson(Map<String, dynamic> json) {
    List<Facility> parsedData = [];

    if (json['data'] != null) {
      if (json['data'] is Map<String, dynamic>) {
        parsedData = [Facility.fromFacilitiesJson(json['data'])];
      } else if (json['data'] is List) {
        parsedData = (json['data'] as List)
            .map((f) => Facility.fromFacilitiesJson(f))
            .toList();
      }
    }

    return FacilitiesResponse(
      success: json['success'] ?? false,
      data: parsedData,
      message: json['message'] ?? '',
    );
  }
}