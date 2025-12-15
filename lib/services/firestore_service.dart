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

  // Route Operations
  Stream<List<CommunityRoute>> getRoutes() {
    return _db
        .collection('routes')
        .orderBy('likes', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => CommunityRoute.fromMap(doc.data(), doc.id))
        .toList());
  }

  Future<void> likeRoute(String routeId, int currentLikes) async {
    await _db.collection('routes').doc(routeId).update({'likes': currentLikes + 1});
  }
}
