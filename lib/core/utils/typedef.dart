import 'package:dartz/dartz.dart';
import 'package:tdd_tutorial/core/errors/failure.dart';

typedef ResultFuture<T> = Future<Either<Failure, T>>;

typedef ResultsVoid = ResultFuture<void>;

typedef DataMap = Map<String, dynamic>;
