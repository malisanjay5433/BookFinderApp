import '../errors/failures.dart';

sealed class Result<T> {
  const Result();
}

class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

class ResultFailure<T> extends Result<T> {
  final Failure failure;
  const ResultFailure(this.failure);
}

extension ResultExtension<T> on Result<T> {
  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is ResultFailure<T>;

  T? get data {
    if (this is Success<T>) {
      return (this as Success<T>).data;
    }
    return null;
  }

  Failure? get error {
    if (this is ResultFailure<T>) {
      return (this as ResultFailure<T>).failure;
    }
    return null;
  }

  R when<R>({
    required R Function(T data) success,
    required R Function(Failure failure) failure,
  }) {
    if (this is Success<T>) {
      return success((this as Success<T>).data);
    } else if (this is ResultFailure<T>) {
      return failure((this as ResultFailure<T>).failure);
    }
    throw Exception('Invalid Result state');
  }
}
