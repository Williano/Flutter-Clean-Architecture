import 'dart:convert';

import 'package:flutter_clean_architecture/features/number_trivia/data/data_sources/number_trivia_remote_data_source.dart';
import 'package:matcher/matcher.dart';
import 'package:flutter_clean_architecture/core/error/exception.dart';
import 'package:flutter_clean_architecture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

import '../../../../core/fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  NumberTriviaRemoteDataSourceImplementation remoteDataSourceImplementation;
  MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    remoteDataSourceImplementation =
        NumberTriviaRemoteDataSourceImplementation(client: mockHttpClient);
  });

  void setUpMockHttpClientSuccess200() {
    when(mockHttpClient.get(any, headers: anyNamed("headers"))).thenAnswer(
        (_) async => http.Response(fixtureReader("trivia_integer.json"), 200));
  }

  void setUpMockHttpClientError404() {
    when(mockHttpClient.get(any, headers: anyNamed("headers")))
        .thenAnswer((_) async => http.Response("Something went wrong", 404));
  }

  group("getConcreteNumberTrivia", () {
    final testNumber = 1;
    final testNumberTriviaModel = NumberTriviaModel.fromJson(
        json.decode(fixtureReader("trivia_integer.json")));

    test(
        "should perform a GET request with application/json header on a URL with number being the endpoint",
        () async {
      // arrange
      setUpMockHttpClientSuccess200();
      // act
      remoteDataSourceImplementation.getConcreteNumberTrivia(testNumber);
      // assert
      verify(mockHttpClient.get("http://numbersapi.com/$testNumber",
          headers: {"Content-Type": "application/json"}));
    });

    test("should return NumberTrivia when the response code is 200 (success)",
        () async {
      // arrange
      setUpMockHttpClientSuccess200();
      // act
      final result = await remoteDataSourceImplementation
          .getConcreteNumberTrivia(testNumber);

      // assert
      expect(result, equals(testNumberTriviaModel));
    });

    test(
        "should throw a ServerException when the response code is 404 or other",
        () async {
      // arrange
      setUpMockHttpClientError404();
      // act
      final call = remoteDataSourceImplementation.getConcreteNumberTrivia;

      // assert
      expect(() => call(testNumber), throwsA(isA<ServerException>()));
    });
  });

  /// Test for get random number trivia
  ///
  group("getRandomNumberTrivia", () {
    final testNumberTriviaModel = NumberTriviaModel.fromJson(
        json.decode(fixtureReader("trivia_integer.json")));

    test(
        "should perform a GET request with application/json header on a URL with number being the endpoint",
        () async {
      // arrange
      setUpMockHttpClientSuccess200();
      // act
      remoteDataSourceImplementation.getRandomNumberTrivia();
      // assert
      verify(mockHttpClient.get("http://numbersapi.com/random",
          headers: {"Content-Type": "application/json"}));
    });

    test("should return NumberTrivia when the response code is 200 (success)",
        () async {
      // arrange
      setUpMockHttpClientSuccess200();
      // act
      final result =
          await remoteDataSourceImplementation.getRandomNumberTrivia();

      // assert
      expect(result, equals(testNumberTriviaModel));
    });

    test(
        "should throw a ServerException when the response code is 404 or other",
        () async {
      // arrange
      setUpMockHttpClientError404();
      // act
      final call = remoteDataSourceImplementation.getRandomNumberTrivia;

      // assert
      expect(() => call(), throwsA(isA<ServerException>()));
    });
  });
}
