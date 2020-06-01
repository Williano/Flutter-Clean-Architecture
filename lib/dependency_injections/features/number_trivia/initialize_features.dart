import 'package:flutter_clean_architecture/dependency_injections/core/service_locator_initialization.dart';
import 'package:flutter_clean_architecture/features/number_trivia/data/data_sources/number_trivia_local_data_source.dart';
import 'package:flutter_clean_architecture/features/number_trivia/data/data_sources/number_trivia_remote_data_source.dart';
import 'package:flutter_clean_architecture/features/number_trivia/data/repositories/number_trivia_repository_implementation.dart';
import 'package:flutter_clean_architecture/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:flutter_clean_architecture/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:flutter_clean_architecture/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:flutter_clean_architecture/features/number_trivia/presentation/bloc/bloc/number_trivia_bloc.dart';

void initNumberTriviaFeatures() {
  // Bloc
  serviceLocator.registerFactory(() => NumberTriviaBloc(
      getConcreteNumberTrivia: serviceLocator(),
      getRandomNumberTrivia: serviceLocator(),
      inputConverter: serviceLocator()));

  // Use cases
  serviceLocator.registerLazySingleton(
      () => GetConcreteNumberTrivia(numberTriviaRepository: serviceLocator()));
  serviceLocator.registerLazySingleton(
      () => GetRandomNumberTrivia(randomNumberRepository: serviceLocator()));

  //Repository
  serviceLocator.registerLazySingleton<NumberTriviaRepository>(() =>
      NumberTriviaRepositoryImplementation(
          remoteDataSource: serviceLocator(),
          localDataSource: serviceLocator(),
          networkInfo: serviceLocator()));

  // Data Sources
  serviceLocator.registerLazySingleton<NumberTriviaRemoteDataSource>(() =>
      NumberTriviaRemoteDataSourceImplementation(client: serviceLocator()));

  serviceLocator.registerLazySingleton<NumberTriviaLocalDataSource>(() =>
      NumberTriviaLocalDataSourceImplementation(
          sharedPreferences: serviceLocator()));
}
