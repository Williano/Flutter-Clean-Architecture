import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture/core/error/error_messages.dart';
import 'package:flutter_clean_architecture/core/error/failures_error.dart';
import 'package:flutter_clean_architecture/core/usecases/usecase.dart';
import 'package:flutter_clean_architecture/core/utilities/presentation/bloc/input_converter.dart';
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

    void setUpMockInputConverterSuccess() =>
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Right(testNumberParsed));

    test(
        "should call the Input converter to validate and convert the string to an unsigned interger",
        () async {
      // arrange
      setUpMockInputConverterSuccess();

      // act
      numberTriviaBloc
          .add((GetTriviaForConcreteNumber(numberString: testNumberString)));
      await untilCalled(mockInputConverter.stringToUnsignedInteger(any));

      // assert
      verify(mockInputConverter.stringToUnsignedInteger(testNumberString));
    });

    test("should emit [Error] when the input is invalid", () async {
      // arrange
      setUpMockInputConverterSuccess();

      final expected = [Empty(), Error(message: INVALID_INPUT_FAILURE_MESSAGE)];

      // assert later
      expectLater(numberTriviaBloc.state, emitsInOrder(expected));

      // act
      numberTriviaBloc
          .add((GetTriviaForConcreteNumber(numberString: testNumberString)));
    });

    test("should get data from the concrete use case", () async {
      // arrange
      setUpMockInputConverterSuccess();

      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => Right(testNumberTrivia));

      // act
      numberTriviaBloc
          .add((GetTriviaForConcreteNumber(numberString: testNumberString)));

      await untilCalled(mockGetConcreteNumberTrivia(any));

      // assert
      verify(mockGetConcreteNumberTrivia(Params(number: testNumberParsed)));
    });

    test("should emit [Loading, Loaded] when data is gotten successfully",
        () async {
      // arrange
      setUpMockInputConverterSuccess();
      // assert later
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => Right(testNumberTrivia));

      final expected = [Empty(), Loading(), Loaded(trivia: testNumberTrivia)];
      expectLater(numberTriviaBloc.state, emitsInOrder(expected));

      // act
      numberTriviaBloc
          .add(GetTriviaForConcreteNumber(numberString: testNumberString));
    });

    test("should emit [Loading, Error] when getting data fails", () async {
      // arrange
      setUpMockInputConverterSuccess();
      // assert later
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => Left(ServerFailure([])));

      final expected = [
        Empty(),
        Loading(),
        Error(message: SERVER_FAILURE_MESSAGE)
      ];
      expectLater(numberTriviaBloc.state, emitsInOrder(expected));

      // act
      numberTriviaBloc
          .add(GetTriviaForConcreteNumber(numberString: testNumberString));
    });

    test(
        "should emit [Loading, Error] with a proper message for the error when getting data fails",
        () async {
      // arrange
      setUpMockInputConverterSuccess();
      // assert later
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => Left(CacheFailure([])));

      final expected = [
        Empty(),
        Loading(),
        Error(message: CACHE_FAILURE_MESSAGE)
      ];
      expectLater(numberTriviaBloc.state, emitsInOrder(expected));

      // act
      numberTriviaBloc
          .add(GetTriviaForConcreteNumber(numberString: testNumberString));
    });
  });

  /// Get Random number

  group("GetTriviaForConcreteNumber", () {
    final testNumberTrivia = NumberTrivia(text: "test trivia", number: 1);

    void setUpMockInputConverterSuccess() =>
        //when(mockInputConverter.stringToUnsignedInteger(any)).thenReturn();

        test("should get data from the random use case", () async {
          // arrange
          setUpMockInputConverterSuccess();

          when((mockGetRadomNumberTrivia(any)))
              .thenAnswer((_) async => Right(testNumberTrivia));

          // act
          numberTriviaBloc.add((GetTriviaForRandomNumber()));

          await untilCalled(mockGetRadomNumberTrivia(any));

          // assert
          verify(mockGetRadomNumberTrivia(NoParams()));
        });

    test("should emit [Loading, Loaded] when data is gotten successfully",
        () async {
      // arrange
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => Right(testNumberTrivia));

      final expected = [Empty(), Loading(), Loaded(trivia: testNumberTrivia)];
      expectLater(numberTriviaBloc.state, emitsInOrder(expected));

      // act
      numberTriviaBloc.add(GetTriviaForRandomNumber());
    });

    test("should emit [Loading, Error] when getting data fails", () async {
      // arrange

      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => Left(ServerFailure([])));

      final expected = [
        Empty(),
        Loading(),
        Error(message: SERVER_FAILURE_MESSAGE)
      ];
      expectLater(numberTriviaBloc.state, emitsInOrder(expected));

      // act
      numberTriviaBloc.add(GetTriviaForRandomNumber());
    });

    test(
        "should emit [Loading, Error] with a proper message for the error when getting data fails",
        () async {
      // arrange
      setUpMockInputConverterSuccess();
      // assert later
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => Left(CacheFailure([])));

      final expected = [
        Empty(),
        Loading(),
        Error(message: CACHE_FAILURE_MESSAGE)
      ];
      expectLater(numberTriviaBloc.state, emitsInOrder(expected));

      // act
      numberTriviaBloc.add(GetTriviaForRandomNumber());
    });
  });
}
