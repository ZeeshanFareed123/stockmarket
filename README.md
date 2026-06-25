# StockUBL

Mobile-first Flutter foundation for a stock-market application.

## Current scope

- Android and iOS project scaffolding
- Feature-first architecture
- Riverpod state management and dependency injection
- GoRouter navigation
- Persisted appearance settings foundation:
  - light, dark, and system theme modes
  - multiple color palettes
  - selectable font families
  - app-level text zoom
- Dio networking and secure-storage extension points
- Riverpod source generation; Freezed/JSON generation will be added with the
  first API DTOs using versions compatible with the pinned SDK
- Firebase, push notifications, crash reporting, SSL pinning, REST, and
  WebSocket seams ready for later integrations
- Minimal Login screen with a Start button

## Run

```bash
fvm flutter pub get
fvm dart run build_runner build
fvm flutter run --dart-define=APP_ENV=mock
```

Open the project folder in Android Studio and choose an Android emulator or an
iOS Simulator. The project is pinned to Flutter 3.41.9 through FVM. If Android
Studio does not detect it automatically, set the Flutter SDK path to
`<project>/.fvm/flutter_sdk`. iOS builds require Xcode and CocoaPods on macOS.

## Environments

```text
mock
twelveData
production
```

Example:

```bash
fvm flutter run --dart-define=APP_ENV=mock
```

The detailed architecture contract is in
[`docs/architecture.md`](docs/architecture.md).
