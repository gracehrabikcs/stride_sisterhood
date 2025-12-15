class CommunityRoute {
  final String? routeId;
  final String name;
  final String description;
  final double distance;
  final String createdBy;
  final Map<String, bool> likedBy;

  CommunityRoute({
    this.routeId,
    required this.name,
    required this.description,
    required this.distance,
    required this.createdBy,
    Map<String, bool>? likedBy,
  }) : likedBy = likedBy ?? {};

  int get likes => likedBy.length;

  bool isLikedBy(String userId) {
    return likedBy.containsKey(userId);
  }

  factory CommunityRoute.fromMap(Map<String, dynamic> data, String documentId) {
    return CommunityRoute(
      routeId: documentId,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      distance: (data['distance'] ?? 0.0).toDouble(),
      createdBy: data['createdBy'] ?? 'Unknown',
      likedBy: Map<String, bool>.from(data['likedBy'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'distance': distance,
      'createdBy': createdBy,
      'likedBy': likedBy,
    };
  }
}
