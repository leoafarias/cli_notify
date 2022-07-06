import 'dart:convert';

import 'package:tint/tint.dart';

import 'helpers.dart';
import 'http.dart';

String _packageUrl(String packageName) =>
    'https://pub.dev/api/packages/$packageName';

String _changelogUrl(String packageName) =>
    'https://pub.dev/packages/$packageName/changelog';

/// cli update
class Notify {
  /// Constructor for the update notifier
  const Notify({
    required this.packageName,
    required this.currentVersion,
    this.verbose = false,
  });

  /// Name of the package you want to notify of update
  final String packageName;

  /// Current version of the package
  final String currentVersion;

  /// Output error logs
  final bool verbose;

  /// Fetches latest version from pub.dev
  Future<String?> _fetchLatestVersion() async {
    
      final response = await fetch(_packageUrl(packageName));
      final json = jsonDecode(response) as Map<String, dynamic>;
      final version = json['latest']['version'] as String;
      return version;
    
  }

  /// Prints notice if version needs update
  Future<void> update() async {
    try {
      final latestVersion = await _fetchLatestVersion();
      // Could not get latest version
      if (latestVersion == null) return;
      // Compare semver
      final comparison = compareSemver(currentVersion, latestVersion);
      // Check as need update if latest version is higher
      final needUpdate = comparison < 0;

      if (needUpdate) {
        final updateCmd = 'dart pub global activate $packageName'.cyan();
        final current = '$currentVersion'.grey();
        final latest = '$latestVersion'.green();

        print(
          '\n\n\n___________________________________________________\n\n'
              .yellow(),
        );
        print(
          'Update Available '
          '$current → $latest ',
        );
        print('Run $updateCmd to update');
        print('Changelog: ${_changelogUrl(packageName)}');
        print(
          '\n___________________________________________________\n\n\n'
              .yellow(),
        );
        return;
      }
      return;
    } on Exception {
      // Don't do anything fail silently
      return;
    }
  }
}
