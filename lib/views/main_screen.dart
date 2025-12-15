import 'package:flutter/material.dart';
import 'package:stride_sisterhood/views/home_screen.dart';
import 'package:stride_sisterhood/views/log_run_screen.dart';
import 'package:stride_sisterhood/views/run_history_screen.dart';
import 'package:stride_sisterhood/views/community_route_screen.dart';

// AppTab model
class AppTab {
  final String label;
  final Icon icon;
  final Widget screen;

  const AppTab({required this.label, required this.icon, required this.screen});
}

// List of tabs
const List<AppTab> appTabs = [
  AppTab(label: 'Home', icon: Icon(Icons.home), screen: HomeScreen()),
  AppTab(label: 'Log Run', icon: Icon(Icons.add_circle_outline), screen: LogRunScreen()),
  AppTab(label: 'History', icon: Icon(Icons.history), screen: RunHistoryScreen()),
  AppTab(label: 'Routes', icon: Icon(Icons.map), screen: CommunityRoutesScreen()),
];

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: appTabs[_selectedIndex].screen),
      bottomNavigationBar: BottomNavigationBar(
        items: appTabs
            .map((tab) => BottomNavigationBarItem(icon: tab.icon, label: tab.label))
            .toList(),
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.pink[400],
        unselectedItemColor: Colors.grey[600],
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
