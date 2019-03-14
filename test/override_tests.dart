import "package:dartana/dartana.dart";
import 'package:dartana/src/internal/logger.dart';
import "package:test/test.dart";

import 'dartana_matchers.dart';
import 'test_classes.dart';

void main() {
  group("Modules with overrides", () {
    test(
        'should throw exception when dependencies are overridden in same createModule',
        () {
      var fn = () {
        Module.createModule(body: (module) {
          module
            ..bind<MyComponent>(body: (dsl) {
              dsl.factory((_) => MyComponentA());
            })
            ..bind<MyComponent>(body: (dsl) {
              dsl.factory((_) => MyComponentA());
            });
        });
      };

      expect(() => fn(), throwsOverrideException);
    });

    test(
        'should throw exception when dependencies are overridden in same createModule with identical names',
        () {
      var fn = () {
        Module.createModule(body: (module) {
          module
            ..bind<MyComponentA>(
                name: "createComponent",
                body: (dsl) {
                  dsl.factory((_) => MyComponentA());
                })
            ..bind<MyComponentB<String>>(
                name: "createComponent",
                body: (dsl) {
                  dsl.factory((_) => MyComponentB("Hello world"));
                });
        });
      };

      expect(() => fn(), throwsOverrideException);
    });

    test(
        'should throw exception when dependencies are overridden in multiple modules',
        () {
      var module1 = Module.createModule(body: (module) {
        module
          ..bind<MyComponent>(body: (dsl) {
            dsl.factory((_) => MyComponentA());
          });
      });

      var module2 = Module.createModule(body: (module) {
        module
          ..bind<MyComponent>(body: (dsl) {
            dsl.factory((_) => MyComponentA());
          });
      });

      var fn = () {
        Component.fromModules([module1, module2]);
      };

      expect(() => fn(), throwsOverrideException);
    });
  });
}
