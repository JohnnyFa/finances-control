import 'package:flutter/material.dart';

class HomeSkeleton extends StatelessWidget {
  const HomeSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        /// HEADER
        //const _HeaderSkeleton(),

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

class _HeaderSkeleton extends StatelessWidget {
  const _HeaderSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF5CCB7A),
            Color(0xFF4CAF50),
          ],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// row icons
            Row(
              children: [
                _box(160, 24),
                const Spacer(),
                _circle(),
                const SizedBox(width: 10),
                _circle(),
              ],
            ),

            const SizedBox(height: 12),

            _box(120, 14),

            const SizedBox(height: 24),

            Row(
              children: [
                _circle(size: 32),
                const SizedBox(width: 16),
                _box(140, 18),
                const SizedBox(width: 16),
                _circle(size: 32),
              ],
            ),
          ],
        ),
      ),
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
