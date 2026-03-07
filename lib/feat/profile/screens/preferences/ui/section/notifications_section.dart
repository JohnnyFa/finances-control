import 'package:finances_control/feat/profile/screens/preferences/ui/widget/section_card.dart';
import 'package:finances_control/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';

class NotificationsSection extends StatelessWidget {
  const NotificationsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: context.appStrings.profile_notifications.toUpperCase(),
      children: [
        _NotificationTile(
          icon: "📬",
          title: context.appStrings.preferences_push_notifications,
          subtitle: context.appStrings.preferences_push_notifications_desc,
        ),
        _NotificationTile(
          icon: "🎯",
          title: context.appStrings.preferences_goal_alerts,
          subtitle: context.appStrings.preferences_goal_alerts_desc,
        ),
        _NotificationTile(
          icon: "💸",
          title: context.appStrings.preferences_expense_reminders,
          subtitle: context.appStrings.preferences_expense_reminders_desc,
        ),
        _NotificationTile(
          icon: "📊",
          title: context.appStrings.preferences_monthly_reports,
          subtitle: context.appStrings.preferences_monthly_reports_desc,
        ),
      ],
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;

  const _NotificationTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [

          Text(icon, style: const TextStyle(fontSize: 26)),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 16),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                      color: scheme.onSurface.withValues(alpha: 0.6), fontSize: 14),
                ),
              ],
            ),
          ),

          Switch(
            value: true,
            onChanged: (_) {},
          )
        ],
      ),
    );
  }
}