import '../dartana.dart';

typedef MessageProvider = String Function();
typedef MessageWithThrowableProvider = MapEntry<String, Exception> Function();

class Logger {
  final Dartana dartana = Dartana();

  void debug(MessageProvider provider) {
    dartana.logger?.debug(provider());
  }

  void info(MessageProvider provider) {
    dartana.logger?.info(provider());
  }

  void warn(MessageProvider provider) {
    dartana.logger?.warn(provider());
  }

  void error(MessageWithThrowableProvider provider) {
    dartana.logger?.error(provider().key, provider().value);
  }
}
