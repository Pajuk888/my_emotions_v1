import 'package:flutter/material.dart';
import 'package:my_emotions_v1/models/emotion_entry.dart';

class EmotionDialog extends StatefulWidget {
  final EmotionEntry? entry;
  final ValueChanged<EmotionEntry> onSave;
  final DateTime date;

  const EmotionDialog({
    Key? key,
    this.entry,
    required this.onSave,
    required this.date,
  }) : super(key: key);

  @override
  _EmotionDialogState createState() => _EmotionDialogState();
}

class _EmotionDialogState extends State<EmotionDialog> {
  late TextEditingController _descriptionController;
  late TextEditingController _tagsController;
  late TextEditingController _commentsController;
  late double _rating;

  @override
  void initState() {
    super.initState();
    _descriptionController =
        TextEditingController(text: widget.entry?.description);
    _tagsController = TextEditingController(text: widget.entry?.tags);
    _commentsController = TextEditingController(text: widget.entry?.comments);
    _rating = widget.entry?.rating.toDouble() ?? 0.0;
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _tagsController.dispose();
    _commentsController.dispose();
    super.dispose();
  }

  void _saveEntry() {
    final newEntry = EmotionEntry(
      description: _descriptionController.text,
      rating: _rating.toInt(), // Ensure rating is of type int
      tags: _tagsController.text, // Ensure tags is a string
      comments: _commentsController.text,
      date: widget.date,
    );
    widget.onSave(newEntry);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.entry == null ? 'New Emotion' : 'Edit Emotion'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(labelText: 'Description'),
          ),
          TextField(
            controller: _tagsController,
            decoration:
                const InputDecoration(labelText: 'Tags (comma separated)'),
          ),
          TextField(
            controller: _commentsController,
            decoration: const InputDecoration(labelText: 'Comments'),
          ),
          Slider(
            value: _rating,
            min: 0,
            max: 10,
            divisions: 10,
            label: _rating.round().toString(),
            onChanged: (value) {
              setState(() {
                _rating = value;
              });
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _saveEntry,
          child: const Text('Save'),
        ),
      ],
    );
  }
}
