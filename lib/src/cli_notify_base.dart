import 'dart:convert';

import 'helpers.dart';
import 'http.dart';
import 'update_available.dart';

String _packageUrl(String packageName) =>
    'https://pub.dev/api/packages/$packageName';

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
    final updateAvailable = await checkForUpdate();
    updateAvailable?.show();
  }

  /// Returns a [UpdateAvailable] if an update is available
  Future<UpdateAvailable?> checkForUpdate() async {
    try {
      final latestVersion = await _fetchLatestVersion();
      // Could not get latest version
      if (latestVersion == null) return null;
      // Compare semver
      final comparison = compareSemver(currentVersion, latestVersion);
      // Check as need update if latest version is higher
      final needsUpdate = comparison < 0;
      if (needsUpdate) {
        return UpdateAvailable(
          packageName: packageName,
          currentVersion: currentVersion,
          latestVersion: latestVersion,
        );
      }
    } on Exception {
      // Don't do anything fail silently
    }
    return null;
  }
}
