import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/emotion_provider.dart';

class EmotionDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TextEditingController _controller = TextEditingController();

    return AlertDialog(
      title: Text('Rate Your Day'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('How do you feel today?'),
            TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: 'Describe your feelings'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text('Save'),
          onPressed: () {
            Provider.of<EmotionProvider>(context, listen: false)
                .addEmotion(_controller.text);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
