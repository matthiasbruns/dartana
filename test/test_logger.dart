import 'package:dartana/dartana.dart';

class TestLogger extends Logger {
  void debug(String msg) {
    print("DEBUG $msg");
  }

  void info(String msg) {
    print("INFO $msg");
  }

  void warn(String msg) {
    print("WARN $msg");
  }

  void error(String msg, Exception throwable) {
    print("$msg $throwable");
  }
}
