import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:smart_expense_manager/core/theme/app_theme.dart';

class PlayfulEmptyState extends StatelessWidget {
  const PlayfulEmptyState({
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
    this.accentColor = AppPalette.lavender,
    super.key,
  });

  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              width: 126,
              height: 108,
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Positioned(
                    left: 8,
                    top: 10,
                    child: _Bubble(
                      size: 34,
                      color: AppPalette.sunshine.withValues(alpha: 0.78),
                    ).animate(onPlay: (controller) => controller.repeat())
                      .moveY(begin: 0, end: -7, duration: 1300.ms)
                      .then()
                      .moveY(begin: -7, end: 0, duration: 1300.ms),
                  ),
                  Positioned(
                    right: 5,
                    bottom: 8,
                    child: _Bubble(
                      size: 28,
                      color: AppPalette.mint.withValues(alpha: 0.85),
                    ).animate(onPlay: (controller) => controller.repeat())
                      .moveY(begin: 0, end: 6, duration: 1500.ms)
                      .then()
                      .moveY(begin: 6, end: 0, duration: 1500.ms),
                  ),
                  Container(
                    width: 82,
                    height: 82,
                    decoration: BoxDecoration(
                      color: accentColor,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: AppPalette.lavenderDeep.withValues(alpha: 0.14),
                          blurRadius: 22,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Icon(icon, size: 42, color: AppPalette.ink),
                  ).animate().scale(
                    begin: const Offset(0.84, 0.84),
                    duration: 480.ms,
                    curve: Curves.easeOutBack,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w900,
              ),
            ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.12, end: 0),
            const SizedBox(height: 8),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 320),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ).animate().fadeIn(delay: 180.ms),
            if (actionLabel != null && onAction != null) ...<Widget>[
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: onAction,
                icon: const Icon(Icons.auto_awesome_rounded),
                label: Text(actionLabel!),
              ).animate().fadeIn(delay: 240.ms).scale(
                begin: const Offset(0.96, 0.96),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
