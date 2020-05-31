import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture/core/error/failures_error.dart';

class InputConverter {
  Either<Failure, int> stringToUnsignedInteger(String str) {
    try {
      final integer = int.parse(str);
      if (integer < 0) throw FormatException();
      return Right(integer);
    } on FormatException {
      return Left(InvalidInputFailure([]));
    }
  }
}

class InvalidInputFailure extends Failure {
  InvalidInputFailure(List properties) : super(properties);
}
