import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() => runApp(ScientificCalculator());

class ScientificCalculator extends StatelessWidget {
  const ScientificCalculator({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _expression = "";
  String _result = "";

  void _onPressed(String text) {
    setState(() {
      _expression += text;
    });
  }

  void _clear() {
    setState(() {
      _expression = "";
      _result = "";
    });
  }

  void _delete() {
    if (_expression.isNotEmpty) {
      setState(() {
        _expression = _expression.substring(0, _expression.length - 1);
      });
    }
  }

  void _evaluate() {
    try {
      // Substituindo 'x' por '*' para multiplicação
      String expressionWithFunctions = _expression
          .replaceAll('x', '*')
          .replaceAll('sin', 'sin(')
          .replaceAll('cos', 'cos(')
          .replaceAll('tan', 'tan(')
          .replaceAll('ln', 'ln(')
          .replaceAll('sqrt', 'sqrt(');

      // Agora a expressão deve ter as funções adequadas
      // Vamos usar o parser para analisar a expressão
      Parser p = Parser();
      ContextModel cm = ContextModel();
      Expression exp = p.parse(expressionWithFunctions);

      // Calculando o resultado
      double result = exp.evaluate(EvaluationType.REAL, cm);

      // Adiciona o símbolo de positivo para números maiores que zero
      // E adiciona o emoji de sorriso ou tristeza conforme o resultado
      setState(() {
        if (result >= 0) {
          _result = "+${result.toString()} 😊";  // Emoji de sorriso
          // Mostrar o Snackbar de Parabéns
          _showCongratulationsSnackbar();
        } else {
          _result = "${result.toString()} 😞";  // Emoji de tristeza
        }
      });
    } catch (e) {
      setState(() {
        _result = "Erro 😞";  // Emoji de tristeza em caso de erro
      });
    }
  }

  void _showCongratulationsSnackbar() {
    // Exibe um Snackbar parabenizando o usuário
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Parabéns! Você obteve um resultado positivo! 🎉"),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora Científica'),
        backgroundColor: Colors.blueGrey[900],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(16),
            alignment: Alignment.centerRight,
            child: Text(
              _expression,
              style: const TextStyle(fontSize: 24, color: Colors.white),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            alignment: Alignment.centerRight,
            child: Text(
              _result,
              style: const TextStyle(fontSize: 36, color: Colors.greenAccent),
            ),
          ),
          const Divider(color: Colors.white30),
          Expanded(
            child: Column(
              children: [
                Row(
                  children: <Widget>[
                    _buildButton("7", Colors.blueAccent),
                    _buildButton("8", Colors.blueAccent),
                    _buildButton("9", Colors.blueAccent),
                    _buildButton("/", Colors.purple),
                  ],
                ),
                Row(
                  children: <Widget>[
                    _buildButton("4", Colors.blueAccent),
                    _buildButton("5", Colors.blueAccent),
                    _buildButton("6", Colors.blueAccent),
                    _buildButton("x", Colors.purple),
                  ],
                ),
                Row(
                  children: <Widget>[
                    _buildButton("1", Colors.blueAccent),
                    _buildButton("2", Colors.blueAccent),
                    _buildButton("3", Colors.blueAccent),
                    _buildButton("-", Colors.purple),
                  ],
                ),
                Row(
                  children: <Widget>[
                    _buildButton(".", Colors.blueAccent),
                    _buildButton("0", Colors.blueAccent),
                    _buildButton("00", Colors.blueAccent),
                    _buildButton("+", Colors.purple),
                  ],
                ),
                Row(
                  children: <Widget>[
                    _buildButton("sin", Colors.orange),
                    _buildButton("cos", Colors.orange),
                    _buildButton("tan", Colors.orange),
                    _buildButton("^", Colors.purple),
                  ],
                ),
                Row(
                  children: <Widget>[
                    _buildButton("ln", Colors.orange),
                    _buildButton("sqrt", Colors.orange),
                    _buildButton("C", Colors.redAccent),
                    _buildButton("=", Colors.green),
                  ],
                ),
                Row(
                  children: <Widget>[
                    _buildButton("DEL", Colors.red),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(String text, Color color) {
    return Expanded(
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.all(24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: () {
          if (text == "C") {
            _clear();
          } else if (text == "DEL") {
            _delete();
          } else if (text == "=") {
            _evaluate();
          } else if (text == "sqrt") {
            _onPressed("sqrt(");
          } else {
            _onPressed(text);
          }
        },
        child: Text(
          text,
          style: const TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }
}
