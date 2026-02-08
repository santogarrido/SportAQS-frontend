import 'package:booking_calendar/booking_calendar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportaqs/models/court.dart';
import 'package:sportaqs/models/facility.dart';
import 'package:sportaqs/models/user.dart';
import 'package:sportaqs/providers/booking_provider.dart';

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
  late BookingProvider bookingProvider;

  @override
  void initState() {
    super.initState();

    bookingProvider = Provider.of<BookingProvider>(context, listen: false);
  }

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
        loadingWidget: const Center(child: CircularProgressIndicator()),
        uploadingWidget: const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  // Parse String to DateTime
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

  // Create BookingService for the calendar
  BookingService _bookingService() {
    return BookingService(
      serviceName: widget.court.name,
      serviceDuration: widget.court.bookingDuration,
      bookingStart: _timeStringToDateTime(widget.facility.openTime),
      bookingEnd: _timeStringToDateTime(widget.facility.closeTime),
    );
  }

  // Get the bookings of this court
  Stream<List<dynamic>> _getBookingStream({
    required DateTime start,
    required DateTime end,
  }) async* {
    await bookingProvider.getBookingsByCourt(widget.court.id);
    yield bookingProvider.bookings;
  }

  //Create the book at the selected time
  Future<dynamic> _uploadBooking({required BookingService newBooking}) async {
    final now = DateTime.now();
    final courtDateTimeBooking = newBooking.bookingStart;

    if (courtDateTimeBooking.isBefore(now)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("A past hour can't be booked"),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 2),
        ),
      );
      return false;
    }

    final bookingDateTime = DateTime.now();

    await bookingProvider.addBooking(
      userId: widget.user.id!,
      courtId: widget.court.id,
      bookingDateTime: bookingDateTime,
      courtDateTimeBooking: courtDateTimeBooking,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Booking successful!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
    await bookingProvider.getBookingsByCourt(widget.court.id);

    return true;
  }

  // Load unavailable hours
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
