import 'package:flutter/widgets.dart';
import 'package:restaurants_app/services/local_notification_service.dart';

class LocalNotificationProvider extends ChangeNotifier{
  final LocalNotificationService flutterNotificationService;
  LocalNotificationProvider(this.flutterNotificationService);

  static const int _dailyId = 1;

  Future<void> showNotificationNow() async {
    await flutterNotificationService.showRestaurantNotificationNow(id: _dailyId);
  }

  Future<void> scheduleDailyReminder() async {
    await flutterNotificationService.scheduleDailyReminder(id: _dailyId);
  }

  Future<void> cancelDailyReminder() async{
    await flutterNotificationService.cancelReminder(_dailyId);
  }
}