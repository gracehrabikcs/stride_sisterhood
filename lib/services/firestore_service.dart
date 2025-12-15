import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stride_sisterhood/models/run_model.dart';
import 'package:stride_sisterhood/models/route_model.dart';
import 'package:stride_sisterhood/models/user_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // User Operations
  Future<void> saveUser(AppUser user) async {
    await _db.collection('users').doc(user.userId).set(user.toMap());
  }

  Future<AppUser?> getUser(String userId) async {
    final doc = await _db.collection('users').doc(userId).get();
    if (doc.exists) {
      return AppUser.fromMap(doc.data()!, doc.id);
    }
    return null;
  }

  // Run Operations
  Future<void> addRun(Run run) async {
    await _db.collection('runs').add(run.toMap());
  }

  Stream<List<Run>> getRuns(String userId) {
    return _db
        .collection('runs')
        .where('userId', isEqualTo: userId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Run.fromMap(doc.data(), doc.id))
        .toList());
  }
  Future<void> updateRun(Run run) async {
    await _db.collection('runs').doc(run.runId).update(run.toMap());
  }

  Future<void> deleteRun(String runId) async {
    await _db.collection('runs').doc(runId).delete();
  }

  // Route Operations
  // Route Operations
  Stream<List<CommunityRoute>> getRoutes() {
    return _db
        .collection('routes')
        //.orderBy('likes', descending: true)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => CommunityRoute.fromMap(doc.data(), doc.id)).toList());
  }

  Future<void> addRoute(CommunityRoute route) async {
    await _db.collection('routes').add(route.toMap());
  }

  Future<void> updateRoute(CommunityRoute route) async {
    if (route.routeId == null) return;
    await _db.collection('routes').doc(route.routeId).update(route.toMap());
  }

  Future<void> deleteRoute(String routeId) async {
    await _db.collection('routes').doc(routeId).delete();
  }

  // Toggle like for a route
  Future<void> toggleLike(String routeId, String userId) async {
    final routeRef = _db.collection('routes').doc(routeId);
    await _db.runTransaction((transaction) async {
      final snapshot = await transaction.get(routeRef);
      if (!snapshot.exists) return;

      final data = snapshot.data()!;
      final likedBy = Map<String, bool>.from(data['likedBy'] ?? {});

      if (likedBy.containsKey(userId)) {
        likedBy.remove(userId);
      } else {
        likedBy[userId] = true;
      }

      transaction.update(routeRef, {
        'likedBy': likedBy,
        'likes': likedBy.length,
      });
    });
  }



}
