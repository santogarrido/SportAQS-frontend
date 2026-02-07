// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:sportaqs/providers/user_provider.dart';

// class TestScreen extends StatelessWidget {
//   const TestScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final userProvider = context.watch<UserProvider>();

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Test Screen'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout),
//             onPressed: () async {
//               await userProvider.logout();
//               Navigator.pop(context);
//             },
//           ),
//         ],
//       ),
//       body: userProvider.loading
//           ? const Center(child: CircularProgressIndicator())
//           : Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // USER ACTIVO
//                   const Text(
//                     'Active user',
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 8),
//                   Text('Username: ${userProvider.activeUser?.username}'),
//                   Text('Token: ${userProvider.activeUser?.token}'),
//                   const Divider(height: 32),

//                   // BOTONES
//                   Wrap(
//                     spacing: 8,
//                     children: [
//                       ElevatedButton(
//                         onPressed: userProvider.getAllUsers,
//                         child: const Text('Load users'),
//                       ),
//                     ],
//                   ),

//                   const SizedBox(height: 20),

//                   // ERROR
//                   if (userProvider.errorMessage != null)
//                     Text(
//                       userProvider.errorMessage!,
//                       style: const TextStyle(color: Colors.red),
//                     ),

//                   const SizedBox(height: 12),

//                   // LISTA USUARIOS
//                   const Text(
//                     'Users',
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 8),

//                   Expanded(
//                     child: ListView.builder(
//                       itemCount: userProvider.userList.length,
//                       itemBuilder: (context, index) {
//                         final user = userProvider.userList[index];

//                         return Card(
//                           child: ListTile(
//                             title: Text(user.username),
//                             subtitle: Text(
//                               'Active: ${user.activated} | Role: ${user.role}',
//                             ),
//                             trailing: Wrap(
//                               spacing: 8,
//                               children: [
//                                 IconButton(
//                                   icon: Icon(
//                                     user.activated == true
//                                         ? Icons.block
//                                         : Icons.check,
//                                   ),
//                                   onPressed: () {
//                                     userProvider.editActivation(
//                                       user.id!,
//                                       user.activated ?? false,
//                                     );
//                                   },
//                                 ),
//                                 IconButton(
//                                   icon: const Icon(Icons.delete),
//                                   onPressed: () {
//                                     userProvider.deleteUser(user.id!);
//                                   },
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//     );
//   }
// }
