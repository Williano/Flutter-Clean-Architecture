import 'dart:convert';

import 'package:matcher/matcher.dart';
import 'package:flutter_clean_architecture/core/error/exception.dart';
import 'package:flutter_clean_architecture/features/number_trivia/data/data_sources/number_trivia_local_data_source.dart';
import 'package:flutter_clean_architecture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  NumberTriviaLocalDataSourceImplementation localDataSourceImplmentation;
  MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    localDataSourceImplmentation = NumberTriviaLocalDataSourceImplementation(
        sharedPreferences: mockSharedPreferences);
  });

  group("getLastNumberTrivia", () {
    final testNumberTriviaModel = NumberTriviaModel.fromJson(
        json.decode(fixtureReader("trivia_cached.json")));
    test(
        "should return NumberTrivia from sharedPreferences when there is one in the cache",
        () async {
      //arrange
      when(mockSharedPreferences.getString(any))
          .thenReturn(fixtureReader("trivia_cached.json"));
      //act
      final result = await localDataSourceImplmentation.getLastNumberTrivia();

      //assert
      verify(mockSharedPreferences.getString(CACHED_NUMBER_TRIVIA));
      expect(result, equals(testNumberTriviaModel));
    });

    test("should throw a CacheException when there is not a cached value",
        () async {
      //arrange
      when(mockSharedPreferences.getString(any)).thenReturn(null);
      //act
      final call = localDataSourceImplmentation.getLastNumberTrivia;

      //assert
      expect(() => call(), throwsA(isA<CacheException>()));
    });
  });
}
