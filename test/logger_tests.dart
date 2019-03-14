import "package:dartana/dartana.dart";
import 'package:dartana/src/internal/logger.dart';
import "package:test/test.dart";

class LogEntry {
  final String msg;
  final Exception exception;

  LogEntry(this.msg, this.exception);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LogEntry &&
          runtimeType == other.runtimeType &&
          msg == other.msg &&
          exception == other.exception;

  @override
  int get hashCode => msg.hashCode ^ exception.hashCode;
}

class TestLogger implements Logger {
  var debugEntries = List<LogEntry>();
  var infoEntries = List<LogEntry>();
  var warnEntries = List<LogEntry>();
  var errorEntries = List<LogEntry>();

  @override
  void debug(String msg) {
    debugEntries.add(LogEntry(msg, null));
  }

  @override
  void error(String msg, Exception throwable) {
    errorEntries.add(LogEntry(msg, throwable));
  }

  @override
  void info(String msg) {
    infoEntries.add(LogEntry(msg, null));
  }

  @override
  void warn(String msg) {
    warnEntries.add(LogEntry(msg, null));
  }
}

void main() {
  group("Logger", () {
    test('should log when logger is set', () {
      var logger = TestLogger();
      var exception = Exception("Exception");

      Dartana.logger = logger;
      DartanaLogger.debug(() => "Debug message");
      DartanaLogger.info(() => "Info message");
      DartanaLogger.warn(() => "Warn message");
      DartanaLogger.error(() => MapEntry("Error message", exception));

      expect(
          logger.debugEntries.contains(LogEntry("Debug message", null)), true);
      expect(logger.infoEntries.contains(LogEntry("Info message", null)), true);
      expect(logger.warnEntries.contains(LogEntry("Warn message", null)), true);
      expect(logger.errorEntries.contains(LogEntry("Error message", exception)),
          true);
    });

    test('should log when logger is absent', () {
      var logger = null;

      var debugCalled = false;
      var infoCalled = false;
      var warnCalled = false;
      var errorCalled = false;

      Dartana.logger = logger;
      DartanaLogger.debug(() {
        debugCalled = true;
        return "Debug message";
      });

      DartanaLogger.info(() {
        infoCalled = true;
        return "Info message";
      });

      DartanaLogger.warn(() {
        warnCalled = true;
        return "Warn message";
      });

      DartanaLogger.error(() {
        errorCalled = true;
        return MapEntry("Error message", Exception());
      });

      expect(debugCalled, false);
      expect(infoCalled, false);
      expect(warnCalled, false);
      expect(errorCalled, false);
    });
  });
}
