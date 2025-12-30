import 'package:flutter/material.dart';

class WorkoutPage extends StatelessWidget {
  const WorkoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Workouts')),
      body: Center(
        child: Text(
          'Workout Plans',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
      ),
    );
  }
}
