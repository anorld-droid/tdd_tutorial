import 'package:dartz/dartz.dart';
import 'package:tdd_tutorial/core/errors/exceptions.dart';
import 'package:tdd_tutorial/core/errors/failure.dart';
import 'package:tdd_tutorial/core/utils/typedef.dart';
import 'package:tdd_tutorial/src/authentication/data/datasource/auth_remote_data_source.dart';
import 'package:tdd_tutorial/src/authentication/domain/entities/user.dart';
import 'package:tdd_tutorial/src/authentication/domain/repositories/auth_repo.dart';

class AuthRepoImpl implements AuthRepo {
  const AuthRepoImpl(this._remoteDataSource);

  final AuthRemoteDataSource _remoteDataSource;

  @override
  ResultsVoid createUser({
    required String name,
    required String createdAt,
    required String avatar,
  }) async {
    //Test Driven Development
    //Call the remote data source ~ ensure it is being called in  your tests
    //Check if the methods returns the proper data
    //   --When a remote data source throws an exception we ruturn a Failure
    //   --else we return the actual expected data
    //
    try {
      await _remoteDataSource.createUser(
          name: name, createdAt: createdAt, avatar: avatar);
      return const Right(null);
    } on APIException catch (e) {
      return Left(ApiFailure.fromException(e));
    }
  }

  @override
  ResultFuture<List<User>> getUsers() async {
    try {
      final results = await _remoteDataSource.getUsers();
      return Right(results);
    } on APIException catch (e) {
      return Left(ApiFailure.fromException(e));
    }
  }
}
