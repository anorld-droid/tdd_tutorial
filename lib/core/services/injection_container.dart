import 'package:get_it/get_it.dart';
import 'package:tdd_tutorial/src/authentication/data/datasource/auth_remote_data_source.dart';
import 'package:tdd_tutorial/src/authentication/data/repository/auth_repo_impl.dart';
import 'package:tdd_tutorial/src/authentication/domain/repositories/auth_repo.dart';
import 'package:tdd_tutorial/src/authentication/domain/usecases/create_user.dart';
import 'package:tdd_tutorial/src/authentication/domain/usecases/get_users.dart';
import 'package:tdd_tutorial/src/authentication/presentation/cubit/authentication_cubit.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;

Future<void> init() async {
  sl

    //App Logic
    ..registerFactory(
      () => AuthenticationCubit(createUser: sl(), getUsers: sl()),
    )

    // User cases
    ..registerLazySingleton(() => CreateUser(sl()))
    ..registerLazySingleton(() => GetUsers(sl()))

    //Repositories
    ..registerLazySingleton<AuthRepo>(() => AuthRepoImpl(sl()))
    //Data Sources
    ..registerLazySingleton<AuthRemoteDataSource>(
        () => AuthRemoteDataSrcImpl(client: sl()))
    //External dependencies
    ..registerLazySingleton(http.Client.new);
}
