import 'package:flutter_clean_architecture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_clean_architecture/features/number_trivia/domain/entities/number_trivia_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final testNumberTriviaModel = NumberTriviaModel(number: 1, text: "Test Text");

  test("should be a subclass of NumberTrivia entity", () async {
    //assert
    expect(testNumberTriviaModel, isA<NumberTrivia>());
  });
}
