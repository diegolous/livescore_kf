// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_router.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [$scoreboardRoute];

RouteBase get $scoreboardRoute => GoRouteData.$route(
  path: '/',

  factory: $ScoreboardRouteExtension._fromState,
  routes: [
    GoRouteData.$route(
      path: 'matches/:id',

      factory: $MatchDetailRouteExtension._fromState,
    ),
  ],
);

extension $ScoreboardRouteExtension on ScoreboardRoute {
  static ScoreboardRoute _fromState(GoRouterState state) =>
      const ScoreboardRoute();

  String get location => GoRouteData.$location('/');

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $MatchDetailRouteExtension on MatchDetailRoute {
  static MatchDetailRoute _fromState(GoRouterState state) =>
      MatchDetailRoute(id: state.pathParameters['id']!);

  String get location =>
      GoRouteData.$location('/matches/${Uri.encodeComponent(id)}');

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}
