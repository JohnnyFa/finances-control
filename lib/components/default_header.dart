import 'package:flutter/material.dart';

enum HeaderType { income, expense, neutral }

class DefaultHeader extends StatefulWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onBack;
  final HeaderType type;

  const DefaultHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.onBack,
    this.type = HeaderType.neutral,
  });

  @override
  State<DefaultHeader> createState() => _DefaultHeaderState();
}

class _DefaultHeaderState extends State<DefaultHeader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);

    _slide = Tween<Offset>(
      begin: const Offset(0, -0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _getBaseColor(BuildContext context) {
    switch (widget.type) {
      case HeaderType.income:
        return const Color(0xFF22C55E);
      case HeaderType.expense:
        return const Color(0xFFEF4444);
      case HeaderType.neutral:
        return Theme.of(context).colorScheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final baseColor = _getBaseColor(context);

    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [baseColor, baseColor.withValues(alpha: 0.9)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),

              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(36),
              ),

              boxShadow: [
                BoxShadow(
                  color: baseColor.withValues(alpha: 0.25),
                  blurRadius: 24,
                  spreadRadius: 2,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
                child: Row(
                  children: [
                    _BackButton(
                      onTap: widget.onBack ?? () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5,
                              height: 1.1,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            widget.subtitle,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  final VoidCallback onTap;

  const _BackButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.2),
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: const Padding(
          padding: EdgeInsets.all(16),
          child: Icon(Icons.arrow_back_rounded, color: Colors.white, size: 24),
        ),
      ),
    );
  }
}
