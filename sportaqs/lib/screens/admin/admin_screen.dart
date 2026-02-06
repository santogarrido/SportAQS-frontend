import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportaqs/providers/facility_provider.dart';
import 'package:sportaqs/providers/user_provider.dart';
import 'package:sportaqs/screens/admin/admin_bookings_screen.dart';
import 'package:sportaqs/screens/admin/admin_facilities_screen.dart';
import 'package:sportaqs/screens/admin/admin_users_screen.dart';
import 'package:sportaqs/widgets/logout_button.dart';

class AdminScreen extends StatefulWidget{
  const AdminScreen({super.key});

  @override
  State<StatefulWidget> createState() => _AdminScreenState();

}

class _AdminScreenState extends State<AdminScreen> {
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
    const AdminUsersScreen(),
    const AdminFacilitiesScreen(),
    const AdminBookingsScreen(),
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
              context.watch<UserProvider>().activeUser?.username ?? '',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
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
            icon: Icon(Icons.person_outlined),
            activeIcon: Icon(Icons.person),
            label: 'Users',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_tennis_outlined),
            activeIcon: Icon(Icons.sports_tennis),
            label: 'Facilities',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.note_outlined),
            activeIcon: Icon(Icons.note),
            label: 'Bookings',
          )
        ],
        backgroundColor: Color.fromARGB(255, 0, 229, 255),
      ),
    );
  }
}