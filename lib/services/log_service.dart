// @dart=2.9
import 'dart:convert';

class LogService {
  void verbose(dynamic message, [dynamic error, StackTrace stackTrace]) {
    _log("[Verbose]", message, error, stackTrace);
  }

  void debug(dynamic message, [dynamic error, StackTrace stackTrace]) {
    _log("[Debug]", message, error, stackTrace);
  }

  void info(dynamic message, [dynamic error, StackTrace stackTrace]) {
    _log("[Info]", message, error, stackTrace);
  }

  void warning(dynamic message, [dynamic error, StackTrace stackTrace]) {
    _log("[Warning]", message, error, stackTrace);
  }

  void error(dynamic message, [dynamic error, StackTrace stackTrace]) {
    _log("[Error]", message, error, stackTrace);
  }

  void wtf(dynamic message, [dynamic error, StackTrace stackTrace]) {
    _log("[WTF]", message, error, stackTrace);
  }

  void logBuild(String currentClassName) {
    _log("[Build]", currentClassName, null, null);
  }

  static final _topBorder =
      "┌ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ";
  static final _middleBorder =
      "├ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ";
  static final _bottomBorder =
      "└ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ";

  void _log(
    String prefix,
    dynamic message,
    dynamic error,
    StackTrace stackTrace,
  ) {
    if (error != null && error is StackTrace)
      throw ArgumentError("Error parameter cannot take a StackTrace!");

    final msgString = (message is Map || message is Iterator)
        ? JsonEncoder.withIndent('  ').convert(message)
        : message.toString();
    final errorString = error?.toString();
    final stackTraceString = stackTrace?.toString();

    // Format the data in a pretty way
    List<String> buffer = [];
    buffer.add(_topBorder);

    // Format the message
    final textSplit = msgString.split('\n');
    buffer.add('│ $prefix ${textSplit[0]}');
    for (var i = 1; i < textSplit.length; i++) buffer.add('│ ${textSplit[i]}');

    // Format the error
    if (errorString != null) {
      buffer.add(_middleBorder);
      for (var line in errorString.split('\n')) buffer.add('│ $line');
    }

    // Format the stack trace
    if (stackTraceString != null) {
      buffer.add(_middleBorder);
      for (var line in stackTraceString.split('\n')) buffer.add('│ $line');
    }

    buffer.add(_bottomBorder);

    // Print the formatted message
    buffer.forEach(print);
  }
}
