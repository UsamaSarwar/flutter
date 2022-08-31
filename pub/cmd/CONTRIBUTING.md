# Welcome to `cmd` contributing guide 👋🏻

_Flutter command line toolkit_

Thank you for investing your time in contributing to **cmd** project! Any contribution you make will be reflected on [pub.dev/packages/cmd](https://pub.dev/packages/cmd).

Read our [Code of Conduct](./CODE_OF_CONDUCT.md) to keep our community approachable and respectable.

## Directory Structure Guide

_The scripts are categorized by framework wise. So, developers from other stack may find useful scripts easily._

```bash
├── cmd
│   ├── [framework]
│   │   ├── cmd
│   │   │   └── [script.sh]
```

For example, we have a sample script for `flutter doctor` command that's used to inspect Flutter Framework Environment.

```bash
├── cmd
│   ├── flutter
│   │   ├── cmd
│   │   │   └── doctor.sh
```

## Script File Guide

- [x] Make sure you add descriptions in comments followed by `#` or `##` above each script or in the start of Batch Scripts.
- [x] Add `#!/bin/sh` the in the beginning of script.

```bash
#!/bin/sh

##? Inspecting the current state of the Flutter environment
flutter doctor -v

##? Checking for the latest version of Flutter
# flutter upgrade

##? Checking for the latest version of Flutter with force update
# flutter upgrade --force
```

## Integrating Scripts in Code

Please navigate to file `scripts.dart`

```bash
├── cmd
│   ├── flutter
│   │   ├── bin
│   │   │   └── scripts.dart
```

Please add script files into the list as mentioned below:

```dart
/// Integrating Scripts into the code
  List<String> scripts = [
    'doctor.sh',
    'run.sh',
    'build.sh',
    // Add your scripts here...
  ];
```
