import 'dart:convert';

import 'package:tdd_tutorial/core/errors/exceptions.dart';
import 'package:tdd_tutorial/core/utils/constants.dart';
import 'package:tdd_tutorial/core/utils/typedef.dart';
import 'package:tdd_tutorial/src/authentication/data/models/user_model.dart';
import 'package:http/http.dart' as http;

abstract class AuthRemoteDataSource {
  Future<void> createUser({
    required String name,
    required String createdAt,
    required String avatar,
  });

  Future<List<UserModel>> getUsers();
}

const kCreateUserEndpoint = '/test-api/users';
const kGetUsersEndpoint = '/test-api/users';

class AuthRemoteDataSrcImpl extends AuthRemoteDataSource {
  final http.Client _client;

  AuthRemoteDataSrcImpl({required http.Client client}) : _client = client;
  @override
  Future<void> createUser({
    required String name,
    required String createdAt,
    required String avatar,
  }) async {
    //1. Check to make sure it returns the right data to the caller
    //2. Check to make sure it throws a custom exception with the right message on exception
    try {
      final response = await _client.post(
        Uri.https(kBaseUrl, kCreateUserEndpoint),
        body: jsonEncode(
          {
            'name': name,
            'createdAt': createdAt,
            'avatar': avatar,
          },
        ),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw APIException(
            message: response.body, statusCode: response.statusCode);
      }
    } on APIException {
      rethrow;
    } catch (e) {
      throw APIException(message: e.toString(), statusCode: 505);
    }
  }

  @override
  Future<List<UserModel>> getUsers() async {
    try {
      final response =
          await _client.get(Uri.https(kBaseUrl, kGetUsersEndpoint));
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw APIException(
            message: response.body, statusCode: response.statusCode);
      }
      return List<DataMap>.from(jsonDecode(response.body) as List)
          .map((userData) => UserModel.fromMap(userData))
          .toList();
    } on APIException {
      rethrow;
    } catch (e) {
      throw APIException(message: e.toString(), statusCode: 505);
    }
  }
}
