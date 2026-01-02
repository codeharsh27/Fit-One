import 'package:tandurast/features/workout/data/exercise_data.dart';

abstract class ExerciseRepository {
  Future<ExerciseDetail?> getExerciseDetail(String name);
}
