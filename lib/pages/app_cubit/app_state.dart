abstract class AppState {
  const AppState();
}

class AppInitial extends AppState {
  AppInitial();
}

class AppLoading extends AppState {
  AppLoading();
}

class AppLoaded extends AppState {
  AppLoaded();
}

class AppError extends AppState {
  AppError();
}

class HomePageLoaded extends AppState {
  const HomePageLoaded();
}

class ChartPageLoaded extends AppState {
  const ChartPageLoaded();
}

class SettingPageLoaded extends AppState {
  const SettingPageLoaded();
}

class BackupPageLoaded extends AppState {
  const BackupPageLoaded();
}
