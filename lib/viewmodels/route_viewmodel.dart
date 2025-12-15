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

  Stream<List<CommunityRoute>> get routesStream => _firestoreService.getRoutes();

  bool hasUserLiked(CommunityRoute route) {
    if (_userId == null) return false;
    return route.isLikedBy(_userId!);
  }

  Future<void> toggleLike(CommunityRoute route) async {
    if (_userId == null || route.routeId == null) return;
    await _firestoreService.toggleLike(route.routeId!, _userId!);
  }

  Future<void> addRoute(CommunityRoute route) async {
    if (_userId == null) return;
    final newRoute = CommunityRoute(
      name: route.name,
      description: route.description,
      distance: route.distance,
      createdBy: _userId!,
    );
    await _firestoreService.addRoute(newRoute);
    notifyListeners();
  }

  Future<void> updateRoute(CommunityRoute route) async {
    await _firestoreService.updateRoute(route);
  }

  Future<void> deleteRoute(String routeId) async {
    await _firestoreService.deleteRoute(routeId);
  }
}
