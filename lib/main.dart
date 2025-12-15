import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:stride_sisterhood/firebase_options.dart';
import 'package:stride_sisterhood/services/firestore_service.dart';
import 'package:stride_sisterhood/viewmodels/run_viewmodel.dart';
import 'package:stride_sisterhood/viewmodels/route_viewmodel.dart';
import 'package:stride_sisterhood/views/login_screen.dart';
import 'package:stride_sisterhood/viewmodels/user_viewmodel.dart';
import 'package:stride_sisterhood/views/main_screen.dart';

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
        ChangeNotifierProvider<UserViewModel>(
          create: (_) => UserViewModel(),
        ),
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
        home: const LoginScreen(), // Start with LoginScreen
      ),
    );
  }
}
