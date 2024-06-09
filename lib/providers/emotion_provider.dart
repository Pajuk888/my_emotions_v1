import 'package:flutter/material.dart';

class EmotionProvider with ChangeNotifier {
  List<String> _entries = [];

  List<String> get entries => _entries;

  void addEmotion(String emotion) {
    _entries.add(emotion);
    notifyListeners();
  }

  void deleteEntry(int index) {
    _entries.removeAt(index);
    notifyListeners();
  }
}
