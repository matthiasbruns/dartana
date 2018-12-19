import 'package:meta/meta.dart';

import 'aliases.dart';
import 'key.dart';

class Declaration<T> {
  final Key key;
  final InjectionType injectionType;
  final String moduleName;
  final Type type;
  final String name;
  final Provider<T> provider;

  Declaration(
      {@required this.key,
      @required this.injectionType,
      @required this.provider,
      this.type,
      this.moduleName,
      this.name});

  @override
  String toString() {
    var buffer = StringBuffer();
    buffer.write("$type");
    buffer.write("(");
    buffer.write("type=$injectionType");
    if (name != null) {
      buffer.write(" name=$name");
    }
    if (moduleName != null) {
      buffer.write(" module=$moduleName");
    }
    buffer.write(")");

    return buffer.toString();
  }
}

enum InjectionType { FACTORY, SINGLETON, EAGER_SINGLETON }
