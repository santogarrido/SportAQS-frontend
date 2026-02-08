import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportaqs/providers/booking_provider.dart';
import 'package:sportaqs/widgets/booking_card.dart';

class AdminBookingsScreen extends StatefulWidget {
  const AdminBookingsScreen({super.key});

  @override
  State<AdminBookingsScreen> createState() => _AdminBookingsScreenState();
}

class _AdminBookingsScreenState extends State<AdminBookingsScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final bookingProvider = context.read<BookingProvider>();
      bookingProvider.getAllBookings();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text('Bookings')),
      body: Consumer<BookingProvider>(
        builder: (context, bookingProvider, _) {
          if (bookingProvider.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (bookingProvider.errorMessage != null) {
            return Center(
              child: Text(
                bookingProvider.errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          final now = DateTime.now();
          final activeBookings = bookingProvider.bookings
              .where((b) => !b.deleted && b.courtDateTimeBooking.isAfter(now))
              .toList();

          if (activeBookings.isEmpty) {
            return const Center(child: Text('No bookings found'));
          }

          return RefreshIndicator(
            onRefresh: () async {
              await bookingProvider.getAllBookings();
            },
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: activeBookings.length,
              itemBuilder: (context, index) {
                final booking = activeBookings[index];
                return BookingCard(booking: booking);
              },
            ),
          );
        },
      ),
    );
  }
}
