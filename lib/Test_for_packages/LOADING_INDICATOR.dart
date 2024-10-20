
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class LoadingExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Loading Indicator")),
      body: Center(
        child: SizedBox(
          width: 100,
          height: 100,
          child: LoadingIndicator(
            indicatorType: Indicator.ballPulse, // نوع المؤشر
            colors: [Colors.blue, Colors.red, Colors.green], // ألوان المؤشر
            strokeWidth: 2,
          ),
        ),
      ),
    );
  }
}
