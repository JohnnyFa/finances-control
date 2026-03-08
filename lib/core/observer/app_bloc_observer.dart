import 'package:finances_control/core/logger/app_logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A global [BlocObserver] that logs BLoC/Cubit lifecycle and state transitions
/// to the terminal in debug mode.
///
/// PRIVACY: Only class/state type names are logged — never actual state field
/// values, financial data, or any user-identifiable information.
class AppBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase<dynamic> bloc) {
    super.onCreate(bloc);
    AppLogger.bloc('Created  → ${bloc.runtimeType}');
  }

  @override
  void onClose(BlocBase<dynamic> bloc) {
    super.onClose(bloc);
    AppLogger.bloc('Closed   → ${bloc.runtimeType}');
  }

  @override
  void onTransition(
    Bloc<dynamic, dynamic> bloc,
    Transition<dynamic, dynamic> transition,
  ) {
    super.onTransition(bloc, transition);
    final from = transition.currentState.runtimeType;
    final to = transition.nextState.runtimeType;
    AppLogger.bloc(
      '${bloc.runtimeType}: $from → $to',
    );
  }

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    // Cubit changes (no event) — log type names only
    final from = change.currentState.runtimeType;
    final to = change.nextState.runtimeType;
    if (from != to) {
      AppLogger.bloc('${bloc.runtimeType}: $from → $to');
    }
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    AppLogger.error('${bloc.runtimeType} → ${error.runtimeType}');
  }
}
