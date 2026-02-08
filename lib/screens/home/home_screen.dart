import 'package:flutter/material.dart';
import '../../config/app_constants.dart';
import '../../services/analytics_service.dart';
import '../../services/crashlytics_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    AnalyticsService().logScreenView(
      screenName: AppConstants.screenHome,
      screenClass: 'HomeScreen',
    );
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });

    AnalyticsService().logEvent(
      name: AppConstants.eventButtonPressed,
      parameters: {
        AppConstants.paramButtonName: 'increment',
        AppConstants.paramCounterValue: _counter,
      },
    );
  }

  void _testCrash() {
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
    CrashlyticsService().testCrash();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Home'),
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
