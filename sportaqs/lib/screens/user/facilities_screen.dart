import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportaqs/providers/facility_provider.dart';
import 'package:sportaqs/providers/user_provider.dart';
import 'package:sportaqs/screens/user/courts_screen.dart';
//import 'package:sportaqs/providers/user_provider.dart';
import 'package:sportaqs/widgets/facility_card.dart';

class FacilitiesScreen extends StatefulWidget {
  const FacilitiesScreen({super.key});

  @override
  State<FacilitiesScreen> createState() => _FacilitiesScreenState();
}

class _FacilitiesScreenState extends State<FacilitiesScreen> {
  @override
  Widget build(BuildContext context) {

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final facilityProvider = Provider.of<FacilityProvider>(context);

    if(facilityProvider.isLoading){
      return const Center(child: CircularProgressIndicator());
    }

    if(facilityProvider.errorMessage != null){
      return Center(child: Text(facilityProvider.errorMessage!));
    }

    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: facilityProvider.getFacilitiesForUsers,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: facilityProvider.facilitiesForUsers.isEmpty
                ? [
                    SizedBox(
                      height: MediaQuery.of(context).size.height - 100,
                      child: const Center(
                        child: Text("No hay eventos disponibles"),
                      ),
                    ),
                  ]
                  : facilityProvider.facilitiesForUsers.map(
                      (facility) => FacilityCard(
                        facility: facility,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CourtsScreen(
                                facility: facility,
                                activeUser: userProvider.activeUser!,
                              ),
                            ),
                          );
                        },
                      ),
                    ).toList(),
          ),
        ),
      ],
    );
  }
}