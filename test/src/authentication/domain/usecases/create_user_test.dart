//What does the class depend on?
//- Answer AuthRepo
// How can we create a fake version of the class - Mock?
//- Answer MockTail
//How do we control what our dependencies do?
//- Answer Using the Mocktail's API

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_tutorial/src/authentication/domain/repositories/auth_repo.dart';
import 'package:tdd_tutorial/src/authentication/domain/usecases/create_user.dart';

class MockAuthRepo extends Mock implements AuthRepo {}

void main() {
  late CreateUser usercase;
  late AuthRepo repo;

  // Do this before every function test is run
  setUp(() {
    repo = MockAuthRepo();
    usercase = CreateUser(repo);
  });

  const params = CreateUserParams.empty();
  test(
    'should call [AuthRepo.createUser]',
    () async {
      //Arrange
      //STUB
      when(() => repo.createUser(
            createdAt: any(named: 'createdAt'),
            name: any(named: 'name'),
            avatar: any(named: 'avatar'),
          )).thenAnswer((_) async => const Right(null));

      //Act
      final result = await usercase(params);

      //Assert
      expect(result, equals(const Right<dynamic, void>(null)));
      verify(
        () => repo.createUser(
          createdAt: params.createdAt,
          name: params.name,
          avatar: params.avatar,
        ),
      ).called(1);

      verifyNoMoreInteractions(repo);
    },
  );
}
