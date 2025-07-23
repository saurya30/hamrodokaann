import 'package:flutter/material.dart';

import '../function/esewa.dart';

class EsewaScreen extends StatelessWidget {
  const EsewaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Esewa Integration'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          Text(
            'Tap below to pay with eSewa',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          ElevatedButton(
              child:const Text('eSewa'),
              onPressed: () {
                Esewa esewa = Esewa();
                esewa.pay();
              },
          ),
        ],
      ),
    );
  }
}
