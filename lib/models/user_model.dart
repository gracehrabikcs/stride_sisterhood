class AppUser {
  final String userId;
  final String name;
  final String paceRange;
  final String? profileImageUrl;

  AppUser({
    required this.userId,
    required this.name,
    required this.paceRange,
    this.profileImageUrl,
  });

  factory AppUser.fromMap(Map<String, dynamic> data, String documentId) {
    return AppUser(
      userId: documentId,
      name: data['name'] ?? '',
      paceRange: data['paceRange'] ?? 'N/A',
      profileImageUrl: data['profileImageUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'paceRange': paceRange,
      'profileImageUrl': profileImageUrl,
    };
  }
}
