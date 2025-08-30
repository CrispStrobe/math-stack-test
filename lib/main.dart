import 'package:flutter/material.dart';
import 'cas_bridge.dart'; // We will create this file next

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GMP FFI Test',
      theme: ThemeData.dark(useMaterial3: true),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _gmpResult = 'Press the button to call GMP';
  final CasBridge _casBridge = CasBridge();

  Future<void> _callGmpFunction() async {
    // This is where we'll call our native code.
    // Let's test by calculating 2^128 using GMP.
    setState(() {
      _gmpResult = 'Calling native code...';
    });

    try {
      final result = _casBridge.powerOfTwo(128);
      setState(() {
        _gmpResult = 'GMP says 2^128 is:\n\n$result';
      });
    } catch (e) {
      setState(() {
        _gmpResult = 'Error calling native code:\n$e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter to GMP FFI Test'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Result from C/GMP library:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                _gmpResult,
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _callGmpFunction,
        tooltip: 'Call GMP',
        icon: const Icon(Icons.memory),
        label: const Text('Calculate'),
      ),
    );
  }
}
