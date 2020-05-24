import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture/core/error/failures_error.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}
