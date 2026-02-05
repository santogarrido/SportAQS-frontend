import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sportaqs/providers/user_provider.dart';
import 'package:sportaqs/screens/register_screen.dart';
import 'package:sportaqs/screens/test_screen.dart';
import 'package:sportaqs/screens/user/user_screen.dart';
import 'package:sportaqs/widgets/field_widget.dart';
import 'package:sportaqs/widgets/password_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final userProvider = context.watch<UserProvider>();

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF4FC3F7), Color(0xFF0288D1)],
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.08,
            vertical: size.height * 0.1,
          ),
          child: Column(
            children: [
              // Logo
              SizedBox(
                height: size.height * 0.3,
                child: Image.asset(
                  'assets/images/sportAQS_logo.png',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 32),

              // Username
              FieldWidget(
                hintText: 'Username',
                prefixIcon: const Icon(Icons.person),
                controller: usernameController,
              ),
              const SizedBox(height: 20),

              // Password
              PasswordWidget(
                hintText: 'Password',
                controller: passwordController,
              ),
              const SizedBox(height: 30),

              // Login button
              SizedBox(
                //TODO
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: userProvider.loading
                      ? null
                      : () async {
                          await userProvider.login(
                            usernameController.text.trim(),
                            passwordController.text.trim(),
                          );

                          final user = userProvider.activeUser;

                          if (user != null) {
                            if (user.role == 'ROLE_ADMIN') {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      TestScreen(), //TODO AdminScreen()
                                ),
                              );
                            } else if (user.role == 'ROLE_USER') {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      UserScreen(), //TODO UserScreen()
                                ),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(userProvider.errorMessage!),
                              ),
                            );
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: userProvider.loading
                      ? const CircularProgressIndicator(
                          color: Color(0xFF0288D1),
                        )
                      : const Text(
                          'Login',
                          style: TextStyle(
                            color: Color(0xFF0288D1),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 30),

              const Text(
                "Don't have an account?",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 10),

              // Register button
              OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RegisterScreen()),
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.white, width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 14,
                  ),
                ),
                child: const Text(
                  'Register',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
