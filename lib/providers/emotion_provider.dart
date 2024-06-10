import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:my_emotions_v1/models/emotion.dart';

class EmotionProvider with ChangeNotifier {
  List<Emotion> _emotions = [];

  List<Emotion> get emotions => _emotions;

  int get entryCount => _emotions.length;

  double get averageRating {
    if (_emotions.isEmpty) return 0.0;
    return _emotions.map((e) => e.rating).reduce((a, b) => a + b) /
        _emotions.length;
  }

  Future<void> loadEmotions() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('emotions');
    if (jsonString != null) {
      final List decodedList = json.decode(jsonString) as List;
      _emotions = decodedList.map((json) => Emotion.fromJson(json)).toList();
      notifyListeners();
    }
  }

  Future<void> saveEmotions() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(_emotions.map((e) => e.toJson()).toList());
    await prefs.setString('emotions', jsonString);
  }

  void addEmotion(Emotion emotion) {
    _emotions.add(emotion);
    saveEmotions();
    notifyListeners();
  }

  void updateEmotion(int index, Emotion emotion) {
    _emotions[index] = emotion;
    saveEmotions();
    notifyListeners();
  }

  void deleteEmotion(int index) {
    _emotions.removeAt(index);
    saveEmotions();
    notifyListeners();
  }
}
