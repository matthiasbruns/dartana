import 'component.dart';
import 'exceptions.dart';

typedef WithComponent<R> = R Function(Component);

class DartanaTrait {
  Component component;

  T inject<T>({String name}) {
    return withComponent((component) => component.inject<T>(name: name));
  }

  T injectNow<T>({String name}) {
    return withComponent((component) => component.injectNow<T>(name: name));
  }

  T canInject<T>({String name}) {
    return withComponent((component) => component.canInject<T>(name: name));
  }

  R withComponent<R>(WithComponent body) {
    if (component == null) {
      throw ComponentNotInitializedException(
          "component is null! Make sure to use KatanaTrait's extension functions *after* component property was initialized.");
    } else {
      return body(component);
    }
  }
}
