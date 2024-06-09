import 'package:my_emotions_v1/models/emotion_entry.dart';

class CalculationService {
  int calculateNumberOfEntries(List<EmotionEntry> entries) {
    return entries.length;
  }

  double calculateAverageRating(List<EmotionEntry> entries) {
    if (entries.isEmpty) return 0.0;
    double total = entries.fold(0.0, (sum, entry) => sum + entry.rating);
    return total / entries.length;
  }
}
