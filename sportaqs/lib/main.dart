import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportaqs/providers/booking_provider.dart';

import 'package:sportaqs/providers/user_provider.dart';
import 'package:sportaqs/providers/facility_provider.dart';
import 'package:sportaqs/providers/court_provider.dart';
import 'package:sportaqs/services/booking_service_api.dart';

import 'package:sportaqs/services/user_service.dart';

import 'package:sportaqs/screens/login_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        // USER PROVIDER
        ChangeNotifierProvider(
          create: (context) => UserProvider(UserService()),
        ),

        // FACILITY PROVIDER 
        ChangeNotifierProxyProvider<UserProvider, FacilityProvider>(
          create: (context) => FacilityProvider(
            Provider.of<UserProvider>(context, listen: false),
          ),
          update: (context, userProvider, facilityProvider) =>
              facilityProvider ?? FacilityProvider(userProvider),
        ),

        // COURT PROVIDER 
        ChangeNotifierProxyProvider<UserProvider, CourtProvider>(
          create: (context) =>
              CourtProvider(Provider.of<UserProvider>(context, listen: false)),
          update: (context, userProvider, courtProvider) =>
              courtProvider ?? CourtProvider(userProvider),
        ),

        // BOOKING PROVIDER
        ChangeNotifierProxyProvider<UserProvider, BookingProvider>(
          create: (context) => BookingProvider(
            BookingServiceApi(),
            Provider.of<UserProvider>(context, listen: false),
          ),
          update: (context, userProvider, bookingProvider) =>
              bookingProvider ??
              BookingProvider(BookingServiceApi(), userProvider),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SportAQS',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const LoginScreen(),
    );
  }
}
