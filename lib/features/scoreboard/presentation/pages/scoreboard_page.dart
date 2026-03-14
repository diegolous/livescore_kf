import 'package:design_system/design_system.dart' hide MatchCard;
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/enums/match_status.dart';
import '../bloc/scoreboard_bloc.dart';
import '../bloc/scoreboard_state.dart';
import '../widgets/connection_badge.dart';
import '../widgets/match_card.dart';

class _MatchIdsByStatus extends Equatable {
  final List<String> live;
  final List<String> upcoming;
  final List<String> finished;

  const _MatchIdsByStatus({
    required this.live,
    required this.upcoming,
    required this.finished,
  });

  @override
  List<Object?> get props => [live, upcoming, finished];
}

class ScoreboardPage extends StatelessWidget {
  const ScoreboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LiveScore'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: AppSpacing.md),
            child: AppConnectionBadge(),
          ),
        ],
      ),
      body: BlocSelector<ScoreboardBloc, ScoreboardState, _MatchIdsByStatus>(
        selector: (state) {
          final matches = state.matches.values;
          return _MatchIdsByStatus(
            live: matches
                .where((m) => m.status == MatchStatus.live)
                .map((m) => m.id)
                .toList(),
            upcoming: matches
                .where((m) => m.status == MatchStatus.upcoming)
                .map((m) => m.id)
                .toList(),
            finished: matches
                .where((m) => m.status == MatchStatus.finished)
                .map((m) => m.id)
                .toList(),
          );
        },
        builder: (context, ids) {
          if (ids.live.isEmpty && ids.upcoming.isEmpty && ids.finished.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxxl),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.sports_soccer,
                      size: AppSpacing.crestLarge,
                      color: context.textTertiary,
                    ),
                    const Gap.lg(),
                    Text(
                      'No matches yet',
                      style: AppTypography.titleMedium.copyWith(
                        color: context.textPrimary,
                      ),
                    ),
                    const Gap.sm(),
                    Text(
                      'Waiting for a connection to the server.\nMatches will appear automatically once connected.',
                      style: AppTypography.bodySmall.copyWith(
                        color: context.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
            children: [
              if (ids.live.isNotEmpty) ...[
                const SectionHeader(
                  title: 'LIVE',
                  dotColor: AppColors.live,
                ),
                ...ids.live.map(
                  (id) => MatchCard(key: ValueKey(id), matchId: id),
                ),
              ],
              if (ids.upcoming.isNotEmpty) ...[
                const SectionHeader(
                  title: 'UPCOMING',
                  dotColor: AppColors.upcoming,
                ),
                ...ids.upcoming.map(
                  (id) => MatchCard(key: ValueKey(id), matchId: id),
                ),
              ],
              if (ids.finished.isNotEmpty) ...[
                const SectionHeader(
                  title: 'FINISHED',
                  dotColor: AppColors.finished,
                ),
                ...ids.finished.map(
                  (id) => MatchCard(key: ValueKey(id), matchId: id),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
