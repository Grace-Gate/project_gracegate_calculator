import 'package:flutter/material.dart';
import 'package:project_gracegate_calculator/button_values.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({Key? key}) : super(key: key);

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String number1 = ""; // . 0-9
  String operand = ""; // + - * /
  String number2 = ""; // . 0-9

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                child: Container(
                  alignment: Alignment.bottomRight,
                  padding: EdgeInsets.all(16),
                  child: Text(
                    formatDisplay(),
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ),
            ),
            Wrap(
              children: Btn.buttonValues
                  .map((value) => SizedBox(
                        width: value == Btn.n0
                            ? screenSize.width / 2
                            : (screenSize.width / 4),
                        height: screenSize.width / 5,
                        child: buildButton(value),
                      ))
                  .toList(),
            )
          ],
        ),
      ),
    );
  }

  Widget buildButton(String value) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
          color: getBtnColor(value),
          clipBehavior: Clip.hardEdge,
          shape: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white24,
            ),
            borderRadius: BorderRadius.circular(100),
          ),
          child: InkWell(
              onTap: () => onBtnTap(value),
              child: Center(
                  child: Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              )))),
    );
  }

  void onBtnTap(String value) {
  if (value == Btn.del) {
    delete();
  } else if (value == Btn.clr) {
    clearAll();
  } else if (value == Btn.per) {
    convertToPercentage();
  } else if (value == Btn.calculate) {
    calculate(); // Call calculate when equals button is pressed
  } else {
    appendValue(value);
  }
  
}




  void calculate() {
  if (number1.isEmpty || operand.isEmpty || number2.isEmpty) return;

  final double num1 = double.parse(number1);
  final double num2 = double.parse(number2);
  double result = 0;

  switch (operand) {
    case Btn.add:
      result = num1 + num2;
      break;
    case Btn.subtract:
      result = num1 - num2;
      break;
    case Btn.multiply:
      result = num1 * num2;
      break;
    case Btn.divide:
      result = num1 / num2;
      break;
  }

  setState(() {
    number1 = result.toString();
    if (number1.endsWith(".0")) {
      number1 = number1.substring(0, number1.length - 2);
    }
    operand = "";
    number2 = "";
  });
}

  void convertToPercentage() {
    if (number1.isNotEmpty && operand.isEmpty && number2.isEmpty) {
      final number = double.parse(number1);
      setState(() {
        number1 = "${(number / 100)}";
      });
    }
  }

  void clearAll() {
    setState(() {
      number1 = "";
      operand = "";
      number2 = "";
    });
  }

  void delete() {
    if (number2.isNotEmpty) {
      setState(() {
        number2 = number2.substring(0, number2.length - 1);
      });
    } else if (operand.isNotEmpty) {
      setState(() {
        operand = "";
      });
    } else if (number1.isNotEmpty) {
      setState(() {
        number1 = number1.substring(0, number1.length - 1);
      });
    }
  }

  void appendValue(String value) {
    if (operand.isEmpty) {
      setState(() {
        number1 += value;
      });
    } else {
      setState(() {
        number2 += value;
      });
    }
  }

  String formatDisplay() {
    if (number1.isEmpty) return "0";
    if (operand.isEmpty) return number1;
    if (number2.isEmpty) return "$number1 $operand";
    return "$number1 $operand $number2";
  }

  Color getBtnColor(String value) {
    return [Btn.del, Btn.clr].contains(value)
        ? Colors.blueGrey
        : [
            Btn.per,
            Btn.multiply,
            Btn.add,
            Btn.subtract,
            Btn.divide,
            Btn.calculate,
          ].contains(value)
            ? Colors.orange
            : Colors.black87;
  }
}
