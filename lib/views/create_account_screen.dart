import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stride_sisterhood/models/user_model.dart';
import 'package:stride_sisterhood/services/firestore_service.dart';
import 'package:stride_sisterhood/viewmodels/run_viewmodel.dart';
import 'package:stride_sisterhood/viewmodels/route_viewmodel.dart';
import 'package:stride_sisterhood/views/main_screen.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _usernameController = TextEditingController();
  final _paceController = TextEditingController(text: "Moderate");
  String? _error;

  Future<void> _createAccount() async {
    final username = _usernameController.text.trim();
    final paceRange = _paceController.text.trim();

    if (username.isEmpty) {
      setState(() => _error = "Username required");
      return;
    }

    final userId = username.replaceAll(' ', '_').toLowerCase();
    final firestore = context.read<FirestoreService>();

    final existingUser = await firestore.getUser(userId);
    if (existingUser != null) {
      setState(() => _error = "Username already exists");
      return;
    }

    final user = AppUser(
      userId: userId,
      name: username,
      paceRange: paceRange,
    );

    await firestore.saveUser(user);

    context.read<RunViewModel>().setUserId(userId);
    context.read<RouteViewModel>().setUserId(userId);

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MainScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Account")),
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
                labelText: "Pace Range",
                border: OutlineInputBorder(),
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(_error!, style: const TextStyle(color: Colors.red)),
            ],
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _createAccount,
              child: const Text("Create Account"),
            ),
          ],
        ),
      ),
    );
  }
}
