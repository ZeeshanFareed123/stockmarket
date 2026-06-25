# StockUBL architecture contract

## Direction

StockUBL uses feature-first MVVM, repository contracts, selective application
use cases, Riverpod for state and dependency injection, GoRouter for
navigation, Dio for REST, and a separate streaming boundary for live prices.

```text
View
  -> ViewModel
  -> optional Use Case
  -> Repository contract
  -> Repository implementation
  -> Mock / REST / WebSocket / Local storage
```

DTOs never reach the UI. Widgets never call APIs. Feature presentation and data
layers are private to their feature.

## Ownership

```text
app/       Application bootstrap, router, appearance settings and design system
core/      Infrastructure: network, storage, security and observability
shared/    Cross-feature domain models and reusable presentation components
features/  Auth, Home, Markets, Portfolio and future business capabilities
```

Future integrations such as Firebase Analytics, Crashlytics, push
notifications, certificate pinning and alternative market-data providers must
implement small interfaces under `core/`; feature code must not import vendor
SDKs directly.

## Appearance

`AppSettings` is the single source of truth for:

- `ThemeMode`
- `AppColorPalette`
- `AppFontFamily`
- `textScaleFactor`

The settings are persisted through `AppSettingsRepository`. New palettes and
bundled font assets can be added without changing feature screens.

## Networking

Feature-scoped API services use the shared `ApiClient`. There is no generic
`BaseRepository` or `BaseViewModel`. API keys and authentication secrets must
not be embedded in production builds.

REST returns `Result<T>` through repositories. Streaming exposes connection
state separately and does not wrap every tick in `Result`.

## Live prices

```text
REST `/quote` snapshot
  -> MarketDataController
  -> MarketDataState <- WebSocket price ticks
  -> per-symbol Riverpod selectors (next UI phase)
  -> affected row only
```

The live-price engine belongs under `shared/market_data`, not the Markets
feature, because Home, Markets and Portfolio all consume quotes. Riverpod owns
consumer lifecycle; the subscription registry only batches and reference-counts
transport subscriptions.

The current Twelve Data tracer bullet:

- loads an initial quote through REST;
- opens the official price WebSocket;
- sends subscribe/unsubscribe commands for the desired symbol set;
- sends a heartbeat every ten seconds;
- reconnects with capped exponential backoff;
- disconnects while the mobile app is backgrounded and resumes in foreground;
- redacts the API key from logs;
- defaults to one AAPL symbol so the public demo path can be verified.

`TWELVE_DATA_API_KEY` is accepted through `--dart-define` for development only.
Production mobile binaries must receive market data from the StockUBL backend
gateway so provider credentials are never shipped to customers.

Production fallback is:

```text
WebSocket -> slow batched REST polling -> stale/offline state
```

Production must never silently display mock prices.

## Financial values

Money, prices, quantities and percentages use decimal/fixed-point domain value
objects. `double` conversion is allowed only at presentation boundaries such as
chart coordinates.

## Mobile now, web later

The initial project includes Android and iOS only. Domain, repositories and
ViewModels remain platform-independent so a web target and desktop-specific
views can be added later without rewriting business logic.

## Build order

1. Foundation, appearance and routing
2. Markets end-to-end tracer bullet using mock data
3. Home and Portfolio
4. Authentication and guarded navigation
5. Instrument details and Buy/Sell
6. Twelve Data integration (REST/WebSocket foundation complete)
7. Backend gateway, Firebase and production security
8. Local database/offline support
9. Responsive web views
