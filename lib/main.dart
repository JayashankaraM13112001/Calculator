import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart'; // Import the library

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculator',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  CalculatorScreenState createState() =>
      CalculatorScreenState(); // Removed underscore
}

class CalculatorScreenState extends State<CalculatorScreen> {
  // Removed underscore
  String _input = ""; // Stores user input (e.g., "3+5×2")
  String _output = "0"; // Stores the result

  void _onButtonPressed(String value) {
    setState(() {
      if (value == "C") {
        _input = "";
        _output = "0";
      } else if (value == "=") {
        _output = _calculateResult(_input);
      } else {
        _input += value;
      }
    });
  }

  String _calculateResult(String expression) {
    try {
      // Replace '×' with '*' and '÷' with '/' for calculation
      expression = expression.replaceAll('×', '*').replaceAll('÷', '/');

      // Use math_expressions package to evaluate the expression
      Parser parser = Parser();
      Expression exp = parser.parse(expression);
      ContextModel cm = ContextModel();

      double eval = exp.evaluate(EvaluationType.REAL, cm);
      return eval
          .toStringAsFixed(5)
          .replaceAll(RegExp(r'\.?0+$'), ""); // Remove trailing zeros
    } catch (e) {
      return "Error";
    }
  }

  Widget _buildButton(String label, {Color? color}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(20),
            backgroundColor: color ?? Colors.grey[200],
            textStyle: const TextStyle(fontSize: 24),
          ),
          onPressed: () => _onButtonPressed(label),
          child: Text(label,
              style: TextStyle(
                  color: color != null ? Colors.white : Colors.black)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Calculator"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.all(16),
              child: Text(
                _input.isEmpty ? "0" : _input,
                style:
                    const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Container(
            alignment: Alignment.bottomRight,
            padding: const EdgeInsets.all(16),
            child: Text(
              _output,
              style: const TextStyle(fontSize: 30, color: Colors.blue),
            ),
          ),
          const Divider(),
          Column(
            children: [
              Row(children: [
                _buildButton("7"),
                _buildButton("8"),
                _buildButton("9"),
                _buildButton("÷", color: Colors.blue)
              ]),
              Row(children: [
                _buildButton("4"),
                _buildButton("5"),
                _buildButton("6"),
                _buildButton("×", color: Colors.blue)
              ]),
              Row(children: [
                _buildButton("1"),
                _buildButton("2"),
                _buildButton("3"),
                _buildButton("-", color: Colors.blue)
              ]),
              Row(children: [
                _buildButton("C", color: Colors.red),
                _buildButton("0"),
                _buildButton("=", color: Colors.green),
                _buildButton("+", color: Colors.blue)
              ]),
            ],
          ),
        ],
      ),
    );
  }
}
