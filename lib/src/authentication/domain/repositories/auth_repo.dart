import 'package:flutter/foundation.dart' show immutable;
import 'package:tdd_tutorial/core/utils/typedef.dart';
import 'package:tdd_tutorial/src/authentication/domain/entities/user.dart';

@immutable
abstract class AuthRepo {
  const AuthRepo();

  ResultsVoid createUser({
    required String name,
    required String createdAt,
    required String avatar,
  });

  ResultFuture<List<User>> getUsers();
}
