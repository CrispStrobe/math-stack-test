import 'package:flutter/material.dart';
import 'cas_bridge.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Math Stack Test',
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
  Map<String, List<String>> _results = {};
  bool _isLoading = false;
  CasBridge? _casBridge;
  String _error = '';
  Map<String, bool> _libraryStatus = {};

  @override
  void initState() {
    super.initState();
    try {
      _casBridge = CasBridge();
      _libraryStatus = _casBridge!.getLibraryStatus();
    } catch (e) {
      _error = 'Failed to initialize bridge: $e';
    }
  }

  Future<void> _runTests() async {
    if (_error.isNotEmpty || _casBridge == null) return;
    
    setState(() {
      _isLoading = true;
      _results = {};
    });

    try {
      // Get all test results
      _results = _casBridge!.getTestResults();
      
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Test failed: $e';
        _isLoading = false;
      });
    }
  }

  Widget _buildResultCard(String library, List<String> results) {
    final hasErrors = results.any((r) => r.contains('Error') || r.contains('not available') || r.contains('No symbols'));
    
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: hasErrors ? Colors.orange : Colors.green,
          child: Text(
            library.split(' ')[0][0],
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          library,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(
          '${results.length} ${library.contains('Symbols') ? 'symbols' : 'results'}',
          style: TextStyle(color: Colors.grey[400], fontSize: 12),
        ),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: results.map((result) {
                final isError = result.contains('Error') || result.contains('not available');
                final isSymbol = !result.contains(':') && !result.contains('=');
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text(
                    result,
                    style: TextStyle(
                      fontFamily: !isSymbol ? 'monospace' : null,
                      fontSize: isSymbol ? 12 : 13,
                      color: isError ? Colors.red[300] : Colors.white70,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusOverview() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[900],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Library Status',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 12),
          ..._libraryStatus.entries.map((e) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              children: [
                Icon(
                  e.value ? Icons.check_circle : Icons.error,
                  color: e.value ? Colors.green : Colors.red,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(e.key, style: const TextStyle(fontSize: 14)),
              ],
            ),
          )).toList(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mathematical Libraries Test'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (_error.isNotEmpty)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red[900],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _error,
                  style: const TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),

            if (_libraryStatus.isNotEmpty) _buildStatusOverview(),
            
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Mathematical Libraries Test Results',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
            ),
            
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.all(32.0),
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Running tests...'),
                  ],
                ),
              ),
            
            if (_results.isNotEmpty)
              Column(
                children: _results.entries
                    .map((entry) => _buildResultCard(entry.key, entry.value))
                    .toList(),
              ),
            
            if (_results.isEmpty && !_isLoading && _error.isEmpty)
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.calculate, size: 48, color: Colors.blue),
                    SizedBox(height: 16),
                    Text(
                      'Mathematical Library Test Suite',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Testing mathematical libraries:\n\n'
                      '• SymEngine: Symbolic mathematics\n'
                      '• GMP: Big integer arithmetic\n'  
                      '• MPFR: High-precision floating point\n'
                      '• MPC: Complex number arithmetic\n'
                      '• FLINT: Fast number theory\n\n'
                      'Press "Run Tests" to execute mathematics!',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, height: 1.5),
                    ),
                  ],
                ),
              ),
              
            const SizedBox(height: 100),
          ],
        ),
      ),
      floatingActionButton: _error.isNotEmpty
          ? null
          : FloatingActionButton.extended(
              onPressed: _isLoading ? null : _runTests,
              tooltip: 'Run Mathematical Tests',
              icon: _isLoading 
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : const Icon(Icons.play_arrow),
              label: Text(_isLoading ? 'Testing...' : 'Run Tests'),
            ),
    );
  }
}