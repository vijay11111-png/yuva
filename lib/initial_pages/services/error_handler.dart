import 'package:flutter/foundation.dart';

class ErrorHandler {
  static void logError(
    String context,
    dynamic error, [
    StackTrace? stackTrace,
  ]) {
    if (kDebugMode) {
      print('=== ERROR LOG ===');
      print('Context: $context');
      print('Error: $error');
      print('Error Type: ${error.runtimeType}');
      if (stackTrace != null) {
        print('Stack Trace: $stackTrace');
      }
      print('================');
    }
  }

  static String getErrorMessage(dynamic error) {
    if (error is TypeError) {
      return 'Type error occurred. Please try again.';
    } else if (error is FormatException) {
      return 'Invalid data format. Please try again.';
    } else if (error.toString().contains('List<Object?>')) {
      return 'Data format error. Please try again.';
    } else if (error.toString().contains('PigeonUserDetails')) {
      return 'User data error. Please try again.';
    } else {
      return 'An unexpected error occurred. Please try again.';
    }
  }

  static bool isTypeCastingError(dynamic error) {
    return error is TypeError ||
        error.toString().contains('List<Object?>') ||
        error.toString().contains('PigeonUserDetails') ||
        error.toString().contains('is not a subtype of type');
  }

  static Future<T> safeAsyncOperation<T>(
    Future<T> Function() operation,
    String context, {
    T? fallbackValue,
    bool logError = true,
  }) async {
    try {
      return await operation();
    } catch (e, stackTrace) {
      if (logError) {
        ErrorHandler.logError(context, e, stackTrace);
      }

      if (fallbackValue != null) {
        return fallbackValue;
      }

      rethrow;
    }
  }

  static T safeSyncOperation<T>(
    T Function() operation,
    String context, {
    T? fallbackValue,
    bool logError = true,
  }) {
    try {
      return operation();
    } catch (e, stackTrace) {
      if (logError) {
        ErrorHandler.logError(context, e, stackTrace);
      }

      if (fallbackValue != null) {
        return fallbackValue;
      }

      rethrow;
    }
  }
}
