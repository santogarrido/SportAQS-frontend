import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportaqs/models/facility.dart';
import 'package:sportaqs/models/user.dart';
import 'package:sportaqs/providers/court_provider.dart';
import 'package:sportaqs/widgets/court_card.dart';

class CourtsScreen extends StatefulWidget {
  final Facility facility;
  final User activeUser;

  const CourtsScreen({
    super.key,
    required this.facility,
    required this.activeUser,
  });

  @override
  State<CourtsScreen> createState() => _CourtsScreenState();
}

class _CourtsScreenState extends State<CourtsScreen> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      Provider.of<CourtProvider>(context, listen: false)
          .getCourts(widget.facility.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final courtProvider = Provider.of<CourtProvider>(context);

    if (courtProvider.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (courtProvider.errorMessage != null) {
      return Scaffold(
        body: Center(child: Text(courtProvider.errorMessage!)),
      );
    }

    final courts = courtProvider.courts
        .where((c) => c.facilityId == widget.facility.id)
        .toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 0, 229, 255),
        foregroundColor: Colors.white,
        title: Text(widget.facility.name),
      ),
      body: RefreshIndicator(
        onRefresh: () => courtProvider.getCourts(widget.facility.id),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: courts.isEmpty
              ? [
                  SizedBox(
                    height: MediaQuery.of(context).size.height - 150,
                    child: const Center(
                      child: Text("No hay pistas disponibles"),
                    ),
                  )
                ]
              : courts
                  .map(
                    (court) => CourtCard(
                      court: court,
                      onTap: () {
                        debugPrint(
                          'Court ${court.id} seleccionada por ${widget.activeUser.name}',
                        );
                      },
                    ),
                  )
                  .toList(),
        ),
      ),
    );
  }
}
