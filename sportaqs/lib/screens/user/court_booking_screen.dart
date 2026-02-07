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
    final bookingDateTime = DateTime.now();
    final courtDateTimeBooking = newBooking.bookingStart;

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
    final bookings = streamResult as List;

    return bookings.map<DateTimeRange>((b) {
      final start = b.courtDateTimeBooking;
      final end = start.add(Duration(minutes: widget.court.bookingDuration));

      return DateTimeRange(start: start, end: end);
    }).toList();
  }
}
