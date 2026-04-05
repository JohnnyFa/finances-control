import 'package:flutter/material.dart';

class HomeSkeleton extends StatelessWidget {
  const HomeSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        Transform.translate(
          offset: const Offset(0, -30),
          child: const _BalanceSkeleton(),
        ),

        Transform.translate(
          offset: const Offset(0, -20),
          child: const _ExpensesSkeleton(),
        ),
      ],
    );
  }
}

class _BalanceSkeleton extends StatelessWidget {
  const _BalanceSkeleton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: _card(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            _box(140, 12),

            const SizedBox(height: 20),

            Row(
              children: [
                _circle(size: 40),
                const SizedBox(width: 12),
                _box(120, 32),
              ],
            ),

            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(child: _miniCard()),
                const SizedBox(width: 12),
                Expanded(child: _miniCard()),
              ],
            ),

            const SizedBox(height: 16),

            _balanceStatusBannerSkeleton(),
          ],
        ),
      ),
    );
  }
}

class _ExpensesSkeleton extends StatelessWidget {
  const _ExpensesSkeleton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: _card(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            _box(200, 20),

            const SizedBox(height: 24),

            Center(child: _circle(size: 140)),

            const SizedBox(height: 20),

            ...List.generate(
              3,
                  (i) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    _circle(size: 10),
                    const SizedBox(width: 12),
                    _box(120, 14),
                    const Spacer(),
                    _box(40, 14),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _box(double w, double h) {
  return Container(
    width: w,
    height: h,
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: 0.3),
      borderRadius: BorderRadius.circular(8),
    ),
  );
}

Widget _circle({double size = 24}) {
  return Container(
    width: size,
    height: size,
    decoration: const BoxDecoration(
      color: Colors.white30,
      shape: BoxShape.circle,
    ),
  );
}

Widget _miniCard() {
  return Container(
    height: 60,
    decoration: BoxDecoration(
      color: Colors.grey.withValues(alpha: 0.2),
      borderRadius: BorderRadius.circular(12),
    ),
  );
}

Widget _card(Widget child) {
  return Container(
    margin: const EdgeInsets.only(bottom: 16),
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.grey.withValues(alpha: 0.2),
      borderRadius: BorderRadius.circular(28),
    ),
    child: child,
  );
}

Widget _balanceStatusBannerSkeleton() {
  return Container(
    width: double.infinity,
    height: 44, // 16px font + 12px padding top + 12px padding bottom
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
    decoration: BoxDecoration(
      color: Colors.grey.withValues(alpha: 0.4),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Row(
      children: [
        _circle(size: 28),
        const SizedBox(width: 12),
        Expanded(
          child: _box(200, 20),
        ),
      ],
    ),
  );
}
