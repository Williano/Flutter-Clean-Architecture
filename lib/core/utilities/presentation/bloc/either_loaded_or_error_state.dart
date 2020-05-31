import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture/core/error/error_messages.dart';
import 'package:flutter_clean_architecture/core/error/failures_error.dart';
import 'package:flutter_clean_architecture/features/number_trivia/domain/entities/number_trivia_entity.dart';
import 'package:flutter_clean_architecture/features/number_trivia/presentation/bloc/bloc/number_trivia_bloc.dart';

Stream<NumberTriviaState> eitherLoadedOrErrorState(
    Either<Failure, NumberTrivia> failureOrTrivia) async* {
  yield failureOrTrivia.fold(
      (failure) => Error(message: mapFailureToMessage(failure)),
      (trivia) => Loaded(trivia: trivia));
}
