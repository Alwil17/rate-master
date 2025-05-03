class Rating {
  final int? id;
  final double value;
  final String? comment;
  final int userId;
  final int itemId;
  final DateTime? createdAt;

  Rating({
    this.id,
    required this.value,
    this.comment,
    required this.userId,
    required this.itemId,
    this.createdAt,
  });

  /// Convert Dart object to JSON for the API
  Map<String, dynamic> toJson() => {
    'value': value,
    'comment': comment,
    'user_id': userId,
    'item_id': itemId,
  };

  /// (Optional) parse from JSON if you want to display incoming ratings
  factory Rating.fromJson(Map<String, dynamic> json) => Rating(
    value: (json['value'] as num).toDouble(),
    comment: json['comment'] as String?,
    userId: json['user_id'] as int,
    itemId: json['item_id'] as int,
    createdAt:
    json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
  );
}
