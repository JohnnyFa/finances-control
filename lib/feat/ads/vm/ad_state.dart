abstract class AdState {
  const AdState();
}

class AdInitial extends AdState {
  const AdInitial();
}

class AdLoading extends AdState {
  const AdLoading();
}

class AdLoaded extends AdState {
  final bool shouldShow;

  const AdLoaded(this.shouldShow);
}

class AdError extends AdState {
  final String message;

  const AdError(this.message);
}
