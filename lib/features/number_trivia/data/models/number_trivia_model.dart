import 'package:flutter_clean_architecture/features/number_trivia/domain/entities/number_trivia_entity.dart';
import 'package:meta/meta.dart';

class NumberTriviaModel extends NumberTrivia {
  const NumberTriviaModel({
    @required String text,
    @required int number,
  }) : super(number: number, text: text);
}
