# cli_notify

# Install

```bash
dart pub add cli_notify
```

## Usage

Notify users that there is an update

```dart
import 'package:cli_notify/cli_notify.dart';

// Current version of your CLI
final packageName = 'package-name';
final currentVersion = '1.0.0';
void main() async {
  await Notify(
    packageName: packageName,
    currentVersion: currentVersion,
  ).updater();
}

```
