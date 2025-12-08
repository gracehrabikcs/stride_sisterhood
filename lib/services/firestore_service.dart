import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stride_sisterhood/models/run_model.dart';
import 'package:stride_sisterhood/models/route_model.dart';
import 'package:stride_sisterhood/models/user_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // For this MVP, we'll use a hardcoded user ID.
  // In a full app, this would come from an AuthService.
  final String _mockUserId = "mockUser123";

  // User Operations
  Future<void> saveUser(AppUser user) async {
    // In a real app, the document ID would be the auth user's UID.
    await _db.collection('users').doc(_mockUserId).set(user.toMap());
  }

  // Run Operations
  Future<void> addRun(Run run) async {
    await _db.collection('runs').add(run.toMap());
  }

  Stream<List<Run>> getRuns() {
    return _db
        .collection('runs')
        .where('userId', isEqualTo: _mockUserId)
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
    await _db
        .collection('routes')
        .doc(routeId)
        .update({'likes': currentLikes + 1});
  }
}
