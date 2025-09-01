abstract class Failure {
  final String message;
  const Failure({required this.message});

  @override
  String toString() => message;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Failure &&
          runtimeType == other.runtimeType &&
          message == other.message;

  @override
  int get hashCode => message.hashCode;
}

class ServerFailure extends Failure {
  final int? statusCode;
  
  const ServerFailure({
    required String message,
    this.statusCode,
  }) : super(message: message);

  @override
  String toString() => 'ServerFailure: $message${statusCode != null ? ' (Status: $statusCode)' : ''}';
}

class NetworkFailure extends Failure {
  const NetworkFailure({required String message}) : super(message: message);
  
  @override
  String toString() => 'NetworkFailure: $message';
}

class CacheFailure extends Failure {
  const CacheFailure({required String message}) : super(message: message);
  
  @override
  String toString() => 'CacheFailure: $message';
}

class ValidationFailure extends Failure {
  const ValidationFailure({required String message}) : super(message: message);
  
  @override
  String toString() => 'ValidationFailure: $message';
}

class UnknownFailure extends Failure {
  const UnknownFailure({required String message}) : super(message: message);
  
  @override
  String toString() => 'UnknownFailure: $message';
}