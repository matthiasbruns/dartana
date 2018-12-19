import 'declaration.dart';
import 'exceptions.dart';
import 'key.dart';

class IterableExtensions<T> {
  static Map<Key, Declaration> fold(Iterable<Map<Key, Declaration>> source,
      {Function(Declaration) each}) {
    return source.fold(Map<Key, Declaration>(), (acc, currDeclarations) {
      currDeclarations.entries.forEach((entry) {
        var existingDeclaration = acc[entry.key];
        if (existingDeclaration != null) {
          throw OverrideException.fromDeclarations(
              entry.value, existingDeclaration);
        }
        if (each != null) {
          each(entry.value);
        }
      });
      acc.addAll(currDeclarations);
      return acc;
    });
  }
}
