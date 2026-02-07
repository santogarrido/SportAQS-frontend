import 'package:flutter/material.dart';
import 'package:sportaqs/models/facility.dart';

class AdminFacilityCard extends StatelessWidget {
  final Facility facility;

  const AdminFacilityCard({super.key, required this.facility});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: facility.activated ? Colors.lightBlueAccent : Colors.grey,
          width: 1.5,
        ),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nombre + estado
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  facility.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  facility.activated ? "Activa" : "Inactiva",
                  style: TextStyle(
                    color: facility.activated ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Ubicación
            Row(
              children: [
                const Icon(Icons.location_on, size: 18),
                const SizedBox(width: 6),
                Expanded(child: Text(facility.location)),
              ],
            ),
            const SizedBox(height: 6),
            // Horario
            Row(
              children: [
                const Icon(Icons.schedule, size: 18),
                const SizedBox(width: 6),
                Text('${facility.openTime} - ${facility.closeTime}'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
