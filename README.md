# UI/UX Mobile POS

Readme file for the UI/UX Mobile POS

---

## Getting Started 🚀

Ensure we are using nodejs-lts (version 14.16.1)

Current version of Flutter used in project is 2.8.x. If Flutter version is updated ensure the following are updated:

- `flutter-version:` in the following workflows
    * .github\workflows\android.yaml 
    * .github\workflows\production-release.yaml
    * .github\workflows\tests.yaml
    * .github\workflows\tests-packages.yaml
- this section of README.md

On cloning project ensure pub get is called:

```sh
$ flutter pub get
```

### Conventional Commits

Run `npm install` locally to setup the commit hooks on development machines. Commit messages should be in the format:

```
type(area): message (#)
```

where:

- type would be `feat / chore / fix`
- area would be what part of the code (so if type was feat this might be landing or basket - if chore it might be github or docs)
- message is the usual high level notes
- (#) is the issue reference for the change

this [page][conventionalcommits_link] has more info

### Icons
All icons will be uploaded to [flutter_icons]. From there download the .zip file which contains uploaded icons converted into a single .ttf file.

Ttf file will be renamed accordingly and placed under assets/fonts folder.

The .zip file will contain a .dart class which contains our IconData widgets.

Copy the content from there and place it into ECPIcons.dart file.

The last step is to reference the downloaded .ttf file in pubspec.yaml as a font. 


### Starting Mock Server

Fake data is presented to the app via the AppConfig for each flavour. See ecp_services packages for the available Fake Services.

Note, when using the FakeAuthService, the password on Login needs to be > 4 characters

### Project Flavours

This project contains 3 flavors:

- development
- staging
- production

To run the desired flavor either use the launch configuration in VSCode/Android Studio or use the following commands:

```sh
# Development
$ flutter run --flavor development --target lib/main_development.dart

# Staging
$ flutter run --flavor staging --target lib/main_staging.dart

# Production
$ flutter run --flavor production --target lib/main_production.dart
```

_\*UI/UX Mobile POS works on iOS, Android, and Web._

---

## Running Tests 🧪

To generate the mock test files use the following command:

```sh
$ flutter pub run build_runner build
```

To run all unit and widget tests use the following command:

```sh
$ flutter test --coverage --test-randomize-ordering-seed random
```

To run all Kotlin tests from device_service plugin follow these steps:

```sh
$ cd ecp_packages\device_service\android
$ gradlew clean build test
```

To view the generated coverage report you can use [lcov](https://github.com/linux-test-project/lcov).

```sh
# Generate Coverage Report
$ genhtml coverage/lcov.info -o coverage/

# Open Coverage Report
$ open coverage/index.html
```

### Visual Studio Code

For Visual Studio Code you can install:

- [Code Coverage][codecoverage_link]
- [Coverage Gutters][coveragegutters_link]

These extensions will look at the Icov coverage file generated when `flutter test --coverage` command is called. Code Coverage will highlight lines not covered in the PROBLEMS tab. Coverage Gutters highlights lines using the following colours:

- green line - fully covered line
- orange line - some of the branch in if condition is not covered
- red line - color is uncovered by test line

### Atom Editor

If using another IDE such as Android Studio, it is better to use [Atom editor][atomeditor_link] to view the code coverage generated. You will need to install the Dart and icov-info packages such as [coverage-gutter][atomcoveragegutters_link].

### Ignore lines from coverage

- `// coverage:ignore-line` to ignore one line.
- `// coverage:ignore-start` and `// coverage:ignore-end` to ignore range of lines inclusive.
- `// coverage:ignore-file` to ignore the whole file.

---

## Running integration tests

To run all of the scenarios:

`flutter drive --driver=test_driver/integration_test.dart --target=integration_test/scenarios/scenario_runner.dart --flavor staging --dart-define="scanner_service=FakeScannerService" --dart-define="app_home=LoginPage"`

To run a specific test:

`flutter drive --driver=test_driver/integration_test.dart --target=integration_test/scenarios/basket/linked_item/linked_item_1.dart --flavor staging --dart-define="scanner_service=FakeScannerService" --dart-define="app_home=LoginPage"`

If the test scenarios are to be run in a random order then also apply the command line parameter:

`--dart-define="randomise_tests=true"`

To provide keycloak client_id, client_secret, user and password then also apply the command line parameter examples:

`--dart-define="client_id=mobile-app"`
`--dart-define="client_secret=fb31b1bf-9335-4ab1-9b9d-a55a1ddbe427"`
`--dart-define="username=mobiledev"`
`--dart-define="password=mobiledev"`

To speed up animations and therefore reducing the time taken to run some tests:

`--dart-define="fast_anim=true"`

**Note: this is only related to animations and does not affect delays/timers/service latency etc

---

## Working with Translations 🌐

This project relies on [flutter_localizations][flutter_localizations_link] and follows the [official internationalization guide for Flutter][internationalization_link].

### Adding Strings

1. To add a new localizable string, open the `app_en.arb` file at `lib/l10n/arb/app_en.arb`.

```arb
{
    "@@locale": "en",
    "counterAppBarTitle": "Counter",
    "@counterAppBarTitle": {
        "description": "Text shown in the AppBar of the Counter Page"
    }
}
```

2. Then add a new key/value and description

```arb
{
    "@@locale": "en",
    "counterAppBarTitle": "Counter",
    "@counterAppBarTitle": {
        "description": "Text shown in the AppBar of the Counter Page"
    },
    "helloWorld": "Hello World",
    "@helloWorld": {
        "description": "Hello World Text"
    }
}
```

3. Use the new string

```dart
import 'package:ui_flutter_app/l10n/l10n.dart';

@override
Widget build(BuildContext context) {
  final l10n = context.l10n;
  return Text(l10n.helloWorld);
}
```

### Adding Supported Locales

Update the `CFBundleLocalizations` array in the `Info.plist` at `ios/Runner/Info.plist` to include the new locale.

```xml
    ...

    <key>CFBundleLocalizations</key>
	<array>
		<string>en</string>
		<string>es</string>
	</array>

    ...
```

### Adding Translations

1. For each supported locale, add a new ARB file in `lib/l10n/arb`.

```
├── l10n
│   ├── arb
│   │   ├── app_en.arb
│   │   └── app_es.arb
```

2. Add the translated strings to each `.arb` file:

`app_en.arb`

```arb
{
    "@@locale": "en",
    "counterAppBarTitle": "Counter",
    "@counterAppBarTitle": {
        "description": "Text shown in the AppBar of the Counter Page"
    }
}
```

`app_es.arb`

```arb
{
    "@@locale": "es",
    "counterAppBarTitle": "Contador",
    "@counterAppBarTitle": {
        "description": "Texto mostrado en la AppBar de la página del contador"
    }
}
```

### Generating localisations

Once transalation has been added or updated run the following command to generate the localisation files:

```sh
$ flutter gen-l10n

```

This will allow you to use the transalations in your dart code.

[coverage_badge]: coverage_badge.svg
[flutter_localizations_link]: https://api.flutter.dev/flutter/flutter_localizations/flutter_localizations-library.html
[internationalization_link]: https://flutter.dev/docs/development/accessibility-and-localization/internationalization
[conventionalcommits_link]: https://www.conventionalcommits.org/en/v1.0.0/#summary
[codecoverage_link]: https://marketplace.visualstudio.com/items?itemName=markis.code-coverage
[coveragegutters_link]: https://marketplace.visualstudio.com/items?itemName=ryanluker.vscode-coverage-gutters
[atomeditor_link]: https://atom.io/
[atomcoveragegutters_link]: https://atom.io/packages/coverage-gutter
[flutter_icons]: https://fluttericon.com/

