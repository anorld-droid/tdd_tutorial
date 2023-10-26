import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_tutorial/src/authentication/domain/entities/user.dart';
import 'package:tdd_tutorial/src/authentication/domain/repositories/auth_repo.dart';
import 'package:tdd_tutorial/src/authentication/domain/usecases/get_users.dart';

import 'auth_repo.mock.dart';

void main() {
  late GetUsers usercase;
  late AuthRepo repo;

  // Do this before every function test is run
  setUp(() {
    repo = MockAuthRepo();
    usercase = GetUsers(repo);
  });

  const tResponse = [User.empty()];

  test(
    'should call [AuthRepo.getUsers] and return List<User>',
    () async {
      //Arrange
      when(() => repo.getUsers()).thenAnswer(
        (_) async => const Right(tResponse),
      );

      final result = await usercase();

      expect(result, equals(const Right<dynamic, List<User>>(tResponse)));
      verify(() => repo.getUsers()).called(1);
      verifyNoMoreInteractions(repo);
    },
  );
}
