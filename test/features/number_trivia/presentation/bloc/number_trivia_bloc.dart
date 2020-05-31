import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture/core/utilities/presentation/input_converter.dart';
import 'package:flutter_clean_architecture/features/number_trivia/domain/entities/number_trivia_entity.dart';
import 'package:flutter_clean_architecture/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:flutter_clean_architecture/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:flutter_clean_architecture/features/number_trivia/presentation/bloc/bloc/number_trivia_bloc.dart';
import "package:mockito/mockito.dart";
import 'package:flutter_test/flutter_test.dart';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRadomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  NumberTriviaBloc numberTriviaBloc;
  MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  MockGetRadomNumberTrivia mockGetRadomNumberTrivia;
  MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRadomNumberTrivia = MockGetRadomNumberTrivia();
    mockInputConverter = MockInputConverter();
    numberTriviaBloc = NumberTriviaBloc(
        getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
        getRandomNumberTrivia: mockGetRadomNumberTrivia,
        inputConverter: mockInputConverter);
  });

  test("initial state should be Empty", () {
    // assert
    expect(numberTriviaBloc.initialState, equals(Empty()));
  });

  group("GetTriviaForConcreteNumber", () {
    final testNumberString = "1";
    final testNumberParsed = 1;
    final testNumberTrivia = NumberTrivia(text: "test trivia", number: 1);

    test(
        "should call the Input converter to validate and convert the string to an unsigned interger",
        () async {
      // arrange
      when(mockInputConverter.stringToUnsignedInteger(any))
          .thenReturn(Right(testNumberParsed));

      // act
      numberTriviaBloc
          .add((GetTriviaForConcreteNumber(numberString: testNumberString)));
      await untilCalled(mockInputConverter.stringToUnsignedInteger(any));

      // assert
      verify(mockInputConverter.stringToUnsignedInteger(testNumberString));
    });

    test("should emit [Error] when the input is invalid", () async {
      // arrange
      when(mockInputConverter.stringToUnsignedInteger(any))
          .thenReturn(Left(InvalidInputFailure([])));

      final expected = [Empty(), Error(message: INVALID_INPUT_FAILURE_MESSAGE)];

      // assert later
      expectLater(numberTriviaBloc.state, emitsInOrder(expected));

      // act
      numberTriviaBloc
          .add((GetTriviaForConcreteNumber(numberString: testNumberString)));
    });
  });
}
