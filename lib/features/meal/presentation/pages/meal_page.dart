import 'package:flutter/material.dart';

class MealPage extends StatelessWidget {
  const MealPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meals')),
      body: Center(
        child: Text(
          'Meal Plans',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
      ),
    );
  }
}
