import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:sportaqs/models/facility.dart';
import 'package:sportaqs/providers/facility_provider.dart';
import 'package:sportaqs/screens/admin/admin_courts_screen.dart';
import 'package:sportaqs/screens/admin/admin_create_facility_screen.dart';
import 'package:sportaqs/screens/admin/admin_edit_facility_screen.dart';
import 'package:sportaqs/widgets/admin/admin_facility_card.dart';

class AdminFacilitiesScreen extends StatefulWidget {
  const AdminFacilitiesScreen({super.key});

  @override
  State<AdminFacilitiesScreen> createState() => _AdminFacilitiesScreenState();
}

class _AdminFacilitiesScreenState extends State<AdminFacilitiesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final facilityProvider = context.read<FacilityProvider>();
      facilityProvider.getFacilities();
    });
  }

  Future<void> _refreshFacilities() async {
    final facilityProvider = context.read<FacilityProvider>();
    await facilityProvider.getFacilities();
  }

  @override
  Widget build(BuildContext context) {
    final parentContext = context;
    final facilityProvider = Provider.of<FacilityProvider>(context);
    List<Facility> facilities = facilityProvider.facilities;

    return Scaffold(
      body: facilityProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : facilityProvider.errorMessage != null
          ? Center(child: Text(facilityProvider.errorMessage!))
          : RefreshIndicator(
              onRefresh: _refreshFacilities,
              child: ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: facilities.length,
                itemBuilder: (context, index) {
                  final facility = facilities[index];

                  return Slidable(
                    key: ValueKey(facility.id),
                    startActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (_) async {
                            if (facility.activated) {
                              await facilityProvider.deactivateFacility(
                                facility.id,
                              );
                            } else {
                              await facilityProvider.activateFacility(
                                facility.id,
                              );
                            }
                            await facilityProvider.getFacilities();
                            ScaffoldMessenger.of(parentContext).showSnackBar(
                              SnackBar(
                                content: Text(
                                  facility.activated
                                      ? 'Facility deactivated'
                                      : 'Facility activated',
                                ),
                                backgroundColor: Colors.green,
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                          backgroundColor: facility.activated
                              ? Colors.red
                              : Colors.green,
                          foregroundColor: Colors.white,
                          icon: facility.activated
                              ? Icons.toggle_off
                              : Icons.toggle_on,
                          label: facility.activated ? 'Deactivate' : 'Activate',
                        ),
                        SlidableAction(
                          onPressed: (context) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    AdminEditFacilityScreen(facility: facility),
                              ),
                            );
                          },
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          icon: Icons.edit,
                          label: "Edit",
                        ),
                      ],
                    ),
                    endActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (context) async {
                            final confirm = await showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text("Confirm delete"),
                                content: const Text(
                                  "Do you want to delete this facility?",
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: const Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      Navigator.pop(context, true);
                                    },
                                    child: const Text(
                                      "Delete",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                            );

                            if (confirm == true) {
                              await facilityProvider.deleteFacility(
                                facility.id,
                              );
                              await facilityProvider.getFacilities();
                              ScaffoldMessenger.of(parentContext).showSnackBar(
                                const SnackBar(
                                  content: Text('Facility deleted successfully'),
                                  backgroundColor: Colors.green,
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            }
                          },
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: "Delete",
                        ),
                      ],
                    ),
                    child: AdminFacilityCard(
                      facility: facility,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                AdminCourtsScreen(facility: facility),
                          ),
                        );
                      },
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        heroTag: null,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AdminCreateFacilityScreen(),
            ),
          );
        },
        backgroundColor: const Color.fromARGB(255, 0, 229, 255),
        child: const Icon(Icons.add),
      ),
    );
  }
}
