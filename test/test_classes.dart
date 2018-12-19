class MyComponent {
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MyComponent && runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;
}

class MyComponentA extends MyComponent {
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MyComponentA && runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;
}

class MyComponentB<T> extends MyComponent {
  final T value;

  MyComponentB(this.value);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MyComponentB &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;
}

class MyComponentC<A, B> extends MyComponent {
  final A value;
  final B value2;

  MyComponentC(this.value, this.value2);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MyComponentC &&
          runtimeType == other.runtimeType &&
          value == other.value &&
          value2 == other.value2;

  @override
  int get hashCode => value.hashCode ^ value2.hashCode;
}

class A {
  final B b;

  A(this.b);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is A && runtimeType == other.runtimeType && b == other.b;

  @override
  int get hashCode => b.hashCode;
}

class B {
  final A a;

  B(this.a);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is B && runtimeType == other.runtimeType && a == other.a;

  @override
  int get hashCode => a.hashCode;
}

class A2 {
  final B2 b2;

  A2(this.b2);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is A2 && runtimeType == other.runtimeType && b2 == other.b2;

  @override
  int get hashCode => b2.hashCode;
}

class B2 {
  final A2 a2;

  B2(this.a2);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is B2 && runtimeType == other.runtimeType && a2 == other.a2;

  @override
  int get hashCode => a2.hashCode;
}
