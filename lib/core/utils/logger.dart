import 'dart:developer' as developer;

class Logger {
  static const String _tag = '🚀 BookBuddy';

  static void log(String message) {
    developer.log(message, name: _tag);
  }

  static void logError(
    String message, [
    Object? error,
    StackTrace? stackTrace,
  ]) {
    developer.log(message, name: _tag, error: error, stackTrace: stackTrace);
  }

  static void logDebug(String message) {
    developer.log('🔍 $message', name: _tag);
  }

  static void logInfo(String message) {
    developer.log('ℹ️ $message', name: _tag);
  }

  static void logWarning(String message) {
    developer.log('⚠️ $message', name: _tag);
  }
}
