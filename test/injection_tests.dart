import "package:dartana/dartana.dart";
import "package:test/test.dart";

import "dartana_matchers.dart";
import 'test_classes.dart';
import 'test_logger.dart';

void main() {
  Dartana().logger = TestLogger();

  group("Injection", () {
    Module module1;
    Module module2;
    Module module3;
    Component component1;
    Component component2;

    setUp(() {
      module1 = Module.createModule(
          name: "module1",
          body: (module) {
            module
              ..bind<String>(body: (dsl) {
                dsl.factory((factory) => "Hello world");
              });
          });

      component1 = Component.createComponent(modules: [module1]);

      module2 = Module.createModule(
          name: "module2",
          body: (module) {
            module
              ..bind<MyComponent>(body: (dsl) {
                dsl.singleton((singleton) => MyComponentA());
              });
          });

      module3 = Module.createModule(
          name: "module3",
          body: (module) {
            module
              ..bind<MyComponentB<String>>(
                  name: "myComponent2",
                  body: (dsl) {
                    dsl.factory(
                        (factory) => MyComponentB(component1.injectNow()));
                  })
              ..bind<MyComponentB<String>>(body: (dsl) {
                dsl.factory((factory) => factory.get(name: "myComponent2"));
              });
          });

      component2 = Component.createComponent(modules: [module2, module3]);
    });

    test("should inject non-conflicting dependencies", () {
      String string = component1.inject();
      MyComponent myComponent = component2.inject();
      MyComponent myComponent2 = component2.inject(name: "myComponent2");
      MyComponentB<String> myComponent3 = component2.inject();

      expect(string, "Hello world");
      expect(myComponent, TypeMatcher<MyComponentA>());
      expect(myComponent2, TypeMatcher<MyComponentB>());
      expect(myComponent3.value, "Hello world");
    });

    test("should create singletons just once", () {
      MyComponent myComponent = component2.inject();
      MyComponent myComponent2 = component2.inject();

      expect(myComponent, TypeMatcher<MyComponentA>());
      expect(identical(myComponent2, myComponent), true);
    });

    test("should provide injection possibility via canInject()", () {
      expect(component1.canInject<String>(), true);
      expect(component2.canInject<MyComponent>(), true);
      expect(component2.canInject<MyComponent>(name: "myComponent2"), true);

      expect(component2.canInject<String>(), false);
      expect(component2.canInject<MyComponent>(name: "myComponent3"), false);
    });

    test("should provide dependencies across createModule boundaries", () {
      var module4 = Module.createModule(body: (module) {
        module
          ..bind<MyComponentA>(body: (dsl) {
            dsl.factory((factory) => MyComponentA());
          });
      });

      var module5 = Module.createModule(body: (module) {
        module
          ..bind<MyComponentB<MyComponentA>>(body: (dsl) {
            dsl.factory((factory) => MyComponentB(factory.get()));
          });
      });

      var component3 = Component.createComponent(modules: [module4, module5]);
      MyComponentB<MyComponentA> myComponent = component3.inject();

      expect(myComponent.value, TypeMatcher<MyComponentA>());
    });

    test("should throw exception when dependency was not declared", () {
      var module = Module.createModule(body: (module) {
        module
          ..bind<int>(body: (dsl) {
            dsl.factory((factory) => 1337);
          });
      });
      var component3 = Component.fromModule(module);

      expect(() => component3.inject<MyComponent>(), throwsInjectionException);
    });

    test("eager singletons should be initialized when component is created",
        () {
      var timesSingletonCreated = 0;

      var module = Module.createModule(body: (module) {
        module
          ..bind<String>(body: (dsl) {
            dsl.factory((factory) => "Hello world");
          })
          ..bind<MyComponentB<String>>(body: (dsl) {
            dsl.eagerSingleton((eager) {
              timesSingletonCreated++;
              return MyComponentB<String>(eager.get<String>());
            });
          });
      });

      var component = Component.fromModule(module);
      expect(timesSingletonCreated, 1);

      MyComponentB<String> myComponent = component.inject();
      expect(myComponent.value, "Hello world");

      expect(timesSingletonCreated, 1);
    });

//    TODO will cause the test to crash :(
//    test("circular dependencies should fail", () {
//      var module = Module.createModule(body: (module) {
//        module
//          ..bind<A>(body: (dsl) {
//            dsl.singleton((singleton) => A(singleton.get()));
//          })
//          ..bind<B>(body: (dsl) {
//            dsl.singleton((singleton) => B(singleton.get()));
//          });
//      });
//
//      var component = Component.fromModule(module);
//
//      expect(component.injectNow<A>(), throwsStackOverflowError);
//    });


  });
}
