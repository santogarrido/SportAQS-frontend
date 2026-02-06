import 'package:booking_calendar/booking_calendar.dart';
import 'package:flutter/material.dart';
import 'package:sportaqs/models/court.dart';
import 'package:sportaqs/models/facility.dart';
import 'package:sportaqs/models/user.dart';

class CourtBookingScreen extends StatefulWidget {
  final Court court;
  final Facility facility;
  final User user;

  const CourtBookingScreen({
    super.key,
    required this.court,
    required this.facility,
    required this.user,
  });

  @override
  State<CourtBookingScreen> createState() => _CourtBookingScreenState();
}

class _CourtBookingScreenState extends State<CourtBookingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.court.name),
        backgroundColor: const Color.fromARGB(255, 0, 229, 255),
        foregroundColor: Colors.white,
      ),
      body: BookingCalendar(
        bookingService: _bookingService(),
        getBookingStream: _getBookingStream,
        uploadBooking: _uploadBooking,
        convertStreamResultToDateTimeRanges:
            _convertStreamResultToDateTimeRanges,
        lastDay: DateTime.now().add(const Duration(days: 7)),
      ),
    );
  }

  // ---------------- TIME HELPERS ----------------

  DateTime _timeStringToDateTime(String time) {
    final parts = time.split(':');
    final now = DateTime.now();

    return DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(parts[0]),
      int.parse(parts[1]),
    );
  }

  BookingService _bookingService() {
    return BookingService(
      serviceName: widget.court.name,
      serviceDuration: widget.court.bookingDuration,
      bookingStart: _timeStringToDateTime(widget.facility.openTime),
      bookingEnd: _timeStringToDateTime(widget.facility.closeTime),
    );
  }

  // ---------------- MOCK (SIN BACKEND) ----------------

  /// De momento no hay reservas
  Stream<List<dynamic>> _getBookingStream({
    required DateTime start,
    required DateTime end,
  }) async* {
    yield [];
  }

  /// Simula crear una reserva
  Future<dynamic> _uploadBooking({required BookingService newBooking}) async {
    return true;
  }

  /// Convierte reservas → franjas ocupadas
  List<DateTimeRange> _convertStreamResultToDateTimeRanges({
    required dynamic streamResult,
  }) {
    return [];
  }
}
