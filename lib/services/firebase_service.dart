import 'package:cloud_firestore/cloud_firestore.dart'; // Ensure this import is correct
import 'package:my_emotions_v1/models/emotion_entry.dart';

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addEntry(EmotionEntry entry) async {
    await _db.collection('entries').add({
      'rating': entry.rating,
      'description': entry.description,
      'comment': entry.comment,
      'dateTime': entry.dateTime.toIso8601String(),
    });
  }

  Future<List<EmotionEntry>> fetchEntries() async {
    final snapshot = await _db.collection('entries').get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return EmotionEntry(
        rating: data['rating'],
        description: data['description'],
        comment: data['comment'],
        dateTime: DateTime.parse(data['dateTime']),
      );
    }).toList();
  }
}
