import 'package:flutter/material.dart';

import '../../services/notification_service.dart';
import '../app_models/notification_model.dart';

class NotificationScreen extends StatelessWidget {
  NotificationScreen({super.key});

  final notificationService = NotificationService();

  static const Color primaryColor = Color(0xFF14B8A6);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: const Text(
          "Notifications",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
      ),
      body: StreamBuilder<List<NotificationModel>>(
        stream: notificationService.getNotifications(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            );
          }

          final notifications = snapshot.data!;

          if (notifications.isEmpty) {
            return _buildEmptyState();
          }

          final sections = _groupByDate(notifications);

          return ListView.builder(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            itemCount: sections.length,
            itemBuilder: (context, sectionIndex) {
              final section = sections[sectionIndex];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (sectionIndex != 0) const SizedBox(height: 22),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10, left: 2),
                    child: Text(
                      section.label,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey.shade500,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                  ...section.items.map(
                        (notification) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _NotificationCard(
                        notification: notification,
                        primaryColor: primaryColor,
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
  List<_NotificationSection> _groupByDate(
      List<NotificationModel> notifications) {
    final now = DateTime.now();
    final recent = <NotificationModel>[];
    final weekAgo = <NotificationModel>[];
    final older = <NotificationModel>[];

    for (final n in notifications) {
      final date = n.createdAt?.toDate();
      if (date == null) {
        older.add(n);
        continue;
      }
      final diff = now.difference(date).inDays;
      if (diff < 2) {
        recent.add(n);
      } else if (diff <= 7) {
        weekAgo.add(n);
      } else {
        older.add(n);
      }
    }

    final sections = <_NotificationSection>[];
    if (recent.isNotEmpty) sections.add(_NotificationSection('Recent', recent));
    if (weekAgo.isNotEmpty) {
      sections.add(_NotificationSection('Week Ago', weekAgo));
    }
    if (older.isNotEmpty) sections.add(_NotificationSection('Older', older));
    return sections;
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: primaryColor.withOpacity(0.08),
            ),
            child: Icon(
              Icons.notifications_none_rounded,
              size: 42,
              color: primaryColor.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "No notifications yet",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "We'll let you know when something arrives",
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationSection {
  final String label;
  final List<NotificationModel> items;
  _NotificationSection(this.label, this.items);
}

class _NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  final Color primaryColor;

  const _NotificationCard({
    required this.notification,
    required this.primaryColor,
  });

  IconData _iconForType(String type) {
    switch (type.toLowerCase()) {
      case 'booking':
        return Icons.calendar_today_rounded;
      case 'offer':
      case 'promo':
        return Icons.local_offer_rounded;
      case 'reminder':
        return Icons.alarm_rounded;
      case 'system':
        return Icons.settings_suggest_rounded;
      case 'alert':
        return Icons.warning_amber_rounded;
      default:
        return Icons.notifications_rounded;
    }
  }

  String _timeAgo(DateTime? date) {
    if (date == null) return '';
    final diff = DateTime.now().difference(date);

    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final isUnread = !notification.isRead;
    final createdAt = notification.createdAt?.toDate();

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isUnread ? primaryColor.withOpacity(0.045) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isUnread
              ? primaryColor.withOpacity(0.25)
              : Colors.grey.shade200,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  primaryColor.withOpacity(0.9),
                  primaryColor.withOpacity(0.6),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Icon(
              _iconForType(notification.type),
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        notification.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight:
                          isUnread ? FontWeight.w700 : FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    if (isUnread)
                      Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.only(left: 6),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: primaryColor,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  notification.message,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _timeAgo(createdAt),
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade400,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}