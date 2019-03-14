import "package:dartana/dartana.dart";
import "package:test/test.dart";

import "dartana_matchers.dart";
import 'test_classes.dart';
import 'test_logger.dart';

void main() {
  Dartana.logger = TestLogger();
  
  group("Injection with multiple components", () {
    test("should inject dependencies", () {
      var module1 = Module.createModule(body: (module) {
        module
          ..bind<String>(body: (dsl) {
            dsl
              ..factory((factory) {
                return "Hello world";
              });
          })
          ..bind<String>(
              name: "another",
              body: (dsl) {
                dsl
                  ..factory((factory) {
                    return "Hello world 2";
                  });
              });
      });

      var component1 = Component.createComponent(modules: [module1]);
      expect(component1.inject<String>(), "Hello world");
      expect(component1.inject("another"), "Hello world 2");
      expect(() => component1.inject<int>(), throwsInjectionException);

      var module2 = Module.createModule(body: (module) {
        module
          ..bind<int>(body: (dsl) {
            dsl..factory((factory) => 1337);
          });
      });

      var component2 = Component.createComponent(modules: [module2]);
      expect(component2.inject<int>(), 1337);
      expect(() => component2.inject<String>(), throwsInjectionException);

      var module3 = Module.createModule(body: (module) {
        module
          ..bind<MyComponentC<String, String>>(body: (dsl) {
            dsl..factory((factory) => MyComponentC("a", "b"));
          })
          ..bind<MyComponentC<String, int>>(body: (dsl) {
            dsl
              ..factory(
                  (factory) => MyComponentC(factory.get(), factory.get()));
          });
      });

      var component3 = Component.createComponent(
          modules: [module3], dependsOn: [component1, component2]);

      expect(component3.canInject<MyComponentC<String, String>>(), true);
      expect(component3.canInject<MyComponentC<String, int>>(), true);
      expect(component3.canInject<int>(), true);
      expect(component3.canInject<String>(), true);
      expect(component3.canInject<String>("another"), true);
      expect(component3.canInject<MyComponent>(), false);

      expect(component3.inject<String>(), "Hello world");
      expect(component3.inject<int>(), 1337);
      expect(component3.inject<MyComponentC<String, String>>(),
          equals(MyComponentC("a", "b")));

      var myComponent = component3.inject<MyComponentC<String, int>>();
      expect(myComponent.value, "Hello world");
      expect(myComponent.value2, 1337);
    });

    test("should inject dependencies over multiple component tiers", () {
      var module1 = Module.createModule(body: (module) {
        module
          ..bind<String>(body: (dsl) {
            dsl..factory((factory) => "Hello world");
          });
      });

      var component1 = Component.createComponent(modules: [module1]);
      var component2 = Component.createComponent(dependsOn: [component1]);
      var module3 = Module.createModule(body: (module) {
        module
          ..bind<int>(body: (dsl) {
            dsl..factory((factory) => 1337);
          });
      });
      var component3 = Component.createComponent(
          modules: [module3], dependsOn: [component2]);

      expect(component3.canInject<String>(), true);
      expect(component3.canInject<int>(), true);
      expect(component3.inject<String>(), "Hello world");
      expect(component3.inject<int>(), 1337);
    });

    test("should throw override exception for overrides in components", () {
      var module1 = Module.createModule(body: (module) {
        module
          ..bind<MyComponent>(body: (dsl) {
            dsl..factory((factory) => MyComponentA());
          });
      });

      var module2 = Module.createModule(body: (module) {
        module
          ..bind<MyComponent>(body: (dsl) {
            dsl..factory((factory) => MyComponentA());
          });
      });

      var module3 = Module.createModule(body: (module) {
        module
          ..bind<String>(body: (dsl) {
            dsl..factory((factory) => "Hello world");
          });
      });

      var component1 = Component.createComponent(modules: [module1]);
      var component2 = Component.createComponent(modules: [module2]);

      var fn = () =>
          Component.createComponent(
              modules: [module3], dependsOn: [component1, component2]);

      expect(() => fn(), throwsOverrideException);
    });
  });
}
