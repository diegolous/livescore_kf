import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/scoreboard/data/datasources/websocket_scoreboard_datasource.dart';
import '../../features/scoreboard/data/repositories/scoreboard_repository_impl.dart';
import '../../features/scoreboard/domain/repositories/scoreboard_repository.dart';
import '../../features/scoreboard/domain/usecases/watch_scoreboard.dart';
import '../../features/scoreboard/presentation/bloc/scoreboard_bloc.dart';
import '../../features/scoreboard/presentation/bloc/team_logo_cubit.dart';
import '../config/app_config.dart';
import '../services/team_logo_service.dart';
import '../websocket/websocket_client.dart';

final sl = GetIt.instance;

void initDependencies(SharedPreferences prefs) {
  sl.registerSingleton<SharedPreferences>(prefs);

  // Core
  sl.registerLazySingleton<WebSocketClient>(
    () => WebSocketClient(url: AppConfig.websocketUrl),
  );

  // Data sources
  sl.registerLazySingleton<WebSocketScoreboardDataSource>(
    () => WebSocketScoreboardDataSource(sl<WebSocketClient>()),
  );

  // Repositories
  sl.registerLazySingleton<ScoreboardRepository>(
    () => ScoreboardRepositoryImpl(
      dataSource: sl<WebSocketScoreboardDataSource>(),
      client: sl<WebSocketClient>(),
    ),
  );

  // Use cases
  sl.registerLazySingleton<WatchScoreboard>(
    () => WatchScoreboard(sl<ScoreboardRepository>()),
  );

  // BLoC
  sl.registerFactory<ScoreboardBloc>(
    () => ScoreboardBloc(sl<WatchScoreboard>()),
  );

  // Team logos
  sl.registerLazySingleton<TeamLogoService>(() => TeamLogoService());
  sl.registerLazySingleton<TeamLogoCubit>(
    () => TeamLogoCubit(sl<TeamLogoService>(), sl<SharedPreferences>()),
  );
}
