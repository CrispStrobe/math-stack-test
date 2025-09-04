import 'package:flutter/material.dart';
// Import the plugin package instead of the local file
import 'package:symbolic_math_bridge/symbolic_math_bridge.dart';

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
  // Use the class from the plugin
  SymbolicMathBridge? _bridge;
  String _error = '';

  @override
  void initState() {
    super.initState();
    try {
      // Initialize the bridge from the plugin
      _bridge = SymbolicMathBridge();
    } catch (e) {
      _error = 'Failed to initialize bridge: $e';
    }
  }

  Future<void> _runTests() async {
    if (_error.isNotEmpty || _bridge == null) return;
    
    setState(() {
      _isLoading = true;
      _results = {};
    });

    try {
      // --- Run all the tests using the new API ---
      final newResults = <String, List<String>>{};

      newResults['SymEngine'] = [
        'Evaluate 2+3*4: ${_bridge!.evaluate("2+3*4")}',
        'Expand (x+1)^2: ${_bridge!.expand("(x+1)^2")}',
        'Solve x^2-4=0: ${_bridge!.solve("x^2-4", "x")}',
        'Differentiate sin(x): ${_bridge!.differentiate("sin(x)", "x")}',
        'Substitute x=2 in x^2: ${_bridge!.substitute("x^2", "x", "2")}',
        'Get Pi constant: ${_bridge!.getPi()}',
      ];

      newResults['Math Functions'] = [
        'sin(pi/2): ${_bridge!.evaluate("sin(pi/2)")}',
        'sqrt(16): ${_bridge!.callUnary("sqrt", "16")}',
        'log(E): ${_bridge!.callUnary("log", _bridge!.getE())}',
        'abs(-5): ${_bridge!.callUnary("abs", "-5")}',
      ];
      
      newResults['Number Theory'] = [
        'gcd(24, 36): ${_bridge!.gcd("24", "36")}',
        'lcm(24, 36): ${_bridge!.lcm("24", "36")}',
        '10!: ${_bridge!.factorial(10)}',
        'fib(15): ${_bridge!.fibonacci(15)}',
      ];
      
      // Matrix tests
      final matrixA = _bridge!.createMatrix(2, 2);
      matrixA.set(0, 0, "1");
      matrixA.set(0, 1, "2");
      matrixA.set(1, 0, "3");
      matrixA.set(1, 1, "4");

      final matrixB = _bridge!.createMatrix(2, 2);
      matrixB.set(0, 0, "5");
      matrixB.set(0, 1, "6");
      matrixB.set(1, 0, "7");
      matrixB.set(1, 1, "8");

      final matrixC = matrixA * matrixB;

      newResults['Matrix Operations'] = [
        'Matrix A: ${matrixA.toString().replaceAll("\n", " ")}',
        'Determinant of A: ${matrixA.getDeterminant()}',
        'A * B: ${matrixC.toString().replaceAll("\n", " ")}',
      ];

      // Clean up matrix memory
      matrixA.dispose();
      matrixB.dispose();
      matrixC.dispose();

      _results = newResults;
      
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

  // --- UI (No changes needed below this line) ---

  Widget _buildResultCard(String library, List<String> results) {
    final hasErrors = results.any((r) => r.toLowerCase().contains('error') || r.toLowerCase().contains('not available'));
    
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
          '${results.length} results',
          style: TextStyle(color: Colors.grey[400], fontSize: 12),
        ),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: results.map((result) {
                final isError = result.toLowerCase().contains('error');
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text(
                    result,
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 13,
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

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Full Stack Test Results',
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
                      'Press "Run Tests" to execute the full suite of mathematical operations.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, height: 1.5),
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
