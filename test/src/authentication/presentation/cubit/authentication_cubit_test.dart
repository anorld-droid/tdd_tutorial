import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_tutorial/core/errors/failure.dart';
import 'package:tdd_tutorial/src/authentication/data/models/user_model.dart';
import 'package:tdd_tutorial/src/authentication/domain/usecases/create_user.dart';
import 'package:tdd_tutorial/src/authentication/domain/usecases/get_users.dart';
import 'package:tdd_tutorial/src/authentication/presentation/cubit/authentication_cubit.dart';

class MockCreateUser extends Mock implements CreateUser {}

class MockGetUsers extends Mock implements GetUsers {}

void main() {
  late CreateUser createUser;
  late GetUsers getUsers;
  late AuthenticationCubit cubit;

  const tCreateUserParams = CreateUserParams.empty();
  const tAPIFailure = ApiFailure(message: 'message', statusCode: 400);

  setUp(() {
    createUser = MockCreateUser();
    getUsers = MockGetUsers();
    cubit = AuthenticationCubit(createUser: createUser, getUsers: getUsers);
    registerFallbackValue(tCreateUserParams);
  });

  //Close the cubit after each test
  tearDown(() => cubit.close());

  test('initial State should be AuthenticationInitial', () async {
    //Arrange
    //Act
    //Assert
    expect(cubit.state, const AuthenticationInitial());
  });

  group('createUser', () {
    blocTest<AuthenticationCubit, AuthenticationState>(
      'should emit CreatingUser and UserCreated when successful',
      build: () {
        when(() => createUser(any()))
            .thenAnswer((invocation) async => const Right(null));
        return cubit;
      },
      act: (cubit) => cubit.createUser(
        createdAt: tCreateUserParams.createdAt,
        name: tCreateUserParams.name,
        avatar: tCreateUserParams.avatar,
      ),
      expect: () => const [CreatingUser(), UserCreated()],
      verify: (_) {
        verify(() => createUser(tCreateUserParams)).called(1);
        verifyNoMoreInteractions(createUser);
      },
    );

    blocTest<AuthenticationCubit, AuthenticationState>(
      'should emit CreatingUser and AuthenticationError when unsuccessful',
      build: () {
        when(() => createUser(any()))
            .thenAnswer((_) async => const Left(tAPIFailure));
        return cubit;
      },
      act: (cubit) => cubit.createUser(
        createdAt: tCreateUserParams.createdAt,
        name: tCreateUserParams.name,
        avatar: tCreateUserParams.avatar,
      ),
      expect: () =>
          [const CreatingUser(), AuthenticationError(tAPIFailure.errorMessage)],
      verify: (_) {
        verify(() => createUser(tCreateUserParams)).called(1);
        verifyNoMoreInteractions(createUser);
      },
    );
  });

  const tUsers = [UserModel.empty()];
  group('getUsers', () {
    blocTest<AuthenticationCubit, AuthenticationState>(
      'should emit [GettingUsers, UsersLoaded] when successful',
      build: () {
        when(() => getUsers()).thenAnswer((_) async => const Right(tUsers));
        return cubit;
      },
      act: (cubit) => cubit.getUsers(),
      expect: () => const [GettingUsers(), UsersLoaded(tUsers)],
      verify: (_) {
        verify(() => getUsers()).called(1);
        verifyNoMoreInteractions(getUsers);
      },
    );
    blocTest<AuthenticationCubit, AuthenticationState>(
      'should emit [GettingUsers, AuthenticationError] when unsuccessful',
      build: () {
        when(() => getUsers()).thenAnswer((_) async => const Left(tAPIFailure));
        return cubit;
      },
      act: (cubit) => cubit.getUsers(),
      expect: () =>
          [const GettingUsers(), AuthenticationError(tAPIFailure.errorMessage)],
      verify: (_) {
        verify(() => getUsers()).called(1);
        verifyNoMoreInteractions(getUsers);
      },
    );
  });
}
