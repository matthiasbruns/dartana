import '../dartana.dart';

typedef MessageProvider = String Function();
typedef MessageWithThrowableProvider = MapEntry<String, Exception> Function();

class DartanaLogger {
  static void debug(MessageProvider provider) {
    Dartana.logger?.debug(provider());
  }

  static void info(MessageProvider provider) {
    Dartana.logger?.info(provider());
  }

  static void warn(MessageProvider provider) {
    Dartana.logger?.warn(provider());
  }

  static void error(MessageWithThrowableProvider provider) {
    Dartana.logger?.error(provider().key, provider().value);
  }
}
