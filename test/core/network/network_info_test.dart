import 'package:flutter_clean_architecture/core/network/network_info.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:data_connection_checker/data_connection_checker.dart';

class MockDataConnectionChecker extends Mock implements DataConnectionChecker {}

void main() {
  NetworkInfoImpl networkInfo;
  MockDataConnectionChecker mockDataConnectionChecker;

  setUp(() {
    mockDataConnectionChecker = MockDataConnectionChecker();
    networkInfo = NetworkInfoImpl(connectionChecker: mockDataConnectionChecker);
  });

  group("isConnected", () {
    test("should forward the call to DataConnectionChecker.hasConnection",
        () async {
      // // arrange
      // when(mockDataConnectionChecker.hasConnection)
      //     .thenAnswer((_) async => true);

      // // act
      // final result = await networkInfo.isConnected;

      // //assert
      // verify(mockDataConnectionChecker.hasConnection);
      // expect(result, true);

      // arrange
      final testHasConnectionFuture = Future.value(true);

      when(mockDataConnectionChecker.hasConnection)
          .thenAnswer((_) => testHasConnectionFuture);

      // act
      final result = networkInfo.isConnected;

      //assert
      verify(mockDataConnectionChecker.hasConnection);
      expect(result, testHasConnectionFuture);
    });
  });
}
