import 'package:flutter/material.dart';
import 'package:sportaqs/models/user.dart';

class AdminUserCard extends StatelessWidget {
  final User user;

  const AdminUserCard({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: user.activated == true
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
              // Username + estado
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    user.username,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    user.activated == true? "Active" : "Inactive",
                    style: TextStyle(
                      color: user.activated == true ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Email
              Row(
                children: [
                  const Icon(Icons.email, size: 18),
                  const SizedBox(width: 6),
                  Expanded(child: Text(user.email ?? 'User without mail')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
