# Features

Each feature owns its `data`, `domain`, optional `application`, and
`presentation` layers.

Planned capabilities:

- `auth`
- `app_shell`
- `home`
- `markets`
- `portfolio`
- `instrument_details`
- `trading`
- `watchlist`
- `funds`
- `orders`
- `notifications`
- `profile`

Cross-feature live quotes belong in `shared/market_data`, not in `markets`.
