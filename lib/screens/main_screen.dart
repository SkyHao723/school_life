import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:school_life/screens/home_screen.dart';
import 'package:school_life/screens/feed_screen.dart';
import 'package:school_life/screens/market_screen.dart';
import 'package:school_life/screens/settings_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // 页面列表
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const HomeScreen(),
      const FeedScreen(),
      const MarketScreen(),
      const SettingsScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: FBottomNavigationBar(
        index: _currentIndex,
        onChange: (index) => setState(() => _currentIndex = index),
        children: [
          FBottomNavigationBarItem(
            icon: Icon(FIcons.house),
            label: const Text('首页'),
          ),
          FBottomNavigationBarItem(
            icon: Icon(FIcons.messageCircle),
            label: const Text('信息流'),
          ),
          FBottomNavigationBarItem(
            icon: Icon(FIcons.shoppingCart),
            label: const Text('市场'),
          ),
          FBottomNavigationBarItem(
            icon: Icon(FIcons.settings),
            label: const Text('设置'),
          ),
        ],
      ),
    );
  }
}