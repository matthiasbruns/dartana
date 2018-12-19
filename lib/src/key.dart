class Key {
  static Key of(Type type, {String name}) {
    if (name != null) {
      return forName(name);
    }
    return forType(type);
  }

  static Key forType<T>(Type type) {
    return TypeKey(type);
  }

  static Key forName<T>(String name) {
    return NameKey(name);
  }
}

class TypeKey<T> extends Key {
  final Type type;

  TypeKey(this.type);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TypeKey &&
          runtimeType == other.runtimeType &&
          type == other.type;

  @override
  int get hashCode => type.hashCode;

  @override
  String toString() {
    return 'TypeKey{type: $type}';
  }
}

class NameKey extends Key {
  final String name;

  NameKey(this.name);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NameKey &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => name.hashCode;

  @override
  String toString() {
    return 'NameKey{name: $name}';
  }
}
