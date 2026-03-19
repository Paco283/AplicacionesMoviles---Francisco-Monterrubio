import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../models/class_model.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    tz.initializeTimeZones();

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');

    const settings = InitializationSettings(android: android);

    await _notifications.initialize(settings);

    // 🔥 Permiso Android 13+
    await _notifications
    .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
    ?.requestNotificationsPermission();
  }

  static Future<void> scheduleClassNotification(SchoolClass c) async {
    final weekday = _convertDayToWeekday(c.day);
    final now = DateTime.now();

    DateTime scheduled = DateTime(
      now.year,
      now.month,
      now.day,
      c.startHour,
    );

    while (scheduled.weekday != weekday || scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    scheduled = scheduled.subtract(const Duration(minutes: 5));

    final tzDate = tz.TZDateTime.from(scheduled, tz.local);

    await _notifications.zonedSchedule(
      c.hashCode,
      "Tu clase está por iniciar",
      "${c.name} comienza en 5 minutos",
      tzDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'schedule_channel',
          'Horario',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents:
          DateTimeComponents.dayOfWeekAndTime,
    );
  }

  static Future<void> cancelNotification(SchoolClass c) async {
    await _notifications.cancel(c.hashCode);
  }

  static int _convertDayToWeekday(String day) {
    switch (day) {
      case "Lunes":
        return DateTime.monday;
      case "Martes":
        return DateTime.tuesday;
      case "Miércoles":
        return DateTime.wednesday;
      case "Jueves":
        return DateTime.thursday;
      case "Viernes":
        return DateTime.friday;
      default:
        return DateTime.monday;
    }
  }
}