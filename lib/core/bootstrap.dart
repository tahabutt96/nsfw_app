import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import '../services/analytics_service.dart';
import '../services/crashlytics_service.dart';
import 'app.dart';

class Bootstrap {
  static Future<void> run() async {
    await runZonedGuarded(() async {
      WidgetsFlutterBinding.ensureInitialized();

      await Firebase.initializeApp();

      final crashlyticsService = CrashlyticsService();
      await crashlyticsService.initialize();

      final analyticsService = AnalyticsService();
      await analyticsService.logAppOpen();

      runApp(App(analyticsService: analyticsService));
    }, (error, stack) {
      CrashlyticsService().recordError(error, stack, fatal: true);
    });
  }
}
