import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_emotions_v1/providers/emotion_provider.dart';
import 'package:my_emotions_v1/screens/day_screen.dart';
import 'package:my_emotions_v1/screens/week_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PageController _pageController;
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: [
          DayScreen(date: DateTime.now()),
          WeekScreen(
              startOfWeek: DateTime.now()
                  .subtract(Duration(days: DateTime.now().weekday - 1))),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPageIndex,
        onTap: (index) {
          _pageController.jumpToPage(index);
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today), label: 'Day'),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_view_week), label: 'Week'),
        ],
      ),
    );
  }
}
