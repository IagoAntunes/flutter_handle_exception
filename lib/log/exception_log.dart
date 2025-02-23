enum LogSeverity {
  info,
  warning,
  error,
  fatal
}

class ExceptionLog {
  final Type exceptionType;
  final String message;
  final DateTime timestamp;
  final StackTrace stackTrace;
  final LogSeverity severity;
  final String? category;

  ExceptionLog({
    required this.exceptionType,
    required this.message,
    required this.timestamp,
    required this.stackTrace,
    this.severity = LogSeverity.error,
    this.category,
  });
}
