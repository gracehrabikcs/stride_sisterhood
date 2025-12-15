import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stride_sisterhood/models/run_model.dart';
import 'package:stride_sisterhood/viewmodels/run_viewmodel.dart';
import 'package:intl/intl.dart';

class EditRunScreen extends StatefulWidget {
  final Run run;

  const EditRunScreen({super.key, required this.run});

  @override
  State<EditRunScreen> createState() => _EditRunScreenState();
}

class _EditRunScreenState extends State<EditRunScreen> {
  late TextEditingController _distanceController;
  late TextEditingController _timeController;
  late TextEditingController _notesController;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _distanceController =
        TextEditingController(text: widget.run.distance.toString());
    _timeController = TextEditingController(text: widget.run.time);
    _notesController = TextEditingController(text: widget.run.notes ?? '');
    _selectedDate = widget.run.date;
  }

  @override
  void dispose() {
    _distanceController.dispose();
    _timeController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _updateRun() async {
    final updatedRun = Run(
      runId: widget.run.runId,
      userId: widget.run.userId,
      distance: double.tryParse(_distanceController.text) ?? widget.run.distance,
      time: _timeController.text,
      date: _selectedDate,
      notes: _notesController.text,
    );

    await context.read<RunViewModel>().updateRun(updatedRun);
    if (mounted) Navigator.pop(context);
  }

  Future<void> _deleteRun() async {
    if (widget.run.runId != null) {
      await context.read<RunViewModel>().deleteRun(widget.run.runId!);
      if (mounted) Navigator.pop(context);
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Run")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _distanceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Distance (km)"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _timeController,
              decoration: const InputDecoration(labelText: "Time (hh:mm:ss)"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _notesController,
              decoration: const InputDecoration(labelText: "Notes"),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text("Date: ${DateFormat.yMMMd().format(_selectedDate)}"),
                const Spacer(),
                TextButton(
                  onPressed: _pickDate,
                  child: const Text("Change Date"),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _updateRun,
                  child: const Text("Update"),
                ),
                ElevatedButton(
                  onPressed: _deleteRun,
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
