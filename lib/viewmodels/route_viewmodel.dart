import 'package:flutter/material.dart';
import 'package:stride_sisterhood/models/route_model.dart';
import 'package:stride_sisterhood/services/firestore_service.dart';

class RouteViewModel extends ChangeNotifier {
  final FirestoreService _firestoreService;
  String? _userId;

  RouteViewModel(this._firestoreService);

  void setUserId(String userId) {
    _userId = userId;
    notifyListeners();
  }

  Stream<List<CommunityRoute>> get routesStream =>
      _firestoreService.getRoutes();

  Future<void> likeRoute(String routeId) async {
    if (_userId == null) return;
    await _firestoreService.likeRouteOnce(routeId, _userId!);
  }

  bool hasUserLiked(CommunityRoute route) {
    if (_userId == null) return false;
    return route.isLikedBy(_userId!);
  }
}
