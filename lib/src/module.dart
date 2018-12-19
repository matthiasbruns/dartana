import 'package:meta/meta.dart';

import 'aliases.dart';
import 'component.dart';
import 'declaration.dart';
import 'exceptions.dart';
import 'key.dart';

class Module {
  final String name;
  final Map<Key, Declaration> _declarations;

  Map<Key, Declaration> get declarations {
    return _declarations;
  }

  Module({this.name}) : _declarations = Map();

  static Module createModule({String name, @required Function(Module) body}) {
    final module = Module(name: name);
    body(module);
    return module;
  }

  Module bind<T>({String name, @required Module Function(BindingDsl<T>) body}) {
    var dsl = BindingDsl<T>(module: this, type: T, name: name);
    return body(dsl);
  }
}

class BindingDsl<T> {
  final String name;
  final Module module;
  final Type type;

  BindingDsl({@required this.module, this.type, this.name});

  Module _declaration(InjectionType injectionType, Provider<T> provider) {
    var key = Key.of(this.type, name: this.name);
    var declaration = Declaration(
        key: key,
        injectionType: injectionType,
        moduleName: module.name,
        type: type,
        name: name,
        provider: provider);

    var existingDeclaration = module._declarations[key];
    if (existingDeclaration != null) {
      throw OverrideException.fromDeclarations(
          declaration, existingDeclaration);
    }

    module._declarations[key] = declaration;
    return module;
  }

  Module factory(T Function(ProviderDsl) body) {
    return _declaration(
        InjectionType.FACTORY, (component) => body(ProviderDsl(component)));
  }

  Module singleton(T Function(ProviderDsl) body) {
    return _declaration(
        InjectionType.SINGLETON, (component) => body(ProviderDsl(component)));
  }

  Module eagerSingleton(T Function(ProviderDsl) body) {
    return _declaration(InjectionType.EAGER_SINGLETON,
        (component) => body(ProviderDsl(component)));
  }
}

class ProviderDsl {
  final ComponentContext context;

  ProviderDsl(this.context);

  T get<T>({String name}) {
    return context.injectNow<T>(name: name);
  }

//  T lazy<T>({String name}) {
//
//  }
}
