import 'package:equatable/equatable.dart';

/// Class representing a general failure.
/// A failure is not an error nor an exception.
abstract class Failure extends Equatable {
  @override
  List<Object> get props => [];
}

/// Represent that a [Failure] with the server happened.
class ServerFailure extends Failure {}

class InvalidUserFailure extends Failure {}
