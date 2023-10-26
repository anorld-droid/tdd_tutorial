import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tdd_tutorial/core/utils/typedef.dart';
import 'package:tdd_tutorial/src/authentication/data/models/user_model.dart';
import 'package:tdd_tutorial/src/authentication/domain/entities/user.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tModel = UserModel.empty();

  test(
    'should be a subclass of [User] entity',
    () {
      //Arrange

      //Assert
      expect(tModel, isA<User>());
    },
  );

  final tJson = fixture('user.json');
  final tMap = jsonDecode(tJson) as DataMap;

  group('fromMap', () {
    test('should return a [UserModel] with the correct data', () {
      //Act
      final results = UserModel.fromMap(tMap);

      expect(results, tModel);
    });
  });

  group('fromJson', () {
    test('should return a [UserModel] with the correct data', () {
      //Act
      final results = UserModel.fromJson(tJson);

      expect(results, tModel);
    });
  });

  group('toMap', () {
    test('should return a [Map] with the correct data', () {
      //Act
      final results = tModel.toMap();

      expect(results, equals(tMap));
    });
  });

  group('toJson', () {
    test('should return a [Json] String with the correct data', () {
      //Act
      final results = tModel.toJson();
      final tJson = jsonEncode({
        "id": "1",
        "avatar": "_empty.avatar",
        "name": "_empty.name",
        "createdAt": "_empty.createdAt"
      });

      expect(results, equals(tJson));
    });
  });

  group('copyWith', () {
    test('should return a [User] model with different data', () {
      //Arrabge

      //Act
      final result = tModel.copyWith(name: 'Patrice');

      // Assert
      expect(result.name, equals('Patrice'));
    });
  });
}
