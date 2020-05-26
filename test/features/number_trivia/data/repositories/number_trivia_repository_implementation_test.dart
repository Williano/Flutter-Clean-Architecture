import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture/core/error/exception.dart';
import 'package:flutter_clean_architecture/core/error/failures_error.dart';
import 'package:flutter_clean_architecture/core/platform/network_info.dart';
import 'package:flutter_clean_architecture/features/number_trivia/data/data_sources/number_trivia_local_data_source.dart';
import 'package:flutter_clean_architecture/features/number_trivia/data/data_sources/number_trivia_remote_data_source.dart';
import 'package:flutter_clean_architecture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_clean_architecture/features/number_trivia/data/repositories/number_trivia_repository_implementation.dart';
import 'package:flutter_clean_architecture/features/number_trivia/domain/entities/number_trivia_entity.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockRemoteDataSource extends Mock
    implements NumberTriviaRemoteDataSource {}

class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  NumberTriviaRepositoryImplementation repositoryImplementation;
  MockRemoteDataSource mockRemoteDataSource;
  MockLocalDataSource mockLocalDataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repositoryImplementation = NumberTriviaRepositoryImplementation(
        remoteDataSource: mockRemoteDataSource,
        localDataSource: mockLocalDataSource,
        networkInfo: mockNetworkInfo);
  });

  void runTestsOnline(Function body) {
    group("device is online", () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      body();
    });
  }

  void runTestsOffline(Function body) {
    group("device is offline", () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      body();
    });
  }

  group("getConcreteNumberTrivia", () {
    final testNumber = 1;
    final testNumberTriviaModel =
        NumberTriviaModel(text: "Test Trivia", number: testNumber);
    final NumberTrivia testNumberTrivia = testNumberTriviaModel;
    test("should check if the device is online", () async {
      //arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

      //act
      repositoryImplementation.getConcreteNumberTrivia(testNumber);

      //assert
      verify(mockNetworkInfo.isConnected);
    });

    runTestsOnline(() {
      test(
          "should return remote data when the call to remote data source is successful",
          () async {
        //arrange
        when(mockRemoteDataSource.getConcreteNumberTrivia(any))
            .thenAnswer((_) async => testNumberTriviaModel);
        //act
        final result =
            await repositoryImplementation.getConcreteNumberTrivia(testNumber);

        //assert
        verify(mockRemoteDataSource.getConcreteNumberTrivia(testNumber));
        expect(result, equals(Right(testNumberTrivia)));
      });

      test(
          "should cache the data locally when the call to remote data source is successful",
          () async {
        //arrange
        when(mockRemoteDataSource.getConcreteNumberTrivia(any))
            .thenAnswer((_) async => testNumberTriviaModel);
        //act
        await repositoryImplementation.getConcreteNumberTrivia(testNumber);

        //assert
        verify(mockRemoteDataSource.getConcreteNumberTrivia(testNumber));
        verify(mockLocalDataSource.cacheNumberTrivia(testNumberTriviaModel));
      });

      test(
          "should return server failure when the call to remote data source is unsuccessful",
          () async {
        //arrange
        when(mockRemoteDataSource.getConcreteNumberTrivia(any))
            .thenThrow(ServerException());
        //act
        final result =
            await repositoryImplementation.getConcreteNumberTrivia(testNumber);

        //assert
        verify(mockRemoteDataSource.getConcreteNumberTrivia(testNumber));
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(Left(ServerFailure([]))));
      });
    });

    runTestsOffline(() {
      test("should return last locally data when the cached data is present",
          () async {
        // arrarnge
        when(mockLocalDataSource.getLastNumberTrivia())
            .thenAnswer((_) async => testNumberTriviaModel);

        // act
        final result =
            await repositoryImplementation.getConcreteNumberTrivia(testNumber);

        // assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastNumberTrivia());
        expect(result, equals(Right(testNumberTrivia)));
      });

      test("should return CacheFailure when there is no cached data present",
          () async {
        // arrarnge
        when(mockLocalDataSource.getLastNumberTrivia())
            .thenThrow(CacheException());

        // act
        final result =
            await repositoryImplementation.getConcreteNumberTrivia(testNumber);

        // assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastNumberTrivia());
        expect(result, equals(Left(CacheFailure([]))));
      });
    });
  });

  group("getConcreteNumberTrivia", () {
    final testNumber = 1;
    final testNumberTriviaModel =
        NumberTriviaModel(text: "Test Trivia", number: testNumber);
    final NumberTrivia testNumberTrivia = testNumberTriviaModel;
    test("should check if the device is online", () async {
      //arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

      //act
      repositoryImplementation.getConcreteNumberTrivia(testNumber);

      //assert
      verify(mockNetworkInfo.isConnected);
    });

    runTestsOnline(() {
      test(
          "should return remote data when the call to remote data source is successful",
          () async {
        //arrange
        when(mockRemoteDataSource.getConcreteNumberTrivia(any))
            .thenAnswer((_) async => testNumberTriviaModel);
        //act
        final result =
            await repositoryImplementation.getConcreteNumberTrivia(testNumber);

        //assert
        verify(mockRemoteDataSource.getConcreteNumberTrivia(testNumber));
        expect(result, equals(Right(testNumberTrivia)));
      });

      test(
          "should cache the data locally when the call to remote data source is successful",
          () async {
        //arrange
        when(mockRemoteDataSource.getConcreteNumberTrivia(any))
            .thenAnswer((_) async => testNumberTriviaModel);
        //act
        await repositoryImplementation.getConcreteNumberTrivia(testNumber);

        //assert
        verify(mockRemoteDataSource.getConcreteNumberTrivia(testNumber));
        verify(mockLocalDataSource.cacheNumberTrivia(testNumberTriviaModel));
      });

      test(
          "should return server failure when the call to remote data source is unsuccessful",
          () async {
        //arrange
        when(mockRemoteDataSource.getConcreteNumberTrivia(any))
            .thenThrow(ServerException());
        //act
        final result =
            await repositoryImplementation.getConcreteNumberTrivia(testNumber);

        //assert
        verify(mockRemoteDataSource.getConcreteNumberTrivia(testNumber));
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(Left(ServerFailure([]))));
      });
    });

    runTestsOffline(() {
      test("should return last locally data when the cached data is present",
          () async {
        // arrarnge
        when(mockLocalDataSource.getLastNumberTrivia())
            .thenAnswer((_) async => testNumberTriviaModel);

        // act
        final result =
            await repositoryImplementation.getConcreteNumberTrivia(testNumber);

        // assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastNumberTrivia());
        expect(result, equals(Right(testNumberTrivia)));
      });

      test("should return CacheFailure when there is no cached data present",
          () async {
        // arrarnge
        when(mockLocalDataSource.getLastNumberTrivia())
            .thenThrow(CacheException());

        // act
        final result =
            await repositoryImplementation.getConcreteNumberTrivia(testNumber);

        // assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastNumberTrivia());
        expect(result, equals(Left(CacheFailure([]))));
      });
    });
  });

  /// Get [RandomNumberTrivia] test

  group("getRandomNumberTrivia", () {
    final testNumberTriviaModel =
        NumberTriviaModel(text: "Test Trivia", number: 123);
    final NumberTrivia testNumberTrivia = testNumberTriviaModel;
    test("should check if the device is online", () async {
      //arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

      //act
      repositoryImplementation.getRandomNumberTrivia();

      //assert
      verify(mockNetworkInfo.isConnected);
    });

    runTestsOnline(() {
      test(
          "should return remote data when the call to remote data source is successful",
          () async {
        //arrange
        when(mockRemoteDataSource.getRandomNumberTrivia())
            .thenAnswer((_) async => testNumberTriviaModel);
        //act
        final result = await repositoryImplementation.getRandomNumberTrivia();

        //assert
        verify(mockRemoteDataSource.getRandomNumberTrivia());
        expect(result, equals(Right(testNumberTrivia)));
      });

      test(
          "should cache the data locally when the call to remote data source is successful",
          () async {
        //arrange
        when(mockRemoteDataSource.getRandomNumberTrivia())
            .thenAnswer((_) async => testNumberTriviaModel);
        //act
        await repositoryImplementation.getRandomNumberTrivia();

        //assert
        verify(mockRemoteDataSource.getRandomNumberTrivia());
        verify(mockLocalDataSource.cacheNumberTrivia(testNumberTriviaModel));
      });

      test(
          "should return server failure when the call to remote data source is unsuccessful",
          () async {
        //arrange
        when(mockRemoteDataSource.getRandomNumberTrivia())
            .thenThrow(ServerException());
        //act
        final result = await repositoryImplementation.getRandomNumberTrivia();

        //assert
        verify(mockRemoteDataSource.getRandomNumberTrivia());
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(Left(ServerFailure([]))));
      });
    });

    runTestsOffline(() {
      test("should return last locally data when the cached data is present",
          () async {
        // arrarnge
        when(mockLocalDataSource.getLastNumberTrivia())
            .thenAnswer((_) async => testNumberTriviaModel);

        // act
        final result = await repositoryImplementation.getRandomNumberTrivia();

        // assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastNumberTrivia());
        expect(result, equals(Right(testNumberTrivia)));
      });

      test("should return CacheFailure when there is no cached data present",
          () async {
        // arrarnge
        when(mockLocalDataSource.getLastNumberTrivia())
            .thenThrow(CacheException());

        // act
        final result = await repositoryImplementation.getRandomNumberTrivia();

        // assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastNumberTrivia());
        expect(result, equals(Left(CacheFailure([]))));
      });
    });
  });
}
