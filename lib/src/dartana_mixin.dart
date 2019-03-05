import 'component.dart';
import 'exceptions.dart';

typedef WithComponent<R> = R Function(Component);

mixin DartanaMixin {
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
          "Component is null! Make sure that you have assigned your component to the DartanaMixin.");
    } else {
      return body(component);
    }
  }
}
