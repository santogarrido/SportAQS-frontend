import 'package:booking_calendar/booking_calendar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportaqs/models/court.dart';
import 'package:sportaqs/models/facility.dart';
import 'package:sportaqs/providers/booking_provider.dart';
import 'package:sportaqs/providers/user_provider.dart';

class AdminCourtBookingScreen extends StatefulWidget {
  final Court court;
  final Facility facility;

  const AdminCourtBookingScreen({
    super.key,
    required this.court,
    required this.facility,
  });

  @override
  State<AdminCourtBookingScreen> createState() =>
      _AdminCourtBookingScreenState();
}

class _AdminCourtBookingScreenState extends State<AdminCourtBookingScreen> {
  late BookingProvider bookingProvider;
  late UserProvider userProvider;

  @override
  void initState() {
    super.initState();
    bookingProvider = context.read<BookingProvider>();
    userProvider = context.read<UserProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Block hours - ${widget.court.name}'),
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
        loadingWidget: const Center(child: CircularProgressIndicator()),
        uploadingWidget: const Center(child: CircularProgressIndicator()),
      ),
    );
  }

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
    final openTimeParts = widget.facility.openTime.split(':');
    final closeTimeParts = widget.facility.closeTime.split(':');
    final today = DateTime.now();

    return BookingService(
      serviceName: widget.court.name,
      serviceDuration: widget.court.bookingDuration,
      bookingStart: DateTime(
        today.year,
        today.month,
        today.day,
        int.parse(openTimeParts[0]),
        int.parse(openTimeParts[1]),
      ),
      bookingEnd: DateTime(
        today.year,
        today.month,
        today.day,
        int.parse(closeTimeParts[0]),
        int.parse(closeTimeParts[1]),
      ),
    );
  }

  Stream<List<dynamic>> _getBookingStream({
    required DateTime start,
    required DateTime end,
  }) async* {
    await bookingProvider.getBookingsByCourt(widget.court.id);
    yield bookingProvider.bookings;
  }

  Future<dynamic> _uploadBooking({required BookingService newBooking}) async {
    final bookingDateTime = DateTime.now();
    final courtDateTimeBooking = newBooking.bookingStart;

    await bookingProvider.addBooking(
      userId: userProvider.activeUser!.id!,
      courtId: widget.court.id,
      bookingDateTime: bookingDateTime,
      courtDateTimeBooking: courtDateTimeBooking,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Hour blocked successfully'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );

    await bookingProvider.getBookingsByCourt(widget.court.id);
    return true;
  }

  List<DateTimeRange> _convertStreamResultToDateTimeRanges({
    required dynamic streamResult,
  }) {
    final List<DateTimeRange> blockedRanges = [];
    final bookings = streamResult as List;
    final now = DateTime.now();

    // Existing bookings
    for (final b in bookings) {
      final start = b.courtDateTimeBooking;
      final end = start.add(Duration(minutes: widget.court.bookingDuration));

      blockedRanges.add(DateTimeRange(start: start, end: end));
    }

    // Block past hours
    final opening = _timeStringToDateTime(widget.facility.openTime);
    final closing = _timeStringToDateTime(widget.facility.closeTime);

    DateTime cursor = opening;

    while (cursor.isBefore(now) && cursor.isBefore(closing)) {
      final end = cursor.add(Duration(minutes: widget.court.bookingDuration));

      blockedRanges.add(DateTimeRange(start: cursor, end: end));
      cursor = end;
    }

    return blockedRanges;
  }
}
