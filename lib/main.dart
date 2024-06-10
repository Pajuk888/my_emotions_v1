import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_emotions_v1/providers/emotion_provider.dart';
import 'package:my_emotions_v1/screens/day_screen.dart';
import 'package:my_emotions_v1/screens/week_screen.dart';
import 'package:my_emotions_v1/screens/month_screen.dart';
import 'package:my_emotions_v1/widgets/emotion_dialog.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => EmotionProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Emotions',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PageController _pageController;
  int _currentIndex = 0;
  bool _dialogShown = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showEmotionDialogOnStart(context);
    });
  }

  void _showEmotionDialogOnStart(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final isDialogShown = prefs.getBool('dialogShown') ?? false;

    if (!isDialogShown) {
      showDialog(
        context: context,
        builder: (context) => EmotionDialog(),
      );

      await prefs.setBool('dialogShown', true);
    }
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onNavigationItemSelected(int index) {
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Emotions'),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: [
          DayScreen(),
          WeekScreen(),
          MonthScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onNavigationItemSelected,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Day',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_view_week),
            label: 'Week',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_view_month),
            label: 'Month',
          ),
        ],
      ),
    );
  }
}
