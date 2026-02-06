import 'package:flutter/material.dart';

class AdminBookingsScreen extends StatelessWidget{
  const AdminBookingsScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> items = [
      {
        'title': 'Vista de Bookings',
        'subtitle': 'Aqui van todas las reservas',
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            title: Text(
              item['title']!,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                item['subtitle']!,
                style: const TextStyle(fontSize: 14),
              ),
            ),
            leading: CircleAvatar(
              backgroundColor: Colors.purple[200],
              child: const Icon(Icons.star, color: Colors.white),
            ),
          ),
        );
      },
    );
  }

}