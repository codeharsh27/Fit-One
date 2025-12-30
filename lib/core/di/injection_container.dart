import 'package:get_it/get_it.dart';
import 'package:tandurast/core/network/api_client.dart';
import 'package:firebase_auth/firebase_auth.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ! Core
  // Network (Custom Backend)
  sl.registerLazySingleton<ApiClient>(() => ApiClient());

  // ! External
  // Firebase Auth
  sl.registerLazySingleton(() => FirebaseAuth.instance);

  // ! Features
  // Register Feature specific repositories and blocs here...
}
