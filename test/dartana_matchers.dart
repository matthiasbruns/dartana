import 'package:dartana/src/exceptions.dart';
import 'package:matcher/matcher.dart';
import 'package:test_api/src/frontend/throws_matcher.dart';

const isComponentNotInitializedException = const TypeMatcher<ComponentNotInitializedException>();

const isComponentException = const TypeMatcher<ComponentException>();

const isInjectionException = const TypeMatcher<InjectionException>();

const isOverrideException = const TypeMatcher<OverrideException>();

/// A matcher for functions that throw ComponentNotInitializedException.
const Matcher throwsComponentNotInitializedException =
// ignore: deprecated_member_use
    Throws(isComponentNotInitializedException);

/// A matcher for functions that throw ComponentException.
const Matcher throwsComponentException =
// ignore: deprecated_member_use
    Throws(isComponentException);

/// A matcher for functions that throw InjectionException.
const Matcher throwsInjectionException =
// ignore: deprecated_member_use
    Throws(isInjectionException);

/// A matcher for functions that throw InjectionException.
const Matcher throwsOverrideException =
// ignore: deprecated_member_use
Throws(isOverrideException);
