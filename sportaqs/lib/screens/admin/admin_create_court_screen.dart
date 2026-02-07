import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportaqs/models/facility.dart';
import 'package:sportaqs/providers/court_provider.dart';
import 'package:sportaqs/widgets/field_widget.dart';


class AdminCreateCourtScreen extends StatefulWidget {
  final Facility facility;

  const AdminCreateCourtScreen({super.key, required this.facility});

  @override
  State<AdminCreateCourtScreen> createState() => _AdminCreateCourtScreenState();
}

class _AdminCreateCourtScreenState extends State<AdminCreateCourtScreen> {

  final TextEditingController nameController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController bookingDurationController = TextEditingController();

  int bookingDuration = 0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final courtProvider = context.watch<CourtProvider>();
    final fieldWidth = size.width * 0.85;
    return Scaffold(
      
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 0, 229, 255),
        foregroundColor: Colors.white,
        title: Text("Create your court")
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.07,
          vertical: size.height * 0.08,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: fieldWidth,
              child: FieldWidget(
                hintText: "Name", 
                prefixIcon: const Icon(Icons.abc),
                controller: nameController,
                hasBorder: true,
              )
            ),
            const SizedBox(height: 20),

            SizedBox(
              width: fieldWidth,
              child: FieldWidget(
                hintText: "Category", 
                prefixIcon: const Icon(Icons.sports),
                controller: categoryController,
                hasBorder: true,
              )
            ),
            const SizedBox(height: 20),

            SizedBox(
              width: fieldWidth,
              child: FieldWidget(
                hintText: "Booking duration", 
                prefixIcon: const Icon(Icons.schedule),
                controller: bookingDurationController,
                hasBorder: true,
              )
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:courtProvider.isLoading ? null 
                : () async {
                  if(nameController.text.isEmpty || categoryController.text.isEmpty || bookingDurationController.text.isEmpty)
                  {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("All fields are required"),
                      ),
                    );
                    return;
                  }

                  if (bookingDurationController.text.trim().isNotEmpty) {
                    try {
                      bookingDuration = int.parse(bookingDurationController.text.trim());
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Booking duration must be a number")),
                      );
                      return;
                      }
                  }

                  await courtProvider.addCourt(
                    nameController.text, 
                    categoryController.text, 
                    bookingDuration, 
                    widget.facility.id
                  );

                  if (courtProvider.errorMessage == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Registered successfully"),
                        backgroundColor: Colors.green,
                      ),
                    );
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(courtProvider.errorMessage!),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue
                ),
                child: courtProvider.isLoading
                  ? const CircularProgressIndicator(
                      color: Color(0xFF0288D1),
                    )
                    : const Text(
                        "Create",
                          style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                      ),
                ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue
                  
                ), 
                child: const Text(
                        "Cancel",
                          style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                      )
              ),
            )
          ]
        )
      ),
    
    );
  }
}