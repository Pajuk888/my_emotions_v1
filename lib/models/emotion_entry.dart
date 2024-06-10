class EmotionEntry {
  final DateTime date;
  final int rating;
  final String description;
  final String tags;
  final String comments;

  EmotionEntry({
    required this.date,
    required this.rating,
    required this.description,
    required this.tags,
    required this.comments,
  });

  factory EmotionEntry.fromJson(Map<String, dynamic> json) {
    return EmotionEntry(
      date: DateTime.parse(json['date'] as String),
      rating: json['rating'] as int,
      description: json['description'] as String,
      tags: json['tags'] as String,
      comments: json['comments'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'rating': rating,
      'description': description,
      'tags': tags,
      'comments': comments,
    };
  }
}
