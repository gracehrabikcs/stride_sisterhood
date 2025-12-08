import 'package:flutter/material.dart';
import 'package:stride_sisterhood/models/route_model.dart';
import 'package:stride_sisterhood/services/firestore_service.dart';

class RouteViewModel extends ChangeNotifier {
  final FirestoreService _firestoreService;

  RouteViewModel(this._firestoreService);

  Stream<List<CommunityRoute>> get routesStream => _firestoreService.getRoutes();

  Future<void> likeRoute(String routeId, int currentLikes) async {
    await _firestoreService.likeRoute(routeId, currentLikes);
    // The stream will automatically update the UI, no need to call notifyListeners.
  }
}
