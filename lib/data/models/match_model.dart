class MatchModel {
  final String id;
  final String user1Id;
  final String user2Id;
  final DateTime matchedAt; // Yeni özellik

  MatchModel(
      {required this.id,
      required this.user1Id,
      required this.user2Id,
      required this.matchedAt});

  factory MatchModel.fromJson(Map<String, dynamic> json) {
    return MatchModel(
      id: json['id'],
      user1Id: json['user1_id'],
      user2Id: json['user2_id'],
      matchedAt: DateTime.parse(json['matched_at']), // Yeni özellik
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user1_id': user1Id,
      'user2_id': user2Id,
      'matched_at': matchedAt.toIso8601String(), // Yeni özellik
    };
  }
}
