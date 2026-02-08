import 'package:flutter/material.dart';
import '../config/app_constants.dart';
import '../config/theme.dart';
import '../screens/home/home_screen.dart';
import '../services/analytics_service.dart';

class App extends StatelessWidget {
  final AnalyticsService analyticsService;

  const App({super.key, required this.analyticsService});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      navigatorObservers: [analyticsService.observer],
      home: const HomeScreen(),
    );
  }
}
