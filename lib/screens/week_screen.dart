import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:my_emotions_v1/providers/emotion_provider.dart';
import 'package:my_emotions_v1/screens/day_screen.dart';

class WeekScreen extends StatelessWidget {
  final DateTime startOfWeek;

  WeekScreen({Key? key, required this.startOfWeek}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Week View'),
      ),
      body: Consumer<EmotionProvider>(
        builder: (context, provider, child) {
          final weekEntries = provider.entries
              .where((entry) =>
                  entry.date.isAfter(startOfWeek.subtract(Duration(days: 1))) &&
                  entry.date.isBefore(startOfWeek.add(Duration(days: 7))))
              .toList();
          final totalEntries = weekEntries.length;
          final averageRating = weekEntries.isEmpty
              ? 0.0
              : weekEntries.fold(0.0, (sum, entry) => sum + entry.rating) /
                  weekEntries.length;

          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemCount: 8,
            itemBuilder: (context, index) {
              if (index < 7) {
                final day = startOfWeek.add(Duration(days: index));
                final entries = provider.getEntriesByDate(day);
                final averageRating = provider.getAverageRatingByDate(day);

                return GestureDetector(
                  onTap: () => _navigateToDate(context, day),
                  child: Card(
                    color: Colors.lightBlue[50], // Change background color here
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            color: Colors.grey[800],
                            padding: const EdgeInsets.all(4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  DateFormat('EEE d').format(day),
                                  style: const TextStyle(color: Colors.white),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      '[${entries.length}]',
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    const SizedBox(width: 4),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: Colors.white),
                                      ),
                                      child: Text(
                                        averageRating.toStringAsFixed(1),
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          ...entries.map((entry) {
                            final tags = entry.tags
                                .split(',')
                                .map((tag) => tag.trim())
                                .toList();
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.tag, size: 12), // Hashtag icon
                                const SizedBox(
                                    width: 4), // Space between icon and text
                                Expanded(
                                  child: Text(
                                    tags.join(', '),
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                return Card(
                  color: Colors
                      .grey[300], // Change background color for summary card
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Weekly Summary'),
                        Text('Total Entries: $totalEntries'),
                        Text('Avg Rating: ${averageRating.toStringAsFixed(1)}'),
                      ],
                    ),
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }

  void _navigateToDate(BuildContext context, DateTime date) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DayScreen(date: date),
      ),
    );
  }
}
