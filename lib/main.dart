import 'package:flutter/material.dart';
import 'cas_bridge.dart';
import 'symbol_finder.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Symbolic Math Stack Test',
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
  Map<String, String> _results = {};
  bool _isLoading = false;
  CasBridge? _casBridge;
  SymbolFinder? _symbolFinder;
  String _error = '';
  String _symbolReport = '';

  @override
  void initState() {
    super.initState();
    try {
      _casBridge = CasBridge();
      _symbolFinder = SymbolFinder();
    } catch (e) {
      _error = 'Failed to initialize bridge: $e';
    }
  }

  Future<void> _findAvailableSymbols() async {
    if (_error.isNotEmpty || _symbolFinder == null) return;
    
    setState(() {
      _isLoading = true;
      _symbolReport = '';
    });

    try {
      final report = _symbolFinder!.getReport();
      setState(() {
        _symbolReport = report;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Symbol detection failed: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _testAllLibraries() async {
    if (_error.isNotEmpty || _casBridge == null || _symbolFinder == null) return;
    
    setState(() {
      _isLoading = true;
      _results = {};
    });

    try {
      // Only test GMP for now since we know it works
      _results['GMP'] = 'GMP 2^128 = ${_casBridge!.testGMP(128)}';
      
      // For other libraries, just test if symbols exist
      final symbols = _symbolFinder!.findAvailableSymbols();
      
      _results['MPFR'] = symbols['MPFR']!.isNotEmpty 
          ? 'MPFR symbols available: ${symbols['MPFR']!.join(', ')}'
          : 'MPFR Error: No symbols found';
          
      _results['MPC'] = symbols['MPC']!.isNotEmpty
          ? 'MPC symbols available: ${symbols['MPC']!.join(', ')}'
          : 'MPC Error: No symbols found';
          
      _results['FLINT'] = symbols['FLINT']!.isNotEmpty
          ? 'FLINT symbols available: ${symbols['FLINT']!.join(', ')}'
          : 'FLINT Error: No symbols found';
          
      _results['SymEngine'] = symbols['SymEngine']!.isNotEmpty
          ? 'SymEngine symbols available: ${symbols['SymEngine']!.join(', ')}'
          : 'SymEngine Error: No symbols found';
      
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

  Widget _buildResultCard(String library, String result) {
    final isError = result.contains('Error:');
    
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isError ? Colors.red : Colors.green,
          child: Text(
            library[0],
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          library,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            result,
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 12,
              color: isError ? Colors.red[300] : Colors.white70,
            ),
          ),
        ),
        isThreeLine: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Symbolic Math Stack Test'),
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

            if (_symbolReport.isNotEmpty)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[900],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _symbolReport,
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                ),
              ),
            
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Test Results for Mathematical Libraries',
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
                    Text('Testing all libraries...'),
                  ],
                ),
              ),
            
            if (_results.isNotEmpty)
              Column(
                children: [
                  _buildResultCard('GMP', _results['GMP'] ?? 'No result'),
                  _buildResultCard('MPFR', _results['MPFR'] ?? 'No result'),
                  _buildResultCard('MPC', _results['MPC'] ?? 'No result'),
                  _buildResultCard('FLINT', _results['FLINT'] ?? 'No result'),
                  _buildResultCard('SymEngine', _results['SymEngine'] ?? 'No result'),
                ],
              ),
            
            if (_results.isEmpty && !_isLoading && _error.isEmpty)
              const Padding(
                padding: EdgeInsets.all(32.0),
                child: Text(
                  'Press "Find Symbols" to discover available functions,\n'
                  'then "Test All" to run actual tests.\n\n'
                  '• GMP: Arbitrary precision integers\n'
                  '• MPFR: Arbitrary precision floating point\n'
                  '• MPC: Complex numbers\n'
                  '• FLINT: Fast number theory\n'
                  '• SymEngine: Symbolic mathematics\n',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: _error.isNotEmpty
          ? null
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FloatingActionButton.extended(
                  onPressed: _isLoading ? null : _findAvailableSymbols,
                  heroTag: "symbols",
                  tooltip: 'Find Available Symbols',
                  icon: const Icon(Icons.search),
                  label: const Text('Find Symbols'),
                ),
                const SizedBox(height: 8),
                FloatingActionButton.extended(
                  onPressed: _isLoading ? null : _testAllLibraries,
                  heroTag: "test",
                  tooltip: 'Test All Libraries',
                  icon: _isLoading 
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.science),
                  label: Text(_isLoading ? 'Testing...' : 'Test All'),
                ),
              ],
            ),
    );
  }
}