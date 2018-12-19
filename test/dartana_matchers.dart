import 'package:dartana/src/exceptions.dart';
import 'package:matcher/matcher.dart';
import 'package:test_api/src/frontend/throws_matcher.dart';

const isComponentException = const TypeMatcher<ComponentException>();

const isInjectionException = const TypeMatcher<InjectionException>();

/// A matcher for functions that throw ComponentException.
const Matcher throwsComponentException =
// ignore: deprecated_member_use
    Throws(isComponentException);

/// A matcher for functions that throw InjectionException.
const Matcher throwsInjectionException =
// ignore: deprecated_member_use
    Throws(isInjectionException);
