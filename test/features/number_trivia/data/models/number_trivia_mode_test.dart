import 'dart:convert';

import 'package:flutter_clean_architecture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_clean_architecture/features/number_trivia/domain/entities/number_trivia_entity.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../core/fixtures/fixture_reader.dart';

void main() {
  final testNumberTriviaModel = NumberTriviaModel(number: 1, text: "Test Text");

  test("should be a subclass of NumberTrivia entity", () async {
    //assert
    expect(testNumberTriviaModel, isA<NumberTrivia>());
  });

  group("fromJson", () {
    test("should return a valid model when the JSON number is an integer",
        () async {
      //arrange
      final Map<String, dynamic> jsonMap =
          json.decode(fixtureReader("trivia_integer.json"));

      // act
      final result = NumberTriviaModel.fromJson(jsonMap);

      // assert
      expect(result, testNumberTriviaModel);
    });

    test("should return a valid model when the JSON number is a double",
        () async {
      //arrange
      final Map<String, dynamic> jsonMap =
          json.decode(fixtureReader("trivia_double.json"));

      // act
      final result = NumberTriviaModel.fromJson(jsonMap);

      // assert
      expect(result, testNumberTriviaModel);
    });
  });
}
