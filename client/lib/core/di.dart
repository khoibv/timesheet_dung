import 'package:client/data/repositories/api_connection.dart';
import 'package:client/data/repositories/mocks/api_connection_mock.dart';
import 'package:client/data/repositories/mocks/timesheet_repository_mock.dart';
import 'package:client/presentation/providers/tab_index.dart';
import 'package:client/presentation/providers/timesheet_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

import '../presentation/providers/new_sheet_provider.dart';

/// service locator
final sl = GetIt.instance;

/// Dependency injection utility
class DI {
  static Future<void> init() async {
    sl.registerLazySingleton<ApiConnection>(
      () => !kDebugMode
          ? ApiConnection(apiConfig: ApiConfig())
          : ApiConnectionMock(apiConfig: ApiConfig()),
    );

    // Repositories
    sl.registerLazySingleton<TimeSheetRepositoryMock>(
      () => TimeSheetRepositoryMock(connection: sl()),
    );

    // Providers
    sl.registerLazySingleton<TabIndex>(
      () => TabIndex(),
    );
    sl.registerLazySingleton<NewSheetProvider>(
          () => NewSheetProvider(sl()),
    );
    sl.registerLazySingleton<TimeSheetProvider>(
      () => TimeSheetProvider(sl()),
    );
  }
}
