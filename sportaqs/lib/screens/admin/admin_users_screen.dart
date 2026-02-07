import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:sportaqs/models/user.dart';
import 'package:sportaqs/providers/user_provider.dart';
import 'package:sportaqs/widgets/admin/admin_users_card.dart';

class AdminUsersScreen extends StatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  State<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends State<AdminUsersScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = context.read<UserProvider>();
      userProvider.getAllUsers();
    });
  }

  Future<void> _refreshUsers() async {
    final userProvider = context.read<UserProvider>();
    await userProvider.getAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    final parentContext = context;
    final userProvider = Provider.of<UserProvider>(context);
    final List<User> users = userProvider.userList;

    return Scaffold(
      body: userProvider.loading
          ? const Center(child: CircularProgressIndicator())
          : userProvider.errorMessage != null
              ? Center(child: Text(userProvider.errorMessage!))
              : RefreshIndicator(
                  onRefresh: _refreshUsers,
                  child: ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];

                      return Slidable(
                        key: ValueKey(user.id),
                        startActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (_) async {
                                // Usar editActivation del provider
                                await userProvider.editActivation(user.id!, user.activated ?? false);

                                // Recargar lista
                                await userProvider.getAllUsers();

                                ScaffoldMessenger.of(parentContext).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      (user.activated ?? false)
                                          ? 'User deactivated'
                                          : 'User activated',
                                    ),
                                    backgroundColor: Colors.green,
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              },
                              backgroundColor:
                                  (user.activated ?? false) ? Colors.red : Colors.green,
                              foregroundColor: Colors.white,
                              icon: (user.activated ?? false) ? Icons.toggle_off : Icons.toggle_on,
                              label: (user.activated ?? false) ? 'Deactivate' : 'Activate',
                            ),
                          ],
                        ),
                        child: AdminUserCard(user: user),
                      );
                    },
                    separatorBuilder: (context, index) => const Divider(),
                  ),
                ),
    );
  }
}
