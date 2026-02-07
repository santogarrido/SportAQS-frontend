import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportaqs/providers/booking_provider.dart';
import 'package:sportaqs/providers/user_provider.dart';
import 'package:sportaqs/widgets/booking_card.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final userProvider = context.read<UserProvider>();
      final bookingProvider = context.read<BookingProvider>();

      // Load bookings
      bookingProvider.getBookingsByUser(userProvider.activeUser!.id!);
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.read<UserProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('My Bookings')),
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
          final activeBookings = bookingProvider.myBookings
              .where((b) => !b.deleted && b.courtDateTimeBooking.isAfter(now))
              .toList();

          if (activeBookings.isEmpty) {
            return const Center(child: Text('No bookings found'));
          }

          return RefreshIndicator(
            onRefresh: () async {
              await bookingProvider.getBookingsByUser(
                userProvider.activeUser!.id!,
              );
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
