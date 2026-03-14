import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/scoreboard/presentation/pages/match_detail_page.dart';
import '../../features/scoreboard/presentation/pages/scoreboard_page.dart';

part 'app_router.g.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

@TypedGoRoute<ScoreboardRoute>(
  path: '/',
  routes: [
    TypedGoRoute<MatchDetailRoute>(path: 'matches/:id'),
  ],
)
class ScoreboardRoute extends GoRouteData {
  const ScoreboardRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ScoreboardPage();
  }
}

class MatchDetailRoute extends GoRouteData {
  final String id;

  const MatchDetailRoute({required this.id});

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: MatchDetailPage(matchId: id),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
          child: child,
        );
      },
    );
  }
}

final appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/',
  routes: $appRoutes,
);
