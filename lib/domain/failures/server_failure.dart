import 'package:tasky/domain/failures/failures.dart';

/// Represent that a [Failure] with the server happened.
abstract class ServerFailure extends Failure {
  /// Creates a [ServerFailure] with unexpected error.
  factory ServerFailure.unexpectedError(dynamic message) =>
      _ServerFailureUnexpectedError(message);

  /// Creates a [ServerFailure] with no internet error.
  factory ServerFailure.noInternet() => _ServerFailureNoInternet();

  /// Creates a [ServerFailure] with bad data error.
  factory ServerFailure.badRequest(dynamic data) =>
      _ServerFailureBadRequest(data);

  /// Creates a [ServerFailure] with internal error.
  factory ServerFailure.internalError(dynamic data) =>
      _ServerFailureInternalError(data);

  /// Creates a [ServerFailure] with format error.
  factory ServerFailure.formatError(String message) =>
      _ServerFailureFormatError(message);

  /// Creates a [ServerFailure] with invalid arguments error.
  factory ServerFailure.invalidArgument(String arg, {dynamic received}) =>
      _ServerFailureInvalidArgument(arg, received);

  /// Creates a [ServerFailure] with upload error.
  factory ServerFailure.uploadError() => _ServerFailureUploadError();

  /// Returns [R] after calling the callback from
  /// the correct type.
  R when<R>({
    R unexpectedError(String msg),
    R noInternet(),
    R badRequest(dynamic msg),
    R internalError(dynamic msg),
    R formatError(),
    R invalidArgument(String arg, dynamic received),
    R uploadError(),
  });
}

class _ServerFailureUnexpectedError implements ServerFailure {
  final dynamic message;
  const _ServerFailureUnexpectedError(this.message);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _ServerFailureUnexpectedError && message == other.message;

  @override
  int get hashCode => runtimeType.hashCode ^ message.hashCode;

  @override
  R when<R>({
    R Function(String msg) unexpectedError,
    R Function() noInternet,
    R Function(dynamic msg) badRequest,
    R Function(dynamic msg) internalError,
    R Function() formatError,
    R invalidArgument(String arg, dynamic received),
    R uploadError(),
  }) =>
      unexpectedError?.call(message);

  @override
  String toString() => "ServerFailure: unexpected error: ${message.toString()}";
}

class _ServerFailureNoInternet implements ServerFailure {
  const _ServerFailureNoInternet();

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is _ServerFailureNoInternet;

  @override
  int get hashCode => super.hashCode;

  @override
  R when<R>({
    R Function(String msg) unexpectedError,
    R Function() noInternet,
    R Function(dynamic msg) badRequest,
    R Function(dynamic msg) internalError,
    R Function() formatError,
    R invalidArgument(String arg, dynamic received),
    R uploadError(),
  }) =>
      noInternet?.call();

  @override
  String toString() => "ServerFailure: no internet connection";
}

class _ServerFailureBadRequest implements ServerFailure {
  final dynamic data;

  const _ServerFailureBadRequest(this.data);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _ServerFailureBadRequest && data == other.data;

  @override
  int get hashCode => runtimeType.hashCode ^ data.hashCode;

  @override
  R when<R>({
    R Function(String msg) unexpectedError,
    R Function() noInternet,
    R Function(dynamic msg) badRequest,
    R Function(dynamic msg) internalError,
    R Function() formatError,
    R invalidArgument(String arg, dynamic received),
    R uploadError(),
  }) =>
      badRequest?.call(data);

  @override
  String toString() => "ServerFailure: bad request: ${data.toString()}";
}

class _ServerFailureInternalError implements ServerFailure {
  final dynamic data;

  const _ServerFailureInternalError(this.data);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _ServerFailureInternalError && data == other.data;

  @override
  int get hashCode => runtimeType.hashCode ^ data.hashCode;

  @override
  R when<R>({
    R Function(String msg) unexpectedError,
    R Function() noInternet,
    R Function(dynamic msg) badRequest,
    R Function(dynamic msg) internalError,
    R Function() formatError,
    R invalidArgument(String arg, dynamic received),
    R uploadError(),
  }) =>
      internalError?.call(data);

  @override
  String toString() => "ServerFailure: internal error: ${data.toString()}";
}

class _ServerFailureFormatError implements ServerFailure {
  final String message;
  const _ServerFailureFormatError(this.message);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is _ServerFailureFormatError && message == other.message);

  @override
  int get hashCode => super.hashCode;

  @override
  R when<R>({
    R Function(String msg) unexpectedError,
    R Function() noInternet,
    R Function(dynamic msg) badRequest,
    R Function(dynamic msg) internalError,
    R Function() formatError,
    R invalidArgument(String arg, dynamic received),
    R uploadError(),
  }) =>
      formatError?.call();

  @override
  String toString() => "ServerFailure: format error: $message";
}

class _ServerFailureInvalidArgument implements ServerFailure {
  final String argument;
  final dynamic received;

  _ServerFailureInvalidArgument(this.argument, this.received);

  @override
  R when<R>({
    R Function(String msg) unexpectedError,
    R Function() noInternet,
    R Function(dynamic msg) badRequest,
    R Function(dynamic msg) internalError,
    R Function() formatError,
    R Function(String arg, dynamic received) invalidArgument,
    R uploadError(),
  }) =>
      invalidArgument?.call(argument, received);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is _ServerFailureInvalidArgument &&
          argument == other.argument &&
          received == other.received);

  @override
  int get hashCode => super.hashCode;

  @override
  String toString() =>
      "ServerFailure: invalid argument `$argument`${received != null ? ", received: $received" : ""}";
}

class _ServerFailureUploadError implements ServerFailure {
  @override
  R when<R>({
    R Function(String msg) unexpectedError,
    R Function() noInternet,
    R Function(dynamic msg) badRequest,
    R Function(dynamic msg) internalError,
    R Function() formatError,
    R Function(String arg, dynamic received) invalidArgument,
    R Function() uploadError,
  }) =>
      uploadError?.call();

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is _ServerFailureUploadError);

  @override
  int get hashCode => super.hashCode;

  @override
  String toString() => "ServerFailure: upload error";
}
