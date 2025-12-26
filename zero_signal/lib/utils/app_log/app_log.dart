import 'dart:developer';
import 'dart:convert';
import 'package:flutter/foundation.dart';

enum LogType { info, warning, error }

void appLog(
  dynamic message, {
  String source = 'APP',
  LogType type = LogType.info,
}) {
  if (!kDebugMode) return;

  try {
    final time = DateTime.now().toIso8601String();
    final level = type.name.toUpperCase();
    final formattedMessage = _formatMessage(message);

    final logTable = '''
┌──────────────────────────────────────────────────────────────┐
│ TIME   │ $time
│ LEVEL  │ $level
│ SOURCE │ $source
├──────────────────────────────────────────────────────────────┤
│ MESSAGE
│ $formattedMessage
└──────────────────────────────────────────────────────────────┘
''';

    log(
      logTable,
      name: source,
      level: _logLevel(type),
    );
  } catch (e, s) {
    log('LOG ERROR: $e', stackTrace: s);
  }
}

int _logLevel(LogType type) {
  switch (type) {
    case LogType.info:
      return 800;
    case LogType.warning:
      return 900;
    case LogType.error:
      return 1000;
  }
}

String _formatMessage(dynamic message) {
  if (message is Map || message is List) {
    return const JsonEncoder.withIndent('  ').convert(message);
  }
  return message.toString();
}
