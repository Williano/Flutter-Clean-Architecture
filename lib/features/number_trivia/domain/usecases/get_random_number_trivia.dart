import 'package:flutter_clean_architecture/core/error/failures_error.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture/core/usecases/usecase.dart';
import 'package:flutter_clean_architecture/features/number_trivia/domain/entities/number_trivia_entity.dart';
import 'package:flutter_clean_architecture/features/number_trivia/domain/repositories/number_trivia_repository.dart';

class GetRandomNumberTrivia implements UseCase<NumberTrivia, NoParams> {
  final NumberTriviaRepository randomNumberRepository;

  const GetRandomNumberTrivia({this.randomNumberRepository});

  @override
  Future<Either<Failure, NumberTrivia>> call(NoParams params) async {
    return await randomNumberRepository.getRandomNumberTrivia();
  }
}
