import 'package:cloud_firestore/cloud_firestore.dart';

class Run {
  final String? runId;
  final String userId;
  final double distance;
  final String time;
  final DateTime date;
  final String? notes;

  Run({
    this.runId,
    required this.userId,
    required this.distance,
    required this.time,
    required this.date,
    this.notes,
  });

  factory Run.fromMap(Map<String, dynamic> data, String documentId) {
    return Run(
      runId: documentId,
      userId: data['userId'] ?? '',
      distance: (data['distance'] ?? 0.0).toDouble(),
      time: data['time'] ?? '00:00',
      date: (data['date'] as Timestamp).toDate(),
      notes: data['notes'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'distance': distance,
      'time': time,
      'date': Timestamp.fromDate(date),
      'notes': notes,
    };
  }
}
