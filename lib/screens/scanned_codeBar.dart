import 'package:flutter/material.dart';

class ScannedCodeBar extends StatelessWidget {
  const ScannedCodeBar({super.key});

  // const ScannedCodeBar({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Screen Product'),
      ),
      body: Center(
        child: Text('Data product here'),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
