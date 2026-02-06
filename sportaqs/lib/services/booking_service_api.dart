import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sportaqs/models/booking.dart';
import 'package:sportaqs/models/response_api.dart';

class BookingServiceApi {
  static const String _baseUrl = 'https://sportaqs-backend.onrender.com';

  // Get all bookings of a Facility
  Future<ResponseApi> getAllBookings(int facilityId) async {
    Uri url = Uri.parse('$_baseUrl/bookings/getAllBookings/$facilityId');

    final response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );

    final responseApi = ResponseApi.fromJson(json.decode(response.body));
    return responseApi;
  }

  // Get bookings of an User
  Future<ResponseApi> getBookingsByUser(int userId) async {
    Uri url = Uri.parse('$_baseUrl/bookings/getBookingsByUser/$userId');

    final response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );

    final responseApi = ResponseApi.fromJson(json.decode(response.body));
    return responseApi;
  }

  // Get booking by id
  Future<ResponseApi> getBookingById(int bookingId) async {
    Uri url = Uri.parse('$_baseUrl/bookings/getBooking/$bookingId');

    final response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );

    final responseApi = ResponseApi.fromJson(json.decode(response.body));
    return responseApi;
  }

  // Crear una nueva reserva
  Future<ResponseApi> addBooking(
    int userId,
    int courtId,
    DateTime bookingDateTime,
    DateTime courtDateTimeBooking,
  ) async {
    Uri url = Uri.parse('$_baseUrl/bookings/addBooking');

    final response = await http.post(
      url,
      body: jsonEncode({
        'userId': userId,
        'courtId': courtId,
        'bookingDateTime': bookingDateTime,
        'courtDateTimeBooking': courtDateTimeBooking,
      }),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );

    final responseApi = ResponseApi.fromJson(json.decode(response.body));
    return responseApi;
  }

  // Delete booking
  Future<ResponseApi> deleteBooking(int bookingId) async {
    Uri url = Uri.parse('$_baseUrl/bookings/deleteBooking/$bookingId');

    final response = await http.delete(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );

    final responseApi = ResponseApi.fromJson(json.decode(response.body));
    return responseApi;
  }
}
