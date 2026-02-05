// import 'package:eventify/providers/event_provider.dart';
// import 'package:eventify/providers/user_provider.dart';
// import 'package:eventify/screens/login/login_screen.dart';
// import 'package:eventify/screens/user/events_screen.dart';
// import 'package:eventify/screens/user/home_screen.dart';
// import 'package:eventify/screens/user/my_events_screen.dart';
// import 'package:eventify/screens/user/report_screen.dart';
// import 'package:eventify/widgets/filter_button.dart';
// import 'package:eventify/widgets/logout_button.dart';
// import 'package:eventify/widgets/user_avatar.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:provider/provider.dart';
import 'package:sportaqs/providers/facility_provider.dart';
import 'package:sportaqs/providers/user_provider.dart';
import 'package:sportaqs/screens/user/bookings_screen.dart';
import 'package:sportaqs/screens/user/facilities_screen.dart';
import 'package:sportaqs/widgets/logout_button.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<StatefulWidget> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  int currentIndex = 0;
  bool showFilterButtons = false;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<FacilityProvider>().getFacilities();
    });

    // final eventProvider = context.read<EventProvider>().getEvents();
  }

  final List<Widget> _pages = [
    // const Center(child: Text('Home')),
    const FacilitiesScreen(),
    const BookingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    // final eventProvider = Provider.of<EventProvider>(context);

    return Scaffold(
      backgroundColor: Color(0xFFEFEFF0),
      appBar: AppBar(
        title: Row(
          children: [
            const SizedBox(width: 16,),
            Expanded(child: Text(
              context.watch<UserProvider>().activeUser?.name ?? '',
            ))
          ],
        ) ,
        elevation: 15,
        backgroundColor: Color.fromARGB(255, 0, 229, 255),
        actions: [
          LogoutButton()
        ],
      ),
      //body
      body: IndexedStack(index: currentIndex, children: _pages),

      //Bottom navbar
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,  //para que no cambie a shifting
        currentIndex: currentIndex,
        onTap: (index) => setState(() => currentIndex = index),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_outlined),
            activeIcon: Icon(Icons.event),
            label: 'Events',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_outlined),
            activeIcon: Icon(Icons.event),
            label: 'My Events',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.picture_as_pdf_outlined),
            activeIcon: Icon(Icons.picture_as_pdf),
            label: 'Report',
          ),
        ],
        backgroundColor: Color.fromARGB(255, 0, 229, 255),
      ),
    );
  }
}
