import 'package:finances_control/core/di/setup_locator.dart';
import 'package:finances_control/feat/ebooks/data/repo/ebooks_repository.dart';
import 'package:finances_control/feat/ebooks/data/repo/ebooks_repository_impl.dart';
import 'package:finances_control/feat/ebooks/vm/ebooks_viewmodel.dart';

void ebooksInjection() {
  getIt.registerLazySingleton<EbooksRepository>(
    () => EbooksRepositoryImpl(getIt()),
  );
  getIt.registerFactory(() => EbooksViewModel(getIt()));
}
