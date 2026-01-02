import 'package:hive/hive.dart';

part 'workout_models.g.dart';

@HiveType(typeId: 0)
class WorkoutSession extends HiveObject {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String duration;

  @HiveField(2)
  final String volume;

  @HiveField(3)
  final List<ExerciseLog> exercises;

  @HiveField(4)
  final DateTime date;

  @HiveField(5, defaultValue: false)
  final bool isInProgress;

  WorkoutSession({
    required this.title,
    required this.duration,
    required this.volume,
    required this.exercises,
    required this.date,
    this.isInProgress = false,
  });
}

@HiveType(typeId: 1)
class ExerciseLog extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final List<SetLog> sets;

  ExerciseLog(this.name, this.sets);
}

@HiveType(typeId: 2)
class SetLog extends HiveObject {
  @HiveField(0)
  final int setNum;

  @HiveField(1)
  final String reps;

  @HiveField(2)
  final String weight;

  @HiveField(3, defaultValue: false)
  final bool isCompleted;

  SetLog(this.setNum, this.reps, this.weight, {this.isCompleted = false});
}
