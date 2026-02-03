import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportaqs/providers/user_provider.dart';

//PANTALLA DE PRUEBA
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: const Text('Login Test')),
    body: Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              if (userProvider.loading)
                const Center(child: CircularProgressIndicator())
              else
                ElevatedButton(
                  onPressed: () async {
                    await userProvider.login(
                      _usernameController.text.trim(),
                      _passwordController.text.trim(),
                    );

                    if (userProvider.activeUser != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Welcome ${userProvider.activeUser!.username}!'),
                        ),
                      );
                    }
                  },
                  child: const Text('Login'),
                ),
              const SizedBox(height: 20),
              if (userProvider.errorMessage != null)
                Text(
                  userProvider.errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              const SizedBox(height: 20),
              // --- Datos del usuario activo ---
              if (userProvider.activeUser != null) ...[
                Text(
                  'User Info:',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text('ID: ${userProvider.activeUser!.id ?? "-"}'),
                Text('Name: ${userProvider.activeUser!.name ?? "-"}'),
                Text('Second Name: ${userProvider.activeUser!.secondName ?? "-"}'),
                Text('Email: ${userProvider.activeUser!.email ?? "-"}'),
                Text('Username: ${userProvider.activeUser!.username}'),
                Text('Role: ${userProvider.activeUser!.role ?? "-"}'),
                Text('Activated: ${userProvider.activeUser!.activated ?? false}'),
                Text('Deleted: ${userProvider.activeUser!.deleted ?? false}'),
              ],
            ],
          ),
        );
      },
    ),
  );
}

}
