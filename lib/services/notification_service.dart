import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import '../models/loyalty_card.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    const initSettings = InitializationSettings(android: androidSettings, iOS: iosSettings);

    await _notifications.initialize(initSettings);
    tz.initializeTimeZones();
  }

  Future<void> scheduleExpiryNotification(LoyaltyCard card) async {
    if (card.expiryDate == null) return;

    final daysUntilExpiry = card.expiryDate!.difference(DateTime.now()).inDays;
    if (daysUntilExpiry <= 7) {
      await _notifications.zonedSchedule(
        card.id.hashCode,
        'Card Expiring Soon',
        'Your ${card.cardName} card will expire in $daysUntilExpiry days',
        _nextInstanceOfTime(9, 0),
        NotificationDetails(
          android: AndroidNotificationDetails(
            'card_expiry',
            'Card Expiry Notifications',
            channelDescription: 'Notifications for expiring loyalty cards',
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: const DarwinNotificationDetails(),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    }
  }

  Future<void> schedulePointsNotification(LoyaltyCard card) async {
    if (card.points >= 1000) {
      await _notifications.zonedSchedule(
        card.id.hashCode + 1,
        'Points Milestone',
        'You have ${card.points} points on your ${card.cardName} card!',
        _nextInstanceOfTime(9, 0),
        NotificationDetails(
          android: AndroidNotificationDetails(
            'points_milestone',
            'Points Milestone Notifications',
            channelDescription: 'Notifications for points milestones',
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: const DarwinNotificationDetails(),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    }
  }

  Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
} 