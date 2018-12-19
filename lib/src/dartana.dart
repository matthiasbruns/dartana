library dartana;

class Logger {
  void debug(String msg) {}

  void info(String msg) {}

  void warn(String msg) {}

  void error(String msg, Exception throwable) {}
}

class Dartana {
  static final Dartana _instance = Dartana._internal();

  factory Dartana() {
    return _instance;
  }

  Dartana._internal();

  Logger logger;
}
