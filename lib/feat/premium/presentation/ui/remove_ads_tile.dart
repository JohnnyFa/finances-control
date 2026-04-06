import 'package:finances_control/feat/premium/presentation/vm/purchase_state.dart';
import 'package:finances_control/feat/premium/presentation/vm/purchase_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finances_control/feat/ads/vm/ad_viewmodel.dart';

class RemoveAdsTile extends StatelessWidget {
  const RemoveAdsTile({super.key});

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
        final isLoading = state is PurchaseLoading;

        return GestureDetector(
          onTap: null,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
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
                      children: const [
                        Text(
                          'Remover anúncios',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Pagamento único - R\$ 4,90',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: Colors.blueGrey,
                          ),
                        ),
                      ],
                    ),
                  ),

                  ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () async {
                            await context.read<PurchaseViewModel>().removeAds();

                            await Future.delayed(const Duration(seconds: 1));

                            if (context.mounted) {
                              context.read<AdViewModel>().load();
                            }
                          },
                    child: isLoading
                        ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Comprar'),
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
