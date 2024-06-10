import 'package:flutter/material.dart';
import 'package:my_emotions_v1/models/emotion.dart';

class EmotionCard extends StatelessWidget {
  final Emotion emotion;
  final int index;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  EmotionCard({
    required this.emotion,
    required this.index,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(emotion.emotion),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Rating: ${emotion.rating}'),
            Text('Description: ${emotion.description}'),
            Text('Tags: ${emotion.tags.join(', ')}'),
            Text('Comments: ${emotion.comments}'),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: onEdit,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
