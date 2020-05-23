import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture/core/error/failures_error.dart';
import 'package:flutter_clean_architecture/features/number_trivia/domain/entities/number_trivia_entity.dart';
import 'package:flutter_clean_architecture/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:meta/meta.dart';

class GetConcreteNumberTrivia {
  final NumberTriviaRepository numberTriviaRepository;

  GetConcreteNumberTrivia({this.numberTriviaRepository});

  Future<Either<Failure, NumberTrivia>> execute({@required int number}) async {
    return await numberTriviaRepository.getConcreteNumberTrivia(number);
  }
}
