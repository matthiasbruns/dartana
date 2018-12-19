import "package:dartana/dartana.dart";
import "package:test/test.dart";

import "dartana_matchers.dart";

void main() {
  group("Components", () {
    test(
        "should throw exception when no modules or parent components were passed",
        () {
      var fn = () => Component.createComponent();

      expect(() => fn(), throwsComponentException);
    });

    test("should throw exception when all modules are empty", () {
      var fn = () {
        var module1 = Module.createModule(body: (module) {});
        var module2 = Module.createModule(body: (module) {});

        return Component.createComponent(modules: [module1, module2]);
      };

      expect(() => fn(), throwsComponentException);
    });
  });
}
