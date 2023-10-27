import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:tdd_tutorial/core/errors/exceptions.dart';
import 'package:tdd_tutorial/core/utils/constants.dart';
import 'package:tdd_tutorial/src/authentication/data/datasource/auth_remote_data_source.dart';
import 'package:tdd_tutorial/src/authentication/data/models/user_model.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  late http.Client client;
  late AuthRemoteDataSource remoteDataSource;

  setUp(() {
    client = MockClient();
    remoteDataSource = AuthRemoteDataSrcImpl(client: client);
    registerFallbackValue(Uri());
  });

  group('createUser', () {
    test('should complete successfully when the status code is 200 0r 201',
        () async {
      //Arrange
      when(
        () => client.post(
          any(),
          body: any(named: 'body'),
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      ).thenAnswer(
          (_) async => http.Response('User created successfully', 201));

      //Act
      final methodCall = remoteDataSource.createUser;

      //Assert
      expect(
        methodCall(
          name: 'name',
          createdAt: 'createdAt',
          avatar: 'avatar',
        ),
        completes,
      );
      verify(
        () => client.post(
          Uri.https(kBaseUrl, kCreateUserEndpoint),
          body: jsonEncode({
            'name': 'name',
            'createdAt': 'createdAt',
            'avatar': 'avatar',
          }),
        ),
      ).called(1);

      verifyNoMoreInteractions(client);
    });
    test('should throw [APIException] when status code is not 200 or 201',
        () async {
      //Arrange
      when(() => client.post(any(), body: any(named: 'body'))).thenAnswer(
        (_) async => http.Response('Invalid email address', 400),
      );

      //Act
      final methodCall = remoteDataSource.createUser;

      //Assert
      expect(
        () => methodCall(
          name: 'name',
          createdAt: 'createdAt',
          avatar: 'avatar',
        ),
        throwsA(
          const APIException(message: 'Invalid email address', statusCode: 400),
        ),
      );

      verify(
        () => client.post(
          Uri.https(kBaseUrl, kCreateUserEndpoint),
          body: jsonEncode({
            'name': 'name',
            'createdAt': 'createdAt',
            'avatar': 'avatar',
          }),
        ),
      ).called(1);

      verifyNoMoreInteractions(client);
    });
  });

  group('getUsers', () {
    final tUsers = [const UserModel.empty()];
    test('should return [List<User>] when the request response is 200',
        () async {
      //Arrange
      when(() => client.get(any())).thenAnswer(
        (_) async => http.Response(jsonEncode([tUsers.first.toMap()]), 200),
      );
      //Act
      final actual = await remoteDataSource.getUsers();

      //Assert
      expect(actual, equals(tUsers));
      verify(
        () => client.get(Uri.https(
          kBaseUrl,
          kGetUsersEndpoint,
        )),
      ).called(1);
      verifyNoMoreInteractions(client);
    });

    test('should throw [APIException] when the request response is not 200',
        () async {
      //Arrange
      when(() => client.get(any())).thenAnswer(
        (_) async => http.Response('Resource not found', 404),
      );
      //Act
      final actual = remoteDataSource.getUsers();

      //Assert
      expect(
        actual,
        throwsA(
            const APIException(message: 'Resource not found', statusCode: 404)),
      );
      verify(
        () => client.get(Uri.https(
          kBaseUrl,
          kGetUsersEndpoint,
        )),
      ).called(1);
      verifyNoMoreInteractions(client);
    });
  });
}
