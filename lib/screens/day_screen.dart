import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/emotion_provider.dart';
import '../widgets/emotion_dialog.dart';
import '../widgets/emotion_card.dart';

class DayScreen extends StatefulWidget {
  const DayScreen({Key? key}) : super(key: key); // Use key in constructor

  @override
  _DayScreenState createState() => _DayScreenState();
}

class _DayScreenState extends State<DayScreen> {
  @override
  void initState() {
    super.initState();
    _checkAndShowDialog();
  }

  Future<void> _checkAndShowDialog() async {
    final prefs = await SharedPreferences.getInstance();
    final isDialogShown = prefs.getBool('isDialogShown') ?? false;

    if (!isDialogShown) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showEmotionDialog();
      });
      await prefs.setBool('isDialogShown', true);
    }
  }

  void _showEmotionDialog() {
    showDialog(
      context: context,
      builder: (ctx) => EmotionDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final emotionProvider = Provider.of<EmotionProvider>(context);
    final entries = emotionProvider.entries;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Emotions'), // Use const
      ),
      body: ListView.builder(
        itemCount: entries.length,
        itemBuilder: (ctx, i) => EmotionCard(
          emotion: entries[i], // Provide required emotion argument
          index: i, // Provide required index argument
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showEmotionDialog,
        child: const Icon(Icons.add), // Use const
      ),
    );
  }
}
