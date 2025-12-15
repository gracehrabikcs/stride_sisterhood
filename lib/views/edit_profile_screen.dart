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
  late TextEditingController _paceController;

  @override
  void initState() {
    super.initState();
    final user = context.read<UserViewModel>().user!;
    _nameController = TextEditingController(text: user.name);
    _paceController = TextEditingController(text: user.paceRange);
  }

  Future<void> _save() async {
    final userVM = context.read<UserViewModel>();
    final firestore = context.read<FirestoreService>();
    final user = userVM.user!;

    final updatedUser = AppUser(
      userId: user.userId,
      name: _nameController.text.trim(),
      paceRange: _paceController.text.trim(),
    );

    await firestore.saveUser(updatedUser);
    userVM.updateUser(updatedUser);

    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
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
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _save,
              child: const Text("Save Changes"),
            ),
          ],
        ),
      ),
    );
  }
}
