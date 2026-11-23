import 'package:flutter/material.dart';

class Screen2 extends StatelessWidget {
  const Screen2({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.alarm, size: 80),
          Text('Alarm', style: TextStyle(fontSize: 28)),
        ],
      ),
    );
  }
}