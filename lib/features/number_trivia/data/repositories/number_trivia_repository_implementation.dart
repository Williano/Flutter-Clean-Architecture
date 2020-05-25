import 'package:flutter_clean_architecture/features/number_trivia/domain/entities/number_trivia_entity.dart';
import 'package:flutter_clean_architecture/core/error/failures_error.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture/features/number_trivia/domain/repositories/number_trivia_repository.dart';

class NumberTriviaRepositoryImplementation implements NumberTriviaRepository {
  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(int number) {}

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() {}
}
