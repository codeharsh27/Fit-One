import 'package:get_it/get_it.dart';
import 'package:tandurast/core/network/api_client.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tandurast/core/data/sources/remote_exercise_source.dart';
import 'package:tandurast/features/workout/domain/repositories/exercise_repository.dart';
import 'package:tandurast/features/workout/data/repositories/exercise_repository_impl.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ! Core
  // Network (Custom Backend)
  sl.registerLazySingleton<ApiClient>(() => ApiClient());

  // ! External
  // Firebase Auth
  sl.registerLazySingleton(() => FirebaseAuth.instance);

  // ! Data Sources
  sl.registerLazySingleton(() => RemoteExerciseDataSource());

  // ! Repositories
  sl.registerLazySingleton<ExerciseRepository>(
    () => ExerciseRepositoryImpl(remoteDataSource: sl()),
  );

  // ! Features
  // Register Feature specific repositories and blocs here...
}
