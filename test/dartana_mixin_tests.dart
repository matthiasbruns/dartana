import "package:dartana/dartana.dart";
import "package:test/test.dart";

import 'dartana_matchers.dart';
import 'test_classes.dart';

class DelegateBeforeInitialization with DartanaMixin {
  MyComponent myComponent;

  DelegateBeforeInitialization() {
    myComponent = inject<MyComponent>();

    var module = Module.createModule((module) {
      module.bind<MyComponent>((dsl) {
        dsl.singleton((_) => MyComponentA());
      });
    });
    component = Component.fromModules([module]);
  }
}

void main() {
  group("DartanaMixin", () {
    test('should throw meaningful exception when component was not initialized',
        () {
      expect(DelegateBeforeInitialization(),
          throwsComponentNotInitializedException);
    });
  });
}
