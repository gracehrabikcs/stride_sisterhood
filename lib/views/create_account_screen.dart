import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stride_sisterhood/models/user_model.dart';
import 'package:stride_sisterhood/services/firestore_service.dart';
import 'package:stride_sisterhood/viewmodels/user_viewmodel.dart';
import 'package:stride_sisterhood/views/main_screen.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _usernameController = TextEditingController();
  String _selectedPace = 'Moderate';

  final List<String> _paceOptions = const [
    'Very Slow',
    'Slow',
    'Moderate',
    'Fast',
    'Very Fast',
  ];

  Future<void> _createAccount() async {
    final username = _usernameController.text.trim();
    if (username.isEmpty) return;

    final userId = username.replaceAll(' ', '_').toLowerCase();
    final user = AppUser(
      userId: userId,
      name: username,
      paceRange: _selectedPace,
    );

    final firestore = context.read<FirestoreService>();
    await firestore.saveUser(user);

    context.read<UserViewModel>().setUser(user);

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Username",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              "Pace Range",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedPace,
              items: _paceOptions
                  .map(
                    (pace) => DropdownMenuItem(
                  value: pace,
                  child: Text(pace),
                ),
              )
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedPace = value;
                  });
                }
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _createAccount,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink[400],
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text("Create Account"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
