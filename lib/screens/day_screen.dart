import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:my_emotions_v1/models/emotion_entry.dart';
import 'package:my_emotions_v1/providers/emotion_provider.dart';
import 'package:my_emotions_v1/widgets/emotion_card.dart';
import 'package:my_emotions_v1/widgets/emotion_dialog.dart';
import 'package:flutter_charts/flutter_charts.dart';
import 'dart:math'; // Import the math library

class DayScreen extends StatefulWidget {
  final DateTime date;

  DayScreen({Key? key, required this.date}) : super(key: key);

  @override
  _DayScreenState createState() => _DayScreenState();
}

class _DayScreenState extends State<DayScreen> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.date;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<EmotionProvider>(context, listen: false).loadEntries();
    });
  }

  void _selectDate(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
  }

  void _navigateToPreviousDay() {
    _selectDate(_selectedDate.subtract(Duration(days: 1)));
  }

  void _navigateToNextDay() {
    _selectDate(_selectedDate.add(Duration(days: 1)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_left),
              onPressed: _navigateToPreviousDay,
            ),
            Text(DateFormat('EEE d MMM').format(_selectedDate)),
            IconButton(
              icon: Icon(Icons.arrow_right),
              onPressed: _navigateToNextDay,
            ),
          ],
        ),
      ),
      body: Consumer<EmotionProvider>(
        builder: (context, provider, child) {
          final entries = provider.getEntriesByDate(_selectedDate);
          final averageRating = provider.getAverageRatingByDate(_selectedDate);
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildInfoBox('Entries', entries.length.toString()),
                    _buildInfoBox('Average', averageRating.toStringAsFixed(1)),
                  ],
                ),
              ),
              _buildBarChart(entries),
              Expanded(
                child: ListView.builder(
                  itemCount: entries.length,
                  itemBuilder: (context, index) {
                    final entry = entries[index];
                    return EmotionCard(
                      entry: entry,
                      onDelete: () {
                        provider.deleteEmotion(index);
                      },
                      onEdit: (updatedEntry) {
                        provider.updateEmotion(index, updatedEntry);
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openEmotionDialog(context),
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildInfoBox(String title, String value) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(title, style: TextStyle(color: Colors.white, fontSize: 16)),
          SizedBox(height: 4),
          Text(value, style: TextStyle(color: Colors.white, fontSize: 24)),
        ],
      ),
    );
  }

  Widget _buildBarChart(List<EmotionEntry> entries) {
    LabelLayoutStrategy? xContainerLabelLayoutStrategy;
    ChartData chartData;
    ChartOptions chartOptions = const ChartOptions();

    final dataRows = [
      entries.map((e) => e.rating.toDouble()).toList(),
    ];
    final xLabels =
        entries.map((e) => DateFormat('HH:mm').format(e.date)).toList();

    chartData = ChartData(
      dataRows: dataRows,
      xUserLabels: xLabels,
      dataRowsLegends: const ['Ratings'],
      chartOptions: chartOptions,
    );

    var lineChartContainer = LineChartTopContainer(
      chartData: chartData,
      xContainerLabelLayoutStrategy: xContainerLabelLayoutStrategy,
    );

    var lineChart = LineChart(
      painter: LineChartPainter(
        lineChartContainer: lineChartContainer,
      ),
    );

    return Container(
      height: 200,
      padding: EdgeInsets.all(16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          width: max(400, entries.length * 50),
          child: lineChart,
        ),
      ),
    );
  }

  void _openEmotionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return EmotionDialog(
          onSave: (newEntry) {
            Provider.of<EmotionProvider>(context, listen: false)
                .addEmotion(newEntry);
          },
          date: _selectedDate,
        );
      },
    );
  }
}
