import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_tutorial/core/errors/exceptions.dart';
import 'package:tdd_tutorial/core/errors/failure.dart';
import 'package:tdd_tutorial/src/authentication/data/datasource/auth_remote_data_source.dart';
import 'package:tdd_tutorial/src/authentication/data/models/user_model.dart';
import 'package:tdd_tutorial/src/authentication/data/repository/auth_repo_impl.dart';
import 'package:tdd_tutorial/src/authentication/domain/entities/user.dart';

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

void main() {
  //Arrange

  late AuthRemoteDataSource remoteDataSource;
  late AuthRepoImpl repoImpl;

  setUp(() {
    remoteDataSource = MockAuthRemoteDataSource();
    repoImpl = AuthRepoImpl(remoteDataSource);
  });

  const tException = APIException(
    message: 'Unknown Error Occurred',
    statusCode: 500,
  );

  group('createUser', () {
    const createdAt = 'whatever.createdAt';
    const avatar = 'whatever.avatar';
    const name = 'whatever.name';

    test(
      'should call the [remoteDataSource.createUser] and complete'
      ' successfully when the call is successful',
      () async {
        //Check that remote source's createUser gets called
        //and with the right data
        //Arrange
        when(
          () => remoteDataSource.createUser(
            name: any(named: 'name'),
            createdAt: any(named: 'createdAt'),
            avatar: any(named: 'avatar'),
          ),
        ).thenAnswer(
          (_) async => Future.value(),
        );

        //Act

        final result = await repoImpl.createUser(
            avatar: avatar, createdAt: createdAt, name: name);
        //Assert
        expect(result, equals(const Right<dynamic, void>(null)));
        verify(
          () => remoteDataSource.createUser(
            name: name,
            createdAt: createdAt,
            avatar: avatar,
          ),
        ).called(1);
        verifyNoMoreInteractions(remoteDataSource);
      },
    );
    test(
      'should return a [Server Failure] when the call to the remoteDataSource '
      'is unsuccessful',
      () async {
        //Arrange
        when(
          () => remoteDataSource.createUser(
            name: any(named: 'name'),
            createdAt: any(named: 'createdAt'),
            avatar: any(named: 'avatar'),
          ),
        ).thenThrow(tException);

        //Act
        final actual = await repoImpl.createUser(
          name: name,
          createdAt: createdAt,
          avatar: avatar,
        );

        //Assert
        expect(
          actual,
          equals(
            Left(
              ApiFailure(
                message: tException.message,
                statusCode: tException.statusCode,
              ),
            ),
          ),
        );
      },
    );
  });

  group('getUsers', () {
    test(
        'should call the [ remoteDataSource.getUsers] and return a [List<Users>]'
        'When the call to remote source is successful', () async {
      //Arrange
      const expectedUsers = [UserModel.empty()];
      when(() => remoteDataSource.getUsers())
          .thenAnswer((_) async => expectedUsers);

      //Act
      final actual = await repoImpl.getUsers();

      //Assert
      expect(actual, isA<Right<dynamic, List<User>>>());
      verify(() => remoteDataSource.getUsers()).called(1);
      verifyNoMoreInteractions(remoteDataSource);
    });

    test(
      'should return a [APIFailure] when the call to the remoteDataSource '
      'is unsuccessful',
      () async {
        //Arrange
        when(
          () => remoteDataSource.getUsers(),
        ).thenThrow(tException);

        //Act
        final actual = await repoImpl.getUsers();

        //Assert
        expect(
          actual,
          equals(
            Left(
              ApiFailure.fromException(tException),
            ),
          ),
        );
        verify(() => remoteDataSource.getUsers()).called(1);
        verifyNoMoreInteractions(remoteDataSource);
      },
    );
  });
}
