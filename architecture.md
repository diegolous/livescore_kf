# Architecture

## Overview

LiveScore follows **Clean Architecture** with three layers: Data, Domain, and Presentation. State management uses **BLoC/Cubit** (flutter_bloc). Dependency injection uses **get_it**.

## Stream Flow Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                        Mock Server (Node.js)                    │
│  mock_server.js — emits SNAPSHOT + GOAL/YELLOW_CARD/... events  │
└──────────────────────────┬──────────────────────────────────────┘
                           │ WebSocket (ws://localhost:8080)
                           ▼
┌─────────────────────────────────────────────────────────────────┐
│                     WebSocketClient                             │
│  lib/core/websocket/websocket_client.dart                       │
│  - Manages connection lifecycle                                 │
│  - Exponential backoff reconnect (AppNetwork constants)         │
│  - Emits Stream<String> messages                                │
│  - Emits Stream<ConnectionStatus> (connecting/connected/...)    │
└──────────┬─────────────────────────────────┬────────────────────┘
           │ Stream<String>                  │ Stream<ConnectionStatus>
           ▼                                 │
┌───────────────────────────────────┐        │
│  WebSocketScoreboardDataSource    │        │
│  data/datasources/                │        │
│  - Parses JSON messages           │        │
│  - Splits into:                   │        │
│    Stream<List<MatchDto>>         │        │
│    Stream<MatchEventDto>          │        │
└──────────┬────────────────────────┘        │
           │                                 │
           ▼                                 │
┌───────────────────────────────────┐        │
│  ScoreboardRepositoryImpl         │        │
│  data/repositories/               │        │
│  - Maps DTOs → Domain entities    │        │
│  - Maintains match state map      │        │
│  - Appends events to matches      │        │
│  - Emits:                         │        │
│    Stream<List<Match>>            │        │
│    Stream<MatchEvent>             │        │
│    Stream<ConnectionStatus> ◄─────┼────────┘
└──────────┬────────────────────────┘
           │
           ▼
┌───────────────────────────────────┐
│  WatchScoreboard (Use Case)       │
│  domain/usecases/                 │
│  - Thin pass-through              │
│  - Exposes repository streams     │
└──────────┬────────────────────────┘
           │
           ▼
┌───────────────────────────────────────────────────────────────┐
│  ScoreboardBloc                                               │
│  presentation/bloc/                                           │
│  - Subscribes to all 3 streams on ScoreboardStarted           │
│  - Events: ScoreboardMatchesUpdated, ScoreboardMatchEvent-    │
│    Received, ScoreboardConnectionChanged                      │
│  - State: ScoreboardState { matches, connectionStatus,        │
│           lastGoalEvent }                                     │
│  - Goal events trigger SnackBar via BlocListener in main.dart │
└──────────┬────────────────────────────────────────────────────┘
           │ BlocBuilder / BlocSelector
           ▼
┌───────────────────────────────────────────────────────────────┐
│  UI Layer                                                     │
│                                                               │
│  ScoreboardPage ─── ListView of MatchCard organisms           │
│       │                   │ Hero transition                   │
│       │                   ▼                                   │
│       │            MatchDetailPage ─── MatchCard (no glow)    │
│       │                                + AnimatedList events  │
│       │                                                       │
│  SplashWrapper ── overlay with phased animation               │
│  GoalBanner ──── SnackBar overlay on goal events              │
│  ConnectionBadge ── shows WebSocket status in header          │
│  ThemeCubit ──── light/dark toggle persisted via SharedPrefs  │
│  TeamLogoCubit ── fetches & caches team badges (optional API) │
└───────────────────────────────────────────────────────────────┘
```

## Design System Package

Located at `packages/design_system/`, the design system is a standalone Flutter package with:

- **Tokens**: `AppColors`, `AppSpacing`, `AppTypography`, `AppDurations`, `AppRadii`, `AppBorders`, `AppShadows`, `AppMotion`, `AppConstants`
- **Atoms**: `PillBadge`, `PulsingDot`, `StatusDot`, `TeamCrest`, `AppProgressBar`, `Gap`
- **Molecules**: `ScoreDisplay` (odometer animation), `MatchStatusBadge`, `EventTile`, `ConnectionBadge`, `SectionHeader`
- **Organisms**: `MatchCard`, `GoalBanner`
- **Theme**: `LiveScoreTheme` (Material 3 light/dark)

All visual constants (colors, spacing, typography, motion curves, border widths) are defined as tokens. No magic numbers in component code.

## Key Patterns

| Pattern | Implementation |
|---|---|
| State management | BLoC for scoreboard, Cubit for theme & logos |
| Dependency injection | get_it with lazy singletons |
| Navigation | GoRouter with typed routes (go_router_builder) |
| Real-time data | WebSocket with automatic reconnect |
| Animations | Hero transitions, per-digit odometer, SizeTransition event list |
| Theming | Dual light/dark with `BuildContext` extensions for theme-aware colors |

## Domain Entities

- `Match` — sealed/immutable match state with id, teams, scores, minute, status, events list
- `MatchEvent` — sealed class hierarchy: `GoalEvent`, `YellowCardEvent`, `RedCardEvent`, `SubstitutionEvent`, `MinuteUpdateEvent`
- `MatchStatus` — enum: `live`, `upcoming`, `finished`
- `ConnectionStatus` — enum: `connecting`, `connected`, `reconnecting`, `disconnected`
