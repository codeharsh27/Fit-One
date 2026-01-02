import 'package:tandurast/core/data/sources/remote_exercise_source.dart';
import 'package:tandurast/features/workout/data/exercise_data.dart';
import 'package:tandurast/features/workout/domain/repositories/exercise_repository.dart';

class ExerciseRepositoryImpl implements ExerciseRepository {
  final RemoteExerciseDataSource remoteDataSource;

  ExerciseRepositoryImpl({required this.remoteDataSource});

  @override
  Future<ExerciseDetail?> getExerciseDetail(String name) async {
    return await remoteDataSource.getExerciseDetail(name);
  }
}
