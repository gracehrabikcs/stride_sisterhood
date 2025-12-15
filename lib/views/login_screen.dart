import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stride_sisterhood/models/user_model.dart';
import 'package:stride_sisterhood/services/firestore_service.dart';
import 'package:stride_sisterhood/viewmodels/run_viewmodel.dart';
import 'package:stride_sisterhood/viewmodels/route_viewmodel.dart';
import 'package:stride_sisterhood/views/main_screen.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _paceController = TextEditingController(text: "Moderate");

  Future<void> _login() async {
    final username = _usernameController.text.trim();
    final paceRange = _paceController.text.trim();

    if (username.isEmpty) return;

    final userId = username.replaceAll(' ', '_').toLowerCase(); // simple userId
    final appUser = AppUser(userId: userId, name: username, paceRange: paceRange);

    final firestore = context.read<FirestoreService>();
    await firestore.saveUser(appUser);

    // set userId in viewmodels
    context.read<RunViewModel>().setUserId(userId);
    context.read<RouteViewModel>().setUserId(userId);

    // Navigate to main app
    if (!mounted) return;
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => const MainScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login / Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: "Username",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _paceController,
              decoration: const InputDecoration(
                labelText: "Pace Range (e.g., Slow, Moderate, Fast)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _login,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink[400],
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text("Continue"),
            ),
          ],
        ),
      ),
    );
  }
}
