import 'package:flutter_test/flutter_test.dart';
import 'package:bookfinderapp/core/utils/result.dart';
import 'package:bookfinderapp/core/errors/failures.dart';

void main() {
  group('Result', () {
    test('Success should contain data and be successful', () {
      // Arrange
      const data = 'test data';

      // Act
      final result = Success(data);

      // Assert
      expect(result.data, equals(data));
      expect(result.isSuccess, isTrue);
      expect(result.isFailure, isFalse);
    });

    test('ResultFailure should contain failure and not be successful', () {
      // Arrange
      final failure = ServerFailure(message: 'Server error');

      // Act
      final result = ResultFailure(failure);

      // Assert
      expect(result.failure, equals(failure));
      expect(result.isSuccess, isFalse);
      expect(result.isFailure, isTrue);
    });

    test('when should call success callback for Success', () {
      // Arrange
      const data = 'test data';
      final result = Success(data);
      String? successResult;

      // Act
      result.when(
        success: (data) => successResult = data,
        failure: (failure) => {},
      );

      // Assert
      expect(successResult, equals(data));
    });

    test('when should call failure callback for ResultFailure', () {
      // Arrange
      final failure = NetworkFailure(message: 'Network error');
      final result = ResultFailure(failure);
      String? failureResult;

      // Act
      result.when(
        success: (data) => {},
        failure: (failure) => failureResult = failure.toString(),
      );

      // Assert
      expect(failureResult, equals('NetworkFailure: Network error'));
    });
  });
}
