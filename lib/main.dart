import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/analytics_service.dart';
import 'services/crashlytics_service.dart';

void main() async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();

    // Initialize Crashlytics
    final crashlyticsService = CrashlyticsService();
    await crashlyticsService.initialize();

    final analyticsService = AnalyticsService();
    await analyticsService.logAppOpen();

    runApp(MyApp(analyticsService: analyticsService));
  }, (error, stack) {
    CrashlyticsService().recordError(error, stack, fatal: true);
  });
}

class MyApp extends StatelessWidget {
  final AnalyticsService analyticsService;

  const MyApp({super.key, required this.analyticsService});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      navigatorObservers: [analyticsService.observer],
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    AnalyticsService().logScreenView(
      screenName: 'home_page',
      screenClass: 'MyHomePage',
    );
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });

    AnalyticsService().logEvent(
      name: 'button_pressed',
      parameters: {
        'button_name': 'increment',
        'counter_value': _counter,
      },
    );
  }

  void _testCrash() {
    // Log a non-fatal error for testing
    CrashlyticsService().recordError(
      Exception('Test non-fatal error'),
      StackTrace.current,
      reason: 'Testing Crashlytics integration',
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Non-fatal error logged to Crashlytics')),
    );
  }

  void _triggerFatalCrash() {
    // This will cause a fatal crash - use only for testing!
    CrashlyticsService().testCrash();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.bug_report),
            tooltip: 'Test Crashlytics',
            onPressed: _testCrash,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _testCrash,
              icon: const Icon(Icons.warning),
              label: const Text('Log Non-Fatal Error'),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _triggerFatalCrash,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              icon: const Icon(Icons.dangerous),
              label: const Text('Trigger Fatal Crash'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
