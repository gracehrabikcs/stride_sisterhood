import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stride_sisterhood/models/user_model.dart';
import 'package:stride_sisterhood/services/firestore_service.dart';
import 'package:stride_sisterhood/viewmodels/user_viewmodel.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  String _selectedPace = 'Moderate';

  final List<String> _paceOptions = const [
    'Very Slow',
    'Slow',
    'Moderate',
    'Fast',
    'Very Fast',
  ];

  @override
  void initState() {
    super.initState();
    final user = context.read<UserViewModel>().user!;
    _nameController = TextEditingController(text: user.name);
    _selectedPace = user.paceRange;
  }

  Future<void> _saveProfile() async {
    final userViewModel = context.read<UserViewModel>();
    final firestore = context.read<FirestoreService>();
    final currentUser = userViewModel.user;

    if (currentUser == null) return;

    final updatedUser = AppUser(
      userId: currentUser.userId,
      name: _nameController.text.trim(),
      paceRange: _selectedPace,
      profileImageUrl: currentUser.profileImageUrl,
    );

    await firestore.saveUser(updatedUser);
    userViewModel.setUser(updatedUser);

    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        actions: [
          TextButton(
            onPressed: _saveProfile,
            child: const Text(
              "Save",
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Name",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
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
          ],
        ),
      ),
    );
  }
}
