import 'dart:convert';

import 'package:tdd_tutorial/core/utils/typedef.dart';
import 'package:tdd_tutorial/src/authentication/domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.createdAt,
    required super.id,
    required super.name,
    required super.avatar,
  });

  const UserModel.empty()
      : this(
          id: '1',
          createdAt: '_empty.createdAt',
          name: '_empty.name',
          avatar: '_empty.avatar',
        );

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(jsonDecode(source) as DataMap);
  UserModel.fromMap(DataMap map)
      : this(
          avatar: map['avatar'] as String,
          id: map['id'] as String,
          createdAt: map['createdAt'] as String,
          name: map['name'] as String,
        );

  DataMap toMap() => {
        'id': id,
        'avatar': avatar,
        'name': name,
        'createdAt': createdAt,
      };

  String toJson() => jsonEncode(toMap());

  UserModel copyWith({
    String? id,
    String? avatar,
    String? name,
    String? createdAt,
  }) =>
      UserModel(
        id: id ?? this.id,
        avatar: avatar ?? this.avatar,
        name: name ?? this.name,
        createdAt: createdAt ?? this.createdAt,
      );
}
