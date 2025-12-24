import 'dart:developer';
import 'package:flutter/foundation.dart';

void errorLog(
  dynamic error, {
  String source = 'APP',
  StackTrace? stackTrace,
}) {
  if (!kDebugMode) return;

  try {
    final time = DateTime.now().toIso8601String();

    final errorTable = '''
╔══════════════════════════════════════════════════════════════╗
║ 🚨 ERROR LOG
╠══════════════════════════════════════════════════════════════╣
║ TIME   │ $time
║ SOURCE │ $source
╠══════════════════════════════════════════════════════════════╣
║ MESSAGE
║ ${error.toString()}
╠══════════════════════════════════════════════════════════════╣
║ STACK TRACE
║ ${stackTrace ?? 'Not available'}
╚══════════════════════════════════════════════════════════════╝
''';

    log(
      errorTable,
      name: source,
      level: 1000, // Error level
      stackTrace: stackTrace,
    );
  } catch (_) {
    // fail silently
  }
}
