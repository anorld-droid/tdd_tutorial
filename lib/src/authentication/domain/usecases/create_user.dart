import 'package:equatable/equatable.dart';
import 'package:tdd_tutorial/core/usecase/usecase.dart';
import 'package:tdd_tutorial/core/utils/typedef.dart';
import 'package:tdd_tutorial/src/authentication/domain/repositories/auth_repo.dart';

class CreateUser extends UsecaseWithParams<void, CreateUserParams> {
  const CreateUser(this._repository);

  final AuthRepo _repository;

  @override
  ResultsVoid call(params) async => _repository.createUser(
        name: params.name,
        createdAt: params.createdAt,
        avatar: params.avatar,
      );
}

class CreateUserParams extends Equatable {
  final String createdAt;
  final String name;
  final String avatar;

  const CreateUserParams({
    required this.createdAt,
    required this.name,
    required this.avatar,
  });

  const CreateUserParams.empty()
      : this(
          createdAt: '_empty.createdAt',
          name: '_empty.name',
          avatar: '_empty.avatar',
        );

  @override
  List<Object?> get props => [
        createdAt,
        name,
        avatar,
      ];
}
