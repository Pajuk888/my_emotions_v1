import 'package:flutter/material.dart';
import 'package:my_emotions_v1/models/emotion_entry.dart';
import 'package:my_emotions_v1/widgets/emotion_dialog.dart';

class EmotionCard extends StatelessWidget {
  final EmotionEntry entry;
  final VoidCallback onDelete;
  final ValueChanged<EmotionEntry> onEdit;

  const EmotionCard(
      {required this.entry,
      required this.onDelete,
      required this.onEdit,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Stack(
            children: [
              _buildRatingBar(entry.rating),
              Positioned.fill(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        'Rating: ${entry.rating}',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          ListTile(
            title: Text(entry.description),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Tags: ${entry.tags}'), // join method removed
                Text('Comments: ${entry.comments}'),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _editEntry(context),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: onDelete,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingBar(int rating) {
    return Container(
      height: 30,
      color: Colors.blue,
      child: Row(
        children: [
          Expanded(
            flex: rating,
            child: Container(color: Colors.blue),
          ),
          Expanded(
            flex: 10 - rating,
            child: Container(color: Colors.blue[100]),
          ),
        ],
      ),
    );
  }

  void _editEntry(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return EmotionDialog(
          onSave: (updatedEntry) => onEdit(updatedEntry),
          entry: entry,
          date: entry.date,
        );
      },
    );
  }
}
