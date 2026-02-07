import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:sportaqs/models/court.dart';
import 'package:sportaqs/models/facility.dart';
import 'package:sportaqs/providers/court_provider.dart';
import 'package:sportaqs/screens/admin/admin_court_booking_screen.dart';
import 'package:sportaqs/screens/admin/admin_create_court_screen.dart';
import 'package:sportaqs/screens/admin/admin_edit_court_screen.dart';
import 'package:sportaqs/widgets/admin/admin_court_card.dart';

class AdminCourtsScreen extends StatefulWidget {
  final Facility facility;

  const AdminCourtsScreen({super.key, required this.facility});

  @override
  State<AdminCourtsScreen> createState() => _AdminCourtsScreenState();
}

class _AdminCourtsScreenState extends State<AdminCourtsScreen> {

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final courtProvider = context.read<CourtProvider>();
      
      courtProvider.getCourts(widget.facility.id);
    });
  }


  @override
  Widget build(BuildContext context) {

    final parentContext = context;
    final courtProvider = Provider.of<CourtProvider>(context);
    List<Court> courts = courtProvider.courts;

    if(courtProvider.isLoading){
      return const Center(child: CircularProgressIndicator());
    }

    if(courtProvider.errorMessage != null){
      return Center(child: Text(courtProvider.errorMessage!));
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 0, 229, 255),
        foregroundColor: Colors.white,
        title: Text(widget.facility.name)
      ),
      body: ListView.separated(
        itemCount: courts.length,
        itemBuilder: (context, index){
          final court = courts[index];

          return Slidable(
            key: ValueKey(court.id),
            startActionPane: ActionPane(
              motion: ScrollMotion(), 
              children: [
                //Activate or deactivate
                SlidableAction(
                  onPressed: (_) async {
                    if(court.activated == true){
                      await courtProvider.deactivateCourt(court.id);
                    }else{
                      await courtProvider.activateCourt(court.id);
                    }
                    await courtProvider.getCourts(widget.facility.id);
                    ScaffoldMessenger.of(parentContext).showSnackBar(
                      SnackBar(
                        content: Text(
                          court.activated ? 'court deactivated successfully' : 'court activated successfully'
                        ),
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 2),
                      )
                    );
                  },
                  backgroundColor: court.activated ? Colors.red : Colors.green,
                  foregroundColor: Colors.white,
                  icon: court.activated ? Icons.toggle_off : Icons.toggle_on,
                  label: court.activated ? 'Deactivate' : 'Activate',
                ),
                // Edit
                SlidableAction(
                  onPressed: (context) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AdminEditCourtScreen(court: court),
                      ),
                    );
                  },
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  icon: Icons.edit,
                  label: "Edit",
                ),                
              ]
            ),
            endActionPane: ActionPane(
              motion: ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) async {
                    // show confirmation
                    final confirm = await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text("Confirm delete"),
                        content: Text("Do you want to delete this court?"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () async {
                              Navigator.pop(context, true);
                            },
                            child: Text("Delete", style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    );

                    if (confirm == true) {
                      await courtProvider.deleteCourt(court.id);
                      await courtProvider.getCourts(widget.facility.id);
                      ScaffoldMessenger.of(parentContext).showSnackBar(
                        SnackBar(content: Text('court deleted successfully'),
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 2),
                        )
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
            child: AdminCourtCard(
              court: court,
              onTap: () {
                Navigator.push(
                  context,
                  
                  MaterialPageRoute(
                    builder: (_) =>
                        AdminCourtBookingScreen(court: court, facility: widget.facility,),
                  ),
                );
              },
            ),
          );
        }, 
        separatorBuilder: (BuildContext context, int index) {
          return Divider();
        }, 
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: null,
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AdminCreateCourtScreen(facility: widget.facility)
            )
          );

          await courtProvider.getCourts(widget.facility.id);
        },
        backgroundColor: const Color.fromARGB(255, 0, 229, 255),
        child: const Icon(Icons.add),
      ),
    
    );
  }
}