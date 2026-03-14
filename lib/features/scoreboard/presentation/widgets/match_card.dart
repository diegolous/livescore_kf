import 'package:design_system/design_system.dart' as ds;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/router/app_router.dart';
import '../../domain/entities/match.dart';
import '../../domain/enums/match_status.dart';
import '../bloc/scoreboard_bloc.dart';
import '../bloc/scoreboard_state.dart';
import '../bloc/team_logo_cubit.dart';

class MatchCard extends StatelessWidget {
  final String matchId;

  const MatchCard({super.key, required this.matchId});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ScoreboardBloc, ScoreboardState, Match?>(
      selector: (state) => state.matches[matchId],
      builder: (context, match) {
        if (match == null) return const SizedBox.shrink();

        final variant = switch (match.status) {
          MatchStatus.live => ds.MatchCardVariant.live,
          MatchStatus.upcoming => ds.MatchCardVariant.upcoming,
          MatchStatus.finished => ds.MatchCardVariant.finished,
        };

        return BlocBuilder<TeamLogoCubit, Map<String, String?>>(
          builder: (context, logos) {
            final cubit = context.read<TeamLogoCubit>();

            return Hero(
              tag: 'match_card_${match.id}',
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
                  onTap: () => MatchDetailRoute(id: match.id).push(context),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
