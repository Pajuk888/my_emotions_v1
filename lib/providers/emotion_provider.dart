import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_emotions_v1/models/emotion_entry.dart';

class EmotionProvider with ChangeNotifier {
  List<EmotionEntry> _entries = [];

  List<EmotionEntry> get entries => _entries;

  void addEmotion(EmotionEntry entry) {
    _entries.add(entry);
    saveEntries();
    notifyListeners();
  }

  void updateEmotion(int index, EmotionEntry updatedEntry) {
    _entries[index] = updatedEntry;
    saveEntries();
    notifyListeners();
  }

  void deleteEmotion(int index) {
    _entries.removeAt(index);
    saveEntries();
    notifyListeners();
  }

  Future<void> loadEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final String? entriesJson = prefs.getString('entries');
    if (entriesJson != null) {
      try {
        List<dynamic> jsonData = jsonDecode(entriesJson);
        _entries = jsonData
            .map((item) => EmotionEntry.fromJson(item as Map<String, dynamic>))
            .toList();
      } catch (e) {
        print('Error loading entries: $e');
      }
    }
    notifyListeners();
  }

  Future<void> saveEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final String entriesJson =
        jsonEncode(_entries.map((entry) => entry.toJson()).toList());
    await prefs.setString('entries', entriesJson);
  }

  List<EmotionEntry> getEntriesByDate(DateTime date) {
    return _entries.where((entry) => isSameDay(entry.date, date)).toList();
  }

  int getEntryCountByDate(DateTime date) {
    return getEntriesByDate(date).length;
  }

  double getAverageRatingByDate(DateTime date) {
    final dateEntries = getEntriesByDate(date);
    if (dateEntries.isEmpty) return 0.0;
    final totalRating =
        dateEntries.fold(0.0, (sum, entry) => sum + entry.rating);
    return totalRating / dateEntries.length;
  }

  double getWeeklyAverageRating(DateTime startOfWeek) {
    final weekEntries = _entries
        .where((entry) =>
            entry.date.isAfter(startOfWeek.subtract(Duration(days: 1))) &&
            entry.date.isBefore(startOfWeek.add(Duration(days: 7))))
        .toList();
    if (weekEntries.isEmpty) return 0.0;
    final totalRating =
        weekEntries.fold(0.0, (sum, entry) => sum + entry.rating);
    return totalRating / weekEntries.length;
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
