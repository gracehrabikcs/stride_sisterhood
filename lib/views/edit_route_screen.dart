import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stride_sisterhood/models/route_model.dart';
import 'package:stride_sisterhood/viewmodels/route_viewmodel.dart';

class EditRouteScreen extends StatefulWidget {
  final CommunityRoute route;

  const EditRouteScreen({super.key, required this.route});

  @override
  State<EditRouteScreen> createState() => _EditRouteScreenState();
}

class _EditRouteScreenState extends State<EditRouteScreen> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _distanceController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.route.name);
    _descriptionController = TextEditingController(text: widget.route.description);
    _distanceController = TextEditingController(text: widget.route.distance.toString());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _distanceController.dispose();
    super.dispose();
  }

  Future<void> _updateRoute() async {
    final updatedRoute = CommunityRoute(
      routeId: widget.route.routeId,
      name: _nameController.text,
      description: _descriptionController.text,
      distance: double.tryParse(_distanceController.text) ?? widget.route.distance,
      createdBy: widget.route.createdBy,
    );

    await context.read<RouteViewModel>().updateRoute(updatedRoute);
    if (mounted) Navigator.pop(context);
  }

  Future<void> _deleteRoute() async {
    if (widget.route.routeId != null) {
      await context.read<RouteViewModel>().deleteRoute(widget.route.routeId!);
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Route")),
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
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: "Description"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _distanceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Distance (km)"),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: _updateRoute, child: const Text("Update")),
                ElevatedButton(
                  onPressed: _deleteRoute,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text("Delete"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
