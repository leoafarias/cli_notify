import 'package:cli_notify/cli_notify.dart';
import 'package:cli_notify/src/helpers.dart';
import 'package:test/test.dart';

final sameVersion = equals(0);
final needUpdate = lessThan(0);
final dontUpdate = greaterThan(0);

void main() {
  group('Notifies of update', () {
    test('Prints update', () async {
      await Notify(
        packageName: 'pkg',
        currentVersion: '0.0.0',
      ).update();
    });

    test('Compares versions', () {
      // Need update
      expect(compareSemver('1.0.0', '1.0.1'), needUpdate);
      expect(compareSemver('1.0.0', '1.0.2'), needUpdate);
      expect(compareSemver('2.2.0', '2.10.0'), needUpdate);

      // Same version
      expect(compareSemver('1.0.0', '1.0.0'), sameVersion);
      expect(compareSemver('2.3.12', '2.3.12'), sameVersion);
      expect(compareSemver('4.2.2-dev.1', '4.2.2-dev.1'), sameVersion);

      // No update needed
      expect(compareSemver('1.0.1', '1.0.0'), dontUpdate);
      expect(compareSemver('2.3.13', '2.3.12'), dontUpdate);
      expect(compareSemver('4.2.2-dev.2', '4.2.2-dev.1'), sameVersion);
    });

    test('Handles pre-releases', () {
      // Doesnt allow prerelease
      expect(compareSemver('1.0.0-dev.2', '1.0.1-dev.2'), sameVersion);
      expect(compareSemver('1.0.0-dev.2', '1.0.1-dev'), sameVersion);

      // Latest version is not prerelease
      expect(compareSemver('1.0.0-dev.2', '1.0.1'), needUpdate);
      expect(compareSemver('3.10.0-dev.1', '3.10.0-dev.2'), sameVersion);
    });
  });
}
