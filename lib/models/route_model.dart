class CommunityRoute {
  final String? routeId;
  final String name;
  final String description;
  final double distance;
  final String createdBy;  final int likes;

  CommunityRoute({
    this.routeId,
    required this.name,
    required this.description,
    required this.distance,
    required this.createdBy,
    this.likes = 0,
  });

  factory CommunityRoute.fromMap(Map<String, dynamic> data, String documentId) {
    return CommunityRoute(
      routeId: documentId,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      distance: (data['distance'] ?? 0.0).toDouble(),
      createdBy: data['createdBy'] ?? 'Unknown',
      likes: data['likes'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'distance': distance,
      'createdBy': createdBy,
      'likes': likes,
    };
  }
}
