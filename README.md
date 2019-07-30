[![Build Status](https://travis-ci.com/matthiasbruns/dartana.svg?branch=develop)](https://travis-ci.com/matthiasbruns/dartana)

Runtime dependency injection for Dart and Flutter developers.

## Usage

A simple usage example:

```dart
import 'package:dartana/dartana.dart';

class Foo {
  final String foo = "foo";
}

class Bar {
  final String bar = "bar";
}

var someModule = Module.createModule((module) {
  module
    ..bind<Foo>((dsl) {
      dsl.singleton((_) => Foo());
    })
    ..bind<Bar>((dsl) {
      dsl.factory((_) => Bar());
    });
}, name: "someModule");

main() {
  // Create component from module
  var component = Component.createComponent(modules: [someModule]);

  // Inject dependencies
  var myFoo = component.inject<Foo>();
  var myFoo2 = component.inject<Foo>();
  var myBar = component.inject<Bar>();
  var myBar2 = component.inject<Bar>();

  // Use dependencies
  print("${myFoo.foo} ${myFoo2.foo} same instance: ${myFoo == myFoo2}");
  print("${myBar.bar} ${myBar2.bar} same instance: ${myBar == myBar2}");
}

```

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: [https://github.com/matthiasbruns/dartana/issues]