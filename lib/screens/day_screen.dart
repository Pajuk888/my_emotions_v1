import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_emotions_v1/providers/emotion_provider.dart';
import 'package:my_emotions_v1/widgets/emotion_card.dart';
import 'package:my_emotions_v1/widgets/emotion_dialog.dart';

class DayScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final emotionProvider = Provider.of<EmotionProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Emotions'),
        actions: [
          Container(
            margin: EdgeInsets.all(8),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue,
            ),
            child: Center(
              child: Text(
                emotionProvider.entryCount.toString(),
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(8),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.green,
            ),
            child: Center(
              child: Text(
                emotionProvider.averageRating.toStringAsFixed(1),
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: emotionProvider.emotions.length,
        itemBuilder: (context, index) {
          final emotion = emotionProvider.emotions[index];
          return EmotionCard(
            emotion: emotion,
            index: index,
            onDelete: () {
              emotionProvider.deleteEmotion(index);
            },
            onEdit: () {
              showDialog(
                context: context,
                builder: (context) => EmotionDialog(
                  emotion: emotion,
                  index: index,
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => EmotionDialog(),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
