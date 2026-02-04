import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportaqs/providers/user_provider.dart';
import 'package:sportaqs/screens/login_screen.dart';
import 'package:sportaqs/widgets/field_widget.dart';
import 'package:sportaqs/widgets/password_widget.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController secondNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  //Function to validate email
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final userProvider = context.watch<UserProvider>();
    final fieldWidth = size.width * 0.85;

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
            horizontal: size.width * 0.07,
            vertical: size.height * 0.08,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Return to login
              Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      );
                    },
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "Create your account",
                    style: TextStyle(fontSize: 32, color: Colors.white),
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.08),
              // const SizedBox(height: 30),

              // Name
              SizedBox(
                width: fieldWidth,
                child: FieldWidget(
                  hintText: "Name",
                  prefixIcon: const Icon(Icons.person),
                  controller: nameController,
                ),
              ),
              const SizedBox(height: 20),

              // SecondName
              SizedBox(
                width: fieldWidth,
                child: FieldWidget(
                  hintText: "Second Name",
                  prefixIcon: const Icon(Icons.person),
                  controller: secondNameController,
                ),
              ),
              const SizedBox(height: 20),

              // Email
              SizedBox(
                width: fieldWidth,
                child: FieldWidget(
                  hintText: "Email",
                  prefixIcon: const Icon(Icons.email),
                  controller: emailController,
                ),
              ),
              const SizedBox(height: 20),

              // Username
              SizedBox(
                width: fieldWidth,
                child: FieldWidget(
                  hintText: "Username",
                  prefixIcon: const Icon(Icons.person_outline),
                  controller: usernameController,
                ),
              ),
              const SizedBox(height: 20),

              // Password
              SizedBox(
                width: fieldWidth,
                child: PasswordWidget(
                  hintText: "Password",
                  controller: passwordController,
                ),
              ),
              const SizedBox(height: 20),

              // Confirm Password
              SizedBox(
                width: fieldWidth,
                child: PasswordWidget(
                  hintText: "Confirm password",
                  controller: confirmPasswordController,
                ),
              ),
              const SizedBox(height: 30),

              // Register button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: userProvider.loading
                      ? null
                      : () async {
                          // Validate fields
                          if (nameController.text.isEmpty ||
                              secondNameController.text.isEmpty ||
                              emailController.text.isEmpty ||
                              usernameController.text.isEmpty ||
                              passwordController.text.isEmpty ||
                              confirmPasswordController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("All fields are required"),
                              ),
                            );
                            return;
                          }

                          if (!_isValidEmail(emailController.text.trim())) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Please enter a valid email address",
                                ),
                              ),
                            );
                            return;
                          }

                          if (passwordController.text !=
                              confirmPasswordController.text) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Passwords don't match"),
                              ),
                            );
                            return;
                          }

                          await userProvider.register(
                            nameController.text.trim(),
                            secondNameController.text.trim(),
                            emailController.text.trim(),
                            usernameController.text.trim(),
                            passwordController.text.trim(),
                          );

                          if (userProvider.errorMessage == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Registered successfully"),
                                backgroundColor: Colors.green,
                              ),
                            );
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const LoginScreen(),
                              ),
                            );
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
                          "Register",
                          style: TextStyle(
                            color: Color(0xFF0288D1),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    secondNameController.dispose();
    emailController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
