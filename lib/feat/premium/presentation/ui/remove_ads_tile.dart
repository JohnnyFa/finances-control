import 'package:finances_control/core/analytics/analytics_service.dart';
import 'package:finances_control/core/di/setup_locator.dart';
import 'package:finances_control/core/extensions/context_extensions.dart';
import 'package:finances_control/feat/premium/domain/entitlement.dart';
import 'package:finances_control/feat/premium/presentation/vm/purchase_state.dart';
import 'package:finances_control/feat/premium/presentation/vm/purchase_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RemoveAdsTile extends StatefulWidget {
  const RemoveAdsTile({super.key});

  @override
  State<RemoveAdsTile> createState() => _RemoveAdsTileState();
}

class _RemoveAdsTileState extends State<RemoveAdsTile> {
  bool _trackedPaywallView = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PurchaseViewModel, PurchaseState>(
      listener: (context, state) {
        if (state is PurchaseError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: const Color(0xFFEF4444),
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is PurchaseSuccess && state.entitlement != Entitlement.free) {
          return const SizedBox.shrink();
        }
        if (!_trackedPaywallView) {
          _trackedPaywallView = true;
          getIt<AnalyticsService>().trackViewPaywall();
        }

        return GestureDetector(
          onTap: state is PurchaseLoading
              ? null
              : () {
                  getIt<AnalyticsService>().trackStartPurchase();
                  context.read<PurchaseViewModel>().removeAds();
                },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFFFF9E6), Color(0xFFFFF3CC)],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFFFA000).withValues(alpha: 0.3),
                  width: 1.5,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFA000).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.workspace_premium_rounded,
                        size: 20,
                        color: Color(0xFFFFA000),
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.appStrings.remove_ads,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            context.appStrings.one_time_payment,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: Colors.blueGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 16,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
