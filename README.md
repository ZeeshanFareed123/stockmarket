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
- Dio REST networking with redacted request logging
- Cross-platform WebSocket market-price streaming
- REST snapshot + live tick coordinator with lifecycle-aware reconnect
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

Twelve Data development mode:

```bash
fvm flutter run \
  --dart-define=APP_ENV=twelveData \
  --dart-define=TWELVE_DATA_API_KEY=your_key_here
```

If `TWELVE_DATA_API_KEY` is omitted in `twelveData` mode, the public `demo`
key is used for the AAPL REST tracer bullet. Twelve Data rejects WebSocket
upgrades for the demo key, so live ticks require your own account key and an
eligible streaming plan/trial.

API keys are runtime build configuration and must never be committed. A key
passed with `--dart-define` is still present in the compiled client, so this is
acceptable only for development. Production will use the backend gateway
boundary already represented by the `production` environment.

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
