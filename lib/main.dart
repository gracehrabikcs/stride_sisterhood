import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:stride_sisterhood/firebase_options.dart';
import 'package:stride_sisterhood/services/firestore_service.dart';
import 'package:stride_sisterhood/viewmodels/run_viewmodel.dart';
import 'package:stride_sisterhood/viewmodels/route_viewmodel.dart';
import 'package:stride_sisterhood/views/home_screen.dart';
import 'package:stride_sisterhood/views/log_run_screen.dart';
import 'package:stride_sisterhood/views/run_history_screen.dart';
import 'package:stride_sisterhood/views/community_routes_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const StrideSisterhoodApp());
}

// ------------------ App ------------------
class StrideSisterhoodApp extends StatelessWidget {
  const StrideSisterhoodApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FirestoreService>(create: (_) => FirestoreService()),
        ChangeNotifierProvider<RunViewModel>(
          create: (context) => RunViewModel(context.read<FirestoreService>()),
        ),
        ChangeNotifierProvider<RouteViewModel>(
          create: (context) => RouteViewModel(context.read<FirestoreService>()),
        ),
      ],
      child: MaterialApp(
        title: 'Stride Sisterhood',
        theme: ThemeData(
          primarySwatch: Colors.pink,
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            elevation: 1,
            iconTheme: IconThemeData(color: Colors.black87),
            titleTextStyle: TextStyle(
              color: Colors.black87,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          fontFamily: 'Roboto',
        ),
        home: const MainScreen(),
      ),
    );
  }
}

// ------------------ AppTab Model ------------------
class AppTab {
  final String label;
  final Icon icon;
  final Widget screen;

  const AppTab({required this.label, required this.icon, required this.screen});
}

// ------------------ List of Tabs ------------------
const List<AppTab> appTabs = [
  AppTab(label: 'Home', icon: Icon(Icons.home), screen: HomeScreen()),
  AppTab(label: 'Log Run', icon: Icon(Icons.add_circle_outline), screen: LogRunScreen()),
  AppTab(label: 'History', icon: Icon(Icons.history), screen: RunHistoryScreen()),
  AppTab(label: 'Routes', icon: Icon(Icons.map), screen: CommunityRoutesScreen()),
];

// ------------------ MainScreen ------------------
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
      body: Center(
        child: appTabs[_selectedIndex].screen,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: appTabs
            .map((tab) => BottomNavigationBarItem(icon: tab.icon, label: tab.label))
            .toList(),
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.pink[400],
        unselectedItemColor: Colors.grey[600],
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed, // Ensures all labels are visible
      ),
    );
  }
}
