import 'declaration.dart';
import 'exceptions.dart';
import 'extensions.dart';
import 'internal/logger.dart';
import 'key.dart';
import 'module.dart';

class Component {
  final Map<Key, Declaration> _declarations;
  final Map<Key, Object> _instances = Map();
  ComponentContext _context;

  set context(Iterable<Component> dependsOn) {
    _context = ComponentContext(this, dependsOn);
  }

  Component(Map<Key, Declaration> declarations, Iterable<Component> dependsOn)
      : _declarations = declarations {
    context = dependsOn;

    // Initialize eager singletons
    declarations.values
        .where((entry) => entry.injectionType == InjectionType.EAGER_SINGLETON)
        .forEach((declaration) =>
            _instances[declaration.key] = declaration.provider(_context));
  }

  static Component fromModules(Iterable<Module> modules) =>
      Component.createComponent(modules: modules);

  static Component fromComponent(Iterable<Component> components) =>
      Component.createComponent(dependsOn: components);

  static Component createComponent(
      {Iterable<Module> modules, Iterable<Component> dependsOn}) {
    if (modules == null) {
      modules = Iterable.empty();
    }
    if (dependsOn == null) {
      dependsOn = Iterable.empty();
    }

    var moduleDeclarations = IterableExtensions.fold(
        modules.map((module) => module.declarations), each: (declaration) {
      Logger().info(() => "Registering declaration $declaration");
    });

    var componentDeclaration =
        dependsOn.map((component) => component._declarations);

    var allDeclarations = IterableExtensions.fold(
        List.from(componentDeclaration)..add(moduleDeclarations));

    if (allDeclarations.isEmpty) {
      throw ComponentException(
          "No declarations found (did you forget to pass modules and/or parent components?)");
    }

    return Component(moduleDeclarations, dependsOn);
  }

  T _thisComponentInjectByKey<T>(Key key) {
    var instance;

    final declaration = _declarations[key];
    if (declaration == null) {
      throw InjectionException("No binding found for ${key.toString()}");
    } else {
      try {
        Logger().info(() => "Injecting dependency for ${key.toString()}");

        switch (declaration.injectionType) {
          case InjectionType.FACTORY:
            instance = declaration.provider(_context);
            Logger().debug(() => "Created instance for ${key.toString()}");
            break;
          case InjectionType.SINGLETON:
            instance = _instances[key];
            if (instance != null) {
              Logger().debug(() =>
                  "Returning existing singleton instance for ${key.toString()}");
            } else {
              Logger().debug(
                  () => "Created singleton instance for ${key.toString()}");
              instance = _instances[key] = declaration.provider(_context);
            }
            break;
          case InjectionType.EAGER_SINGLETON:
            instance = _instances[key];
            if (instance == null) {
              throw DartanaException(
                  "Eager singleton was not properly initialized", null);
            }
            break;
        }
      } catch (e) {
        if (e is DartanaException) {
          throw e;
        }
        if (e is Exception) {
          throw InstanceCreationException(
              "Could not instantiate $declaration", e);
        }
      }

      return instance;
    }
  }

  bool _thisComponentCanInject(Key key) {
    return _declarations.containsKey(key);
  }

  bool _canInject(Key key) {
    return _context._canInject(key);
  }

  T _injectByKey<T>(Key key) {
    return _context.injectByKey(key);
  }

  T inject<T>({String name}) {
    return _context.inject<T>(name: name);
  }

  T injectNow<T>({String name}) {
    return _context.injectNow<T>(name: name);
  }

  bool canInject<T>({String name}) {
    return _context.canInject<T>(name: name);
  }
}

class ComponentContext {
  final Component thisComponent;
  final Iterable<Component> dependsOn;

  ComponentContext(this.thisComponent, this.dependsOn);

  static ComponentContext of(
      Component thisComponent, Iterable<Component> dependsOn) {
    return ComponentContext(thisComponent, dependsOn);
  }

  T injectByKey<T>(Key key) {
    T result;

    if (thisComponent._thisComponentCanInject(key)) {
      result = thisComponent._thisComponentInjectByKey(key);
    } else if (dependsOn != null && dependsOn.isNotEmpty) {
      result = dependsOn
          .firstWhere((component) => component._canInject(key),
              orElse: () => null)
          ?._injectByKey<T>(key);
    }

    if (result == null) {
      throw InjectionException("No binding found for ${key.toString()}");
    }

    return result;
  }

  bool _canInject(Key key) {
    if (thisComponent._thisComponentCanInject(key)) {
      return true;
    } else if (dependsOn != null && dependsOn.isNotEmpty) {
      return dependsOn.firstWhere((component) => component._canInject(key),
              orElse: () => null) !=
          null;
    } else {
      return false;
    }
  }

  T inject<T>({String name}) {
    return injectNow<T>(name: name);
  }

  T injectNow<T>({String name}) {
    return injectByKey<T>(Key.of(T, name: name));
  }

  bool canInject<T>({String name}) {
    return _canInject(Key.of(T, name: name));
  }
}
