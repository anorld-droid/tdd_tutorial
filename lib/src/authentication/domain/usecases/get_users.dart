import 'package:tdd_tutorial/core/usecase/usecase.dart';
import 'package:tdd_tutorial/core/utils/typedef.dart';
import 'package:tdd_tutorial/src/authentication/domain/entities/user.dart';
import 'package:tdd_tutorial/src/authentication/domain/repositories/auth_repo.dart';

class GetUsers extends UsecaseWithoutParams<List<User>> {
  const GetUsers(
    this._repo,
  );

  final AuthRepo _repo;
  @override
  ResultFuture<List<User>> call() => _repo.getUsers();
}
