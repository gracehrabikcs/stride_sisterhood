import 'package:flutter/material.dart';
import 'package:stride_sisterhood/models/run_model.dart';
import 'package:stride_sisterhood/services/firestore_service.dart';

class RunViewModel extends ChangeNotifier {
  final FirestoreService _firestoreService;
  String? _userId;

  RunViewModel(this._firestoreService);

  void setUserId(String userId) {
    _userId = userId;
    notifyListeners();
  }

  Future<void> addRun({
    required double distance,
    required String time,
    required DateTime date,
    String? notes,
  }) async {
    if (_userId == null) return;
    final newRun = Run(
      userId: _userId!,
      distance: distance,
      time: time,
      date: date,
      notes: notes,
    );
    await _firestoreService.addRun(newRun);
  }

  Stream<List<Run>> get runsStream {
    if (_userId == null) return const Stream.empty();
    return _firestoreService.getRuns(_userId!);
  }
}
