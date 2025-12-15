import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stride_sisterhood/models/route_model.dart';
import 'package:stride_sisterhood/viewmodels/route_viewmodel.dart';

class NewRouteScreen extends StatefulWidget {
  const NewRouteScreen({Key? key}) : super(key: key);

  @override
  _NewRouteScreenState createState() => _NewRouteScreenState();
}

class _NewRouteScreenState extends State<NewRouteScreen> {
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _distanceController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _distanceController.dispose();
    super.dispose();
  }

  Future<void> _saveRoute() async {
    final routeName = _nameController.text;
    final routeDesc = _descController.text;
    final distance = double.tryParse(_distanceController.text);

    if (routeName.isEmpty || routeDesc.isEmpty || distance == null) {
      return;
    }

    final route = CommunityRoute(
      name: routeName,
      description: routeDesc,
      distance: distance,
      createdBy: '',
    );

    await context.read<RouteViewModel>().addRoute(route);  // Save the route using the ViewModel
    Navigator.pop(context); // Go back to the previous screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Route"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Route Name"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descController,
              decoration: const InputDecoration(labelText: "Description"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _distanceController,
              decoration: const InputDecoration(labelText: "Distance (km)"),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveRoute,
              child: const Text("Save Route"),
            ),
          ],
        ),
      ),
    );
  }
}
