import 'dart:async';
import 'package:flutter/material.dart';

import 'log/exception_log.dart';
import 'report_modes/i_report_mode.dart';

class ExceptionHandler {
  static int? _maxLogs;
  static void Function(ExceptionLog)? _onLogCallback;
  static final List<ExceptionLog> _exceptionLogs = [];
  static Map<Type, ContextExceptionHandler> _handlers = {};
  static ContextExceptionHandler? _defaultHandler;
  static final ValueNotifier<BuildContext?> _contextNotifier = ValueNotifier(null);
  static BuildContext? get _currentContext => _contextNotifier.value;
  static List<ExceptionLog> get logs => List.unmodifiable(_exceptionLogs);
  static ReportMode? _reportMode;

  static void initialize({
    Map<Type, ContextExceptionHandler>? handlers,
    ContextExceptionHandler? defaultHandler,
    ReportMode? reportMode,
    void Function(ExceptionLog)? onLogCallback,
    int? maxLogs = 10,
    required Function onRunApp,
  }) {
    _handlers = handlers ?? {};
    _defaultHandler = defaultHandler;
    _reportMode = reportMode;
    _onLogCallback = onLogCallback;
    _maxLogs = maxLogs;
    FlutterError.onError = (FlutterErrorDetails details) {
      _handleError(details.exception, details.stack ?? StackTrace.current);
    };

    runZonedGuarded(() {
      onRunApp();
    }, (error, stackTrace) {
      _handleError(error, stackTrace);
    });
  }

  static void setContext(BuildContext? context) {
    _contextNotifier.value = context;
  }

  static void registerHandler(Type exceptionType, ContextExceptionHandler handler) {
    _handlers[exceptionType] = handler;
  }

  static void reportError(dynamic error, StackTrace stackTrace, {LogSeverity severity = LogSeverity.error, String? category}) {
    _handleError(error, stackTrace, severity: severity, category: category);
  }

  static void _handleError(
    dynamic error,
    StackTrace stackTrace, {
    LogSeverity severity = LogSeverity.error,
    String? category,
  }) {
    final log = ExceptionLog(
      exceptionType: error.runtimeType,
      message: error.toString(),
      timestamp: DateTime.now(),
      stackTrace: stackTrace,
      severity: severity,
      category: category,
    );
    _exceptionLogs.add(log);
    _onLogCallback?.call(log);
    if (_maxLogs != null && _exceptionLogs.length > _maxLogs!) {
      _exceptionLogs.removeRange(0, _exceptionLogs.length - _maxLogs!);
    }
    if (_currentContext != null) {
      final exceptionType = error.runtimeType;
      final handler = _handlers[exceptionType];
      if (handler != null) {
        handler(_currentContext!, error, stackTrace);
      } else if (_defaultHandler != null) {
        _defaultHandler!(_currentContext!, error, stackTrace);
      }
      if (_reportMode != null) {
        _reportMode!.report(_currentContext!, error, stackTrace);
      }
    } else {}
  }

  static void clearLogs() {
    _exceptionLogs.clear();
  }
}

typedef ContextExceptionHandler = void Function(
  BuildContext context,
  dynamic error,
  StackTrace stackTrace,
);
