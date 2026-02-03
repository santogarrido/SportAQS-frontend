import 'package:sportaqs/models/court.dart';

class CourtsResponse {
  final bool success;
  final List<Court> data;
  final String message;

  CourtsResponse({
    required this.success,
    required this.data,
    required this.message,
  });

  factory CourtsResponse.fromJson(Map<String, dynamic> json) => CourtsResponse(
    success: json["success"],
    data: (json["data"] as List)
        .map((courtJson) => Court.fromCourtsJson(courtJson))
        .toList(),
    message: json["message"],
  );
}