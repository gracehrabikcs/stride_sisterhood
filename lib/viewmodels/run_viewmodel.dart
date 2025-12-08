import 'package:flutter/material.dart';
import 'package:stride_sisterhood/models/run_model.dart';
import 'package:stride_sisterhood/services/firestore_service.dart';

class RunViewModel extends ChangeNotifier {
  final FirestoreService _firestoreService;
  // Hardcoded user ID for MVP
  final String _userId = "mockUser123";

  RunViewModel(this._firestoreService);

  Future<void> addRun(
      {required double distance,
        required String time,
        required DateTime date,
        String? notes}) async {
    final newRun = Run(
      userId: _userId,
      distance: distance,
      time: time,
      date: date,
      notes: notes,
    );
    await _firestoreService.addRun(newRun);
  }

  Stream<List<Run>> get runsStream => _firestoreService.getRuns();
}
