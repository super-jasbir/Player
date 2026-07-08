import 'package:flutter/material.dart';
import 'dart:math';


class MouseChasingDollar extends StatelessWidget {
  const MouseChasingDollar({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: MouseChase(),
      ),
    );
  }
}

class MouseChase extends StatefulWidget {
  @override
  _MouseChaseState createState() => _MouseChaseState();
}

class _MouseChaseState extends State<MouseChase> {
  final Random _random = Random();
  double _mouseX = 50, _mouseY = 50;
  double _dollarX = 200, _dollarY = 200;

  void _moveDollar() {
    setState(() {
      _dollarX = _random.nextDouble() * MediaQuery.of(context).size.width - 100;
      _dollarY = _random.nextDouble() * MediaQuery.of(context).size.height - 100;

      // Update mouse to chase the dollar
      _mouseX = _dollarX - 50;
      _mouseY = _dollarY - 50;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _moveDollar,
      child: Stack(
        children: [
          // Mouse Animation
          AnimatedPositioned(
            duration: const Duration(seconds: 1),
            curve: Curves.easeInOut,
            left: _mouseX,
            top: _mouseY,
            child: Image.asset(
              'assets/images/mouse.png', // Add your mouse image here
              width: 50,
              height: 50,
            ),
          ),
          // Dollar Animation
          AnimatedPositioned(
            duration: const Duration(seconds: 1),
            curve: Curves.easeInOut,
            left: _dollarX,
            top: _dollarY,
            child: Image.asset(
              'assets/images/apple_icon.png', // Add your dollar image here
              width: 50,
              height: 50,
            ),
          ),
        ],
      ),
    );
  }
}
