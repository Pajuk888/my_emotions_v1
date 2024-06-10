class Emotion {
  final DateTime date;
  final String emotion;
  final int rating;
  final String description;
  final List<String> tags;
  final String comments;

  Emotion({
    required this.date,
    required this.emotion,
    required this.rating,
    required this.description,
    required this.tags,
    required this.comments,
  });

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'emotion': emotion,
      'rating': rating,
      'description': description,
      'tags': tags,
      'comments': comments,
    };
  }

  static Emotion fromJson(Map<String, dynamic> json) {
    return Emotion(
      date: DateTime.parse(json['date']),
      emotion: json['emotion'],
      rating: json['rating'],
      description: json['description'],
      tags: List<String>.from(json['tags']),
      comments: json['comments'],
    );
  }
}
