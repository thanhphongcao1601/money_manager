abstract class HomeState {
  const HomeState();
}

class HomeInitial extends HomeState {
  HomeInitial();
}

class HomeLoading extends HomeState {
  HomeLoading();
}

class HomeLoaded extends HomeState {
  HomeLoaded();
}

class HomeError extends HomeState {
  HomeError();
}
