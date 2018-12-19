import 'declaration.dart';

class DartanaException implements Exception {
  String cause;
  Exception exception;

  DartanaException(this.cause, this.exception);
}

class ComponentException implements Exception {
  String cause;

  ComponentException(this.cause);
}

class ComponentNotInitializedException extends ComponentException {
  ComponentNotInitializedException(message) : super(message);
}

class InjectionException extends DartanaException {
  InjectionException(message) : super(message, null);
}

class OverrideException extends DartanaException {
  OverrideException(message) : super(message, null);

  OverrideException.fromDeclarations(
      Declaration declaration, Declaration existing)
      : this("$override would override $existing");
}

class InstanceCreationException extends DartanaException {
  InstanceCreationException(message, cause) : super(message, cause);
}
