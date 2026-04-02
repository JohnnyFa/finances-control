import 'package:finances_control/feat/ads/enum/ad_placement.dart';
import 'package:finances_control/feat/ads/service/ad_visibility_service.dart';
import 'package:finances_control/feat/ads/vm/ad_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdViewModel extends Cubit<AdState> {
  final AdVisibilityService adVisibilityService;
  final AdPlacement placement;

  AdViewModel({
    required this.adVisibilityService,
    required this.placement,
  }) : super(const AdInitial());

  Future<void> load() async {
    emit(const AdLoading());

    try {
      final shouldShow = await adVisibilityService.shouldShowAd(placement);
      emit(AdLoaded(shouldShow));
    } catch (e) {
      emit(AdError(e.toString()));
    }
  }
}
