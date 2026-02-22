import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class LocalNotificationService {
  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;

    const androidSettings = AndroidInitializationSettings('@drawable/icon');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(settings);

    // timezone
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));

    _isInitialized = true;
  }

  Future<void> showRestaurantNotificationNow({
    int id = 0,
    String title = 'Restaurant Notification',
    String body = ' Reminder will ring at 11:00 AM',
    String payload = 'Daily reminder',
  }) async {
    await init();
    final androidDetails = AndroidNotificationDetails(
      'restaurant_channel',
      'Restaurant Reminder',
      channelDescription: 'Restaurant Notification',
      importance: Importance.max,
      priority: Priority.high,
      icon: '@drawable/icon'
    );

    const iosDetails = DarwinNotificationDetails();

    final details = NotificationDetails(android: androidDetails, iOS: iosDetails);

    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      details,
      payload: payload,
    );
  }

  
  tz.TZDateTime _nextInstanceofElevenAM() {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, 11, 0);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  Future<void> scheduleDailyReminder({required int id}) async {
    await init();

    final scheduledDate = _nextInstanceofElevenAM();
    print("Now       : ${tz.TZDateTime.now(tz.local)}");
    print("Scheduled : $scheduledDate for ID $id");

    const androidDetails = AndroidNotificationDetails(
      'restaurant_channel',
      'Restaurant Reminder',
      channelDescription: 'Restaurant Notification',
      importance: Importance.max,
      priority: Priority.high,
    );

    const details = NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      'Restaurant',
      'Recommendation restaurant for you',
      scheduledDate,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> cancelReminder(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }
}