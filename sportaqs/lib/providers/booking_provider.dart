import 'package:flutter/material.dart';
import 'package:sportaqs/models/booking.dart';
import 'package:sportaqs/models/response_api.dart';
import 'package:sportaqs/services/booking_service_api.dart';

class BookingProvider extends ChangeNotifier {
  final BookingServiceApi bookingService;
  String? errorMessage;
  bool loading = false;
  List<Booking> bookings = [];

  BookingProvider(this.bookingService);

  // Get bookings by facility
  Future<void> getBookingsByFacility(int facilityId) async {
    loading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final ResponseApi response = await bookingService.getAllBookings(
        facilityId,
      );

      if (response.success && response.data != null) {
        bookings = (response.data as List)
            .map((e) => Booking.fromJson(e))
            .toList();
      } else {
        bookings = [];
        errorMessage = response.message;
      }
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  // Get bookings by user
  Future<void> getBookingsByUser(int userId) async {
    loading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final ResponseApi response = await bookingService.getBookingsByUser(
        userId,
      );

      if (response.success && response.data != null) {
        bookings = (response.data as List)
            .map((e) => Booking.fromJson(e))
            .toList();
      } else {
        bookings = [];
        errorMessage = response.message;
      }
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  // Add booking
  Future<void> addBooking({
    required int userId,
    required int courtId,
    required DateTime bookingDateTime,
    required DateTime courtDateTimeBooking,
  }) async {
    loading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final ResponseApi response = await bookingService.addBooking(
        userId,
        courtId,
        bookingDateTime,
        courtDateTimeBooking,
      );

      if (response.success && response.data != null) {
        final newBooking = Booking.fromJson(response.data);
        bookings.add(newBooking);
        notifyListeners();
      } else {
        errorMessage = response.message;
      }
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  // Delete
  Future<bool> deleteBooking(int bookingId) async {
    loading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final ResponseApi response = await bookingService.deleteBooking(
        bookingId,
      );

      if (response.success) {
        bookings.removeWhere((b) => b.id == bookingId);
        notifyListeners();
        return true;
      } else {
        errorMessage = response.message;
        return false;
      }
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
