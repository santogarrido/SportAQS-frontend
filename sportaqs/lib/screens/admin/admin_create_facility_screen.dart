import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportaqs/providers/facility_provider.dart';
import 'package:sportaqs/widgets/field_widget.dart';

class AdminCreateFacilityScreen extends StatefulWidget {
  const AdminCreateFacilityScreen({super.key});

  @override
  State<AdminCreateFacilityScreen> createState() => _AdminCreateFacilityScreenState();
}

class _AdminCreateFacilityScreenState extends State<AdminCreateFacilityScreen> {

  final TextEditingController nameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController openTimeController = TextEditingController();
  final TextEditingController closeTimeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final facilityProvider = context.watch<FacilityProvider>();
    final fieldWidth = size.width * 0.85;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 0, 229, 255),
        foregroundColor: Colors.white,
        title: Text("Create your facility")
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
                hintText: "Location", 
                prefixIcon: const Icon(Icons.location_city),
                controller: locationController,
                hasBorder: true,
              )
            ),
            const SizedBox(height: 20),
            _buildTimeField(
              label: "Open Time",
              controller: openTimeController,
              width: fieldWidth,
              hasBorder: true,
            ),
            const SizedBox(height: 20),
            _buildTimeField(
              label: "Close Time",
              controller: closeTimeController,
              width: fieldWidth,
              hasBorder: true,
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:facilityProvider.isLoading ? null 
                : () async {
                  if(nameController.text.isEmpty || locationController.text.isEmpty || 
                    openTimeController.text.isEmpty || closeTimeController.text.isEmpty)
                  {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("All fields are required"),
                      ),
                    );
                    return;
                  }

                  await facilityProvider.addFacility(
                    nameController.text, 
                    openTimeController.text, 
                    closeTimeController.text, 
                    locationController.text
                  );
                  if (facilityProvider.errorMessage == null) {
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
                        content: Text(facilityProvider.errorMessage!),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue
                ),
                child: facilityProvider.isLoading
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

  Widget _buildTimeField({
    required String label,
    required TextEditingController controller,
    required double width,
    bool hasBorder = true,
  }) {
    // Parsear la hora actual si ya hay texto
    TimeOfDay? currentTime;
    if (controller.text.isNotEmpty) {
      final parts = controller.text.split(":");
      if (parts.length == 2) {
        final hour = int.tryParse(parts[0]);
        final minute = int.tryParse(parts[1]);
        if (hour != null && minute != null) {
          currentTime = TimeOfDay(hour: hour, minute: minute);
        }
      }
    }

    return SizedBox(
      width: width,
      child: GestureDetector(
        onTap: () async {
          final time = await showTimePicker(
            context: context,
            initialTime: currentTime ?? const TimeOfDay(hour: 12, minute: 0),
          );
          if (!mounted || time == null) return;

          final hourStr = time.hour.toString().padLeft(2, '0');
          final minuteStr = time.minute.toString().padLeft(2, '0');
          controller.text = "$hourStr:$minuteStr";

          (context as Element).markNeedsBuild(); // refrescar UI
        },
        child: AbsorbPointer(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: label,
              suffixIcon: const Icon(Icons.access_time, color: Colors.black),
              filled: true,
              fillColor: Colors.white,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: hasBorder
                    ? const BorderSide(color: Colors.black, width: 1.5)
                    : BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: hasBorder
                    ? const BorderSide(color: Colors.black, width: 2)
                    : BorderSide.none,
              ),
            ),
          ),
        ),
      ),
    );
  }





}


