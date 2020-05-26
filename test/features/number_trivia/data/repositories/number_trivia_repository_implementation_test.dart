import 'package:dartz/dartz.dart';
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

    group("device is online", () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

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
    });

    group("device is offline", () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });
    });
  });
}
