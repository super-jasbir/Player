import 'package:flutter/material.dart';

class HorizontalBarLoader extends StatefulWidget {
  final int durationInSeconds;

  const HorizontalBarLoader({Key? key, required this.durationInSeconds})
      : super(key: key);

  @override
  _HorizontalBarLoaderState createState() => _HorizontalBarLoaderState();
}

class _HorizontalBarLoaderState extends State<HorizontalBarLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.durationInSeconds),
    )..addListener(() {
      // Trigger a rebuild whenever the animation updates
      setState(() {});
    });

    // Start the animation
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Progress Bar
        LinearProgressIndicator(
          value: _controller.value, // Progress from 0 to 1
          minHeight: 10,
          backgroundColor: Colors.grey[300],
          color: Colors.blue,
        ),
        const SizedBox(height: 10),
        // Percentage Text
        Text(
          "${(_controller.value * 100).toInt()}%", // Show percentage
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}
