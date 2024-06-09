import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/emotion_provider.dart';

class EmotionCard extends StatelessWidget {
  final String emotion;
  final int index;

  EmotionCard({required this.emotion, required this.index});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(emotion),
        trailing: IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            Provider.of<EmotionProvider>(context, listen: false)
                .deleteEntry(index);
          },
        ),
      ),
    );
  }
}
