# LiveScore

Real-time sports scoreboard Flutter app. Connects to a WebSocket mock server, displays live match scores, and pushes goal notifications across all routes.

## Setup

```bash
# 1. Install Node.js dependency (one-time)
npm install ws

# 2. Start the mock server
node mock_server.js

# 3. Run the app (in a separate terminal)
flutter pub get
flutter run
```

The app auto-connects to `ws://localhost:8080` (or `ws://10.0.2.2:8080` on Android emulator). Deep-link to a specific match: `/matches/match_2`.

## Architecture

See [architecture.md](architecture.md) for a full stream-flow diagram.

**Layers**: Data -> Domain -> Presentation (Clean Architecture)

```
WebSocket -> DataSource -> Repository -> UseCase -> BLoC -> UI
```

**Key decisions**:
- WebSocket is a **singleton** at the data layer, injected via get_it. No per-page connections.
- Repository maintains an internal match state map. SNAPSHOT initializes it; each DELTA event mutates only the affected match.
- `BlocSelector` selects individual matches by ID, so a GOAL on match_1 does NOT rebuild match_2's card.

## Documentation Answers

### 1. Why BLoC over Riverpod?

BLoC was chosen because the app is fundamentally stream-driven. WebSocket messages are a natural stream, and BLoC's event-driven model maps directly to the SNAPSHOT/DELTA protocol. `BlocSelector` gives fine-grained rebuild control without extra boilerplate. The explicit event classes also make the flow easy to test with `bloc_test`.

### 2. Stream Architecture — Who Owns the WebSocket?

`WebSocketClient` is a **singleton** registered in get_it. It is created once at app startup via `initDependencies()` and lives for the app's lifetime. The `ScoreboardBloc` calls `connect()` on `ScoreboardStarted` and `disconnect()` on `close()`. No widget ever touches the WebSocket directly. The stream chain:

```
WebSocketClient.messages (Stream<String>)
  -> WebSocketScoreboardDataSource (parses JSON -> DTOs)
    -> ScoreboardRepositoryImpl (maps DTOs -> domain entities, maintains state)
      -> WatchScoreboard use case (pass-through)
        -> ScoreboardBloc (subscribes to 3 streams)
```

### 3. Rebuild Strategy

Each `MatchCard` uses `BlocSelector<ScoreboardBloc, ScoreboardState, Match?>` selecting only `state.matches[matchId]`. When a GOAL event updates match_1's score, only match_1's card rebuilds. To verify in DevTools: enable "Track widget rebuilds" — only the affected card flashes.

### 4. SNAPSHOT + DELTA Merge Logic

`ScoreboardRepositoryImpl` holds a `Map<String, Match>` internally:
- On **SNAPSHOT**: replaces the entire map with the incoming match list.
- On **DELTA** (GOAL, YELLOW_CARD, etc.): looks up the match by `matchId`, creates a new `Match` with the updated score/minute/status and the event appended to its events list. Only that match is replaced in the map.

This ensures no full-list replacement on deltas.

### 5. Connection Resilience

`WebSocketClient` implements exponential backoff reconnection:
- On disconnect: 1s -> 2s -> 4s -> 8s -> ... -> max 30s
- `ConnectionStatus` stream drives a `ConnectionBadge` in the header (connecting/connected/reconnecting/disconnected)
- During reconnection, the last-known match state stays visible (no blank screen)
- On reconnect, the server sends a fresh SNAPSHOT, so state resets cleanly

### 6. Goal Banner Across Routes

A `BlocListener` in the `MaterialApp.router`'s `builder` (above the router/navigator) listens for `lastGoalEvent` changes on `ScoreboardBloc`. When a GOAL arrives, a `GoalBanner` slides in from the top via an `Overlay` entry with a `SlideTransition` animation, auto-dismisses after 3 seconds, and slides back out. Because the listener sits at the root builder level — above the navigation stack — it fires regardless of which page the user is on (scoreboard, match detail, or any future route).

### 7. Trade-offs Made

| Decision | Trade-off |
|---|---|
| Single Inter font weight | Faux-bolding instead of separate weight files — reduces bundle size, acceptable for a prototype |


### 8. Production Gaps / Next Features

If this were a production app, the next priorities would be:
1. **Multiple font weights** — bundle Inter 400/500/600/700 for proper typography
2. **Offline persistence** — cache last-known state to SQLite/Hive for instant startup
3. **Push notifications** — server-sent notifications for goals when app is backgrounded
4. **Match filtering/search** — tabs for leagues, favorites, search by team
5. **Accessibility** — semantic labels, screen reader support, contrast ratios
6. **Error reporting** — Sentry/Crashlytics integration
7. **CI/CD** — GitHub Actions for lint, test, build
8. **Localization** — multi-language support

## Design System

A standalone Flutter package at `packages/design_system/` with:
- **Tokens**: Colors, spacing, typography, durations, radii, borders, shadows, motion constants
- **Atoms**: PillBadge, PulsingDot, StatusDot, TeamCrest, AppProgressBar, Gap
- **Molecules**: ScoreDisplay (odometer), MatchStatusBadge, EventTile, ConnectionBadge
- **Organisms**: MatchCard, GoalBanner
- **Theme**: Material 3 light/dark themes

## Tests

```bash
flutter test
```

- **Unit**: ScoreboardBloc (snapshot handling, goal events, connection status)
- **Unit**: MatchEventDto JSON parsing
- **Widget**: MatchCard (live/finished/upcoming variants, missing match)

## Project Structure

```
lib/
  main.dart
  app/router/          # GoRouter with typed routes
  core/
    config/            # AppConfig, AppNetwork
    di/                # get_it injection container
    services/          # TeamLogoService (optional)
    websocket/         # WebSocketClient
  features/
    scoreboard/
      data/            # DTOs, datasource, repository impl
      domain/          # Entities (sealed), enums, repository interface, use case
      presentation/    # BLoC, pages, widgets
    settings/
      presentation/    # ThemeCubit
packages/
  design_system/       # Standalone design system package
```

## Time Log

| Phase | Time |
|---|---|
| Planning & architecture | ~1h 15 min |
| Project setup & mock server | ~9 min |
| Core config + domain + data layers | ~6 min |
| Design system (tokens + components) | ~6 min |
| BLoC + state management | ~2 min |
| UI (scoreboard, detail, app shell) | ~6 min |
| Tests | ~7 min |
| Documentation | ~3 min |
| **Total** | **~2 hours** |

## AI Usage

Claude Code was used as a coding assistant throughout the project for:
- Scaffolding the initial architecture and folder structure
- Implementing design system tokens and component hierarchy
- AnimatedList with SizeTransition for event timeline
- Project audit for magic numbers and design system compliance
- Writing architecture documentation
