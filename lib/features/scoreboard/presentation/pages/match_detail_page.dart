import 'package:design_system/design_system.dart';
import 'package:design_system/design_system.dart' as ds;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/match.dart';
import '../../domain/enums/match_status.dart';
import '../bloc/scoreboard_bloc.dart';
import '../bloc/scoreboard_state.dart';
import '../bloc/team_logo_cubit.dart';
import '../widgets/event_tile.dart';

class MatchDetailPage extends StatelessWidget {
  final String matchId;

  const MatchDetailPage({super.key, required this.matchId});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ScoreboardBloc, ScoreboardState, Match?>(
      selector: (state) => state.matches[matchId],
      builder: (context, match) {
        if (match == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Match')),
            body: Center(
              child: Text(
                'Match not found',
                style: AppTypography.bodyMedium.copyWith(
                  color: context.textSecondary,
                ),
              ),
            ),
          );
        }

        final variant = switch (match.status) {
          MatchStatus.live => ds.MatchCardVariant.live,
          MatchStatus.upcoming => ds.MatchCardVariant.upcoming,
          MatchStatus.finished => ds.MatchCardVariant.finished,
        };

        return Scaffold(
          appBar: AppBar(
            title: Text('${match.homeTeam} vs ${match.awayTeam}'),
            centerTitle: true,
          ),
          body: BlocBuilder<TeamLogoCubit, Map<String, String?>>(
            builder: (context, logos) {
              final cubit = context.read<TeamLogoCubit>();
              return Column(
                children: [
                  Hero(
                    tag: 'match_card_$matchId',
                    child: Material(
                      type: MaterialType.transparency,
                      child: ds.MatchCard(
                        data: ds.MatchCardData(
                          homeTeam: match.homeTeam,
                          awayTeam: match.awayTeam,
                          homeScore: match.homeScore,
                          awayScore: match.awayScore,
                          minute: match.minute,
                          variant: variant,
                          homeBadgeUrl: cubit.getBadgeUrl(match.homeTeam),
                          awayBadgeUrl: cubit.getBadgeUrl(match.awayTeam),
                        ),
                        showLiveGlow: false,
                      ),
                    ),
                  ),
                  const Divider(height: 1),
                  Expanded(
                    child: match.events.isEmpty
                        ? Center(
                            child: Text(
                              match.status == MatchStatus.finished
                                  ? 'No events recorded'
                                  : 'No events yet',
                              style: AppTypography.bodyMedium.copyWith(
                                color: context.textTertiary,
                              ),
                            ),
                          )
                        : _AnimatedEventList(
                            events: match.events,
                          ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}

class _AnimatedEventList extends StatefulWidget {
  final List<dynamic> events;

  const _AnimatedEventList({required this.events});

  @override
  State<_AnimatedEventList> createState() => _AnimatedEventListState();
}

class _AnimatedEventListState extends State<_AnimatedEventList> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  int _knownLength = 0;

  @override
  void initState() {
    super.initState();
    _knownLength = widget.events.length;
  }

  @override
  void didUpdateWidget(_AnimatedEventList oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newLength = widget.events.length;
    if (newLength > _knownLength) {
      final added = newLength - _knownLength;
      for (int i = 0; i < added; i++) {
        _listKey.currentState?.insertItem(0, duration: AppDurations.normal);
      }
      _knownLength = newLength;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedList(
      key: _listKey,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      initialItemCount: widget.events.length,
      itemBuilder: (context, index, animation) {
        final eventIndex = widget.events.length - 1 - index;
        if (eventIndex < 0 || eventIndex >= widget.events.length) {
          return const SizedBox.shrink();
        }
        final event = widget.events[eventIndex];

        return SizeTransition(
          sizeFactor: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          ),
          axisAlignment: 1.0,
          child: AppEventTile(
            event: event,
            isLast: index == widget.events.length - 1,
          ),
        );
      },
    );
  }
}
