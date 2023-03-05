import 'package:tint/tint.dart';

String _changelogUrl(String packageName) =>
    'https://pub.dev/packages/$packageName/changelog';

/// Represents a new version of the package
class UpdateAvailable {
  /// Creates a update
  UpdateAvailable({
    required this.packageName,
    required this.currentVersion,
    required this.latestVersion,
  });

  /// Name of the package you want to notify of update
  final String packageName;

  /// Current version of the package
  final String currentVersion;

  /// The latest pub.dev release
  final String latestVersion;

  /// Pretty-prints a banner with details of latest version
  void show() {
    final updateCmd = 'dart pub global activate $packageName'.cyan();
    final current = currentVersion.grey();
    final latest = latestVersion.green();

    print(
      '\n\n\n___________________________________________________\n\n'.yellow(),
    );
    print(
      'Update Available '
      '$current → $latest ',
    );
    print('Run $updateCmd to update');
    print('Changelog: ${_changelogUrl(packageName)}');
    print(
      '\n___________________________________________________\n\n\n'.yellow(),
    );
  }
}
