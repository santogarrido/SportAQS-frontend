import 'package:flutter/material.dart';
import 'package:sportaqs/models/court.dart';

class AdminCourtCard extends StatelessWidget {
  final Court court;
  final VoidCallback onTap;

  const AdminCourtCard({
    super.key,
    required this.court,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: court.activated
                ? Colors.lightBlueAccent
                : Colors.grey,
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
                    court.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    court.activated ? "Activa" : "Inactiva",
                    style: TextStyle(
                      color: court.activated
                          ? Colors.green
                          : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Ubicación
              Row(
                children: [
                  const Icon(Icons.sports, size: 18),
                  const SizedBox(width: 6),
                  Expanded(child: Text(court.category)),
                ],
              ),
              const SizedBox(height: 6),

              // Horario
              Row(
                children: [
                  const Icon(Icons.schedule, size: 18),
                  const SizedBox(width: 6),
                  Text('${court.bookingDuration} min'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
