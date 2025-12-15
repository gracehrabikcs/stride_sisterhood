import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stride_sisterhood/models/run_model.dart';
import 'package:stride_sisterhood/viewmodels/run_viewmodel.dart';
import 'package:stride_sisterhood/views/edit_run_screen.dart';
import 'package:intl/intl.dart';

class RunHistoryScreen extends StatelessWidget {
  const RunHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<RunViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Run History'),
      ),
      body: StreamBuilder<List<Run>>(
        stream: viewModel.runsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No runs logged yet. Go for a run!',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          final runs = snapshot.data!;
          return ListView.builder(
            itemCount: runs.length,
            itemBuilder: (context, index) {
              final run = runs[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.pink[100],
                    child: const Icon(Icons.directions_run, color: Colors.pink),
                  ),
                  title: Text(
                    '${run.distance.toStringAsFixed(2)} km Run',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                      '${DateFormat.yMMMd().format(run.date)} - ${run.time}'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditRunScreen(run: run),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
