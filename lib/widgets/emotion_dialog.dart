import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_emotions_v1/providers/emotion_provider.dart';
import 'package:my_emotions_v1/models/emotion.dart';

class EmotionDialog extends StatefulWidget {
  final Emotion? emotion;
  final int? index;

  EmotionDialog({this.emotion, this.index});

  @override
  _EmotionDialogState createState() => _EmotionDialogState();
}

class _EmotionDialogState extends State<EmotionDialog> {
  final _formKey = GlobalKey<FormState>();
  late String _emotion;
  late int _rating;
  late String _description;
  late List<String> _tags;
  late String _comments;

  @override
  void initState() {
    super.initState();
    if (widget.emotion != null) {
      _emotion = widget.emotion!.emotion;
      _rating = widget.emotion!.rating;
      _description = widget.emotion!.description;
      _tags = widget.emotion!.tags;
      _comments = widget.emotion!.comments;
    } else {
      _emotion = '';
      _rating = 1;
      _description = '';
      _tags = [];
      _comments = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.emotion == null ? 'Add Emotion' : 'Edit Emotion'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              DropdownButtonFormField<int>(
                value: _rating,
                decoration: InputDecoration(labelText: 'Rating'),
                items: List.generate(10, (index) => index + 1)
                    .map((rating) => DropdownMenuItem(
                          value: rating,
                          child: Text(rating.toString()),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _rating = value!;
                  });
                },
                onSaved: (value) {
                  _rating = value!;
                },
              ),
              TextFormField(
                initialValue: _emotion,
                decoration: InputDecoration(labelText: 'Describe your feeling'),
                onSaved: (value) {
                  _emotion = value!;
                },
              ),
              TextFormField(
                initialValue: _tags.join(', '),
                decoration:
                    InputDecoration(labelText: 'Tags (comma separated)'),
                onSaved: (value) {
                  _tags = value!.split(',').map((tag) => tag.trim()).toList();
                },
              ),
              TextFormField(
                initialValue: _comments,
                decoration: InputDecoration(labelText: 'Comments'),
                onSaved: (value) {
                  _comments = value!;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              final emotionProvider =
                  Provider.of<EmotionProvider>(context, listen: false);
              if (widget.emotion == null) {
                emotionProvider.addEmotion(Emotion(
                  date: DateTime.now(),
                  emotion: _emotion,
                  rating: _rating,
                  description: _description,
                  tags: _tags,
                  comments: _comments,
                ));
              } else {
                emotionProvider.updateEmotion(
                  widget.index!,
                  Emotion(
                    date: widget.emotion!.date,
                    emotion: _emotion,
                    rating: _rating,
                    description: _description,
                    tags: _tags,
                    comments: _comments,
                  ),
                );
              }
              Navigator.of(context).pop();
            }
          },
          child: Text('Save'),
        ),
      ],
    );
  }
}
