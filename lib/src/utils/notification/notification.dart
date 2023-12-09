import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:fitgap/main.dart';
import 'package:fitgap/src/common_widgets/snackbar.dart';
import 'package:fitgap/src/features/authentication/applications/auth_page.dart';
import 'package:fitgap/src/utils/notification/notification_application.dart';
import 'package:flutter/material.dart';

class NotificationService {
  //initialization
  Future<void> initNotifications() async {
    await AwesomeNotifications().initialize(
      'resource://drawable/applogo',
      [
        NotificationChannel(
          channelGroupKey: 'high_importance_channel',
          channelKey: 'scheduled',
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic tests',
          importance: NotificationImportance.Max,
          channelShowBadge: true,
          onlyAlertOnce: true,
          playSound: true,
          enableVibration: true,
        )
      ],
      channelGroups: [
        NotificationChannelGroup(
          channelGroupKey: 'high_importance_channel_group',
          channelGroupName: 'Group 1',
        )
      ],
      debug: true,
    );

    await AwesomeNotifications()
        .isNotificationAllowed()
        .then((isAllowed) async {
      if (!isAllowed) {
        await AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });

    await AwesomeNotifications().setListeners(
      onActionReceivedMethod: onActionReceivedMethod,
      onNotificationCreatedMethod: onNotificationCreatedMethod,
      onNotificationDisplayedMethod: onNotificationDisplayedMethod,
      onDismissActionReceivedMethod: onDismissActionReceivedMethod,
    );
  }

  /// Use this method to detect when a new notification or a schedule is created
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {
    debugPrint('onNotificationCreatedMethod');
  }

  /// Use this method to detect every time that a new notification is displayed
  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {
    debugPrint('onNotificationDisplayedMethod');
  }

  /// Use this method to detect if the user dismissed a notification
  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {
    debugPrint('onDismissActionReceivedMethod');
  }

  /// Use this method to detect when the user taps on a notification or action butto
  /// tap noti -> authentication -> if logged in will redirect to home automatically
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    debugPrint('onActionReceivedMethod');
    final payload = receivedAction.payload ?? {};
    if (payload["navigate"] == "true") {
      MyApp.navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (_) => const AuthPage(),
        ),
      );
    }
  }

  //-------------------------------------
  //Scheduling Notifications-------------
  //-------------------------------------
  //upcoming event
  Future<void> scheduleNotifcation(int hours) async {
    await AwesomeNotifications().createNotification(
      content: await showEvent(hours),
      schedule: NotificationInterval(
        interval: 3600 * hours,
        repeats: true,
        allowWhileIdle: true,
      ),
    );
    SnackbarUtil.showSnackBar('Upcoming Event Notification on');
  }

  //daily reminder
  Future<void> daily() async {
    await AwesomeNotifications().createNotification(
      content: await dailyReminder(),
      schedule: NotificationCalendar(
        hour: 0,
        minute: 0,
        second: 0,
        repeats: true,
        allowWhileIdle: true,
      ),
    );
    SnackbarUtil.showSnackBar('Daily Notification on');
  }

  //-------------------------------------
  //Functionalities----------------------
  //-------------------------------------
  Future<void> cancelNotification(int id) async {
    await AwesomeNotifications().cancel(id);
  }

  Future<List<NotificationModel>> retrieveScheduledNotifications() async {
    final AwesomeNotifications awesomeNotifications = AwesomeNotifications();
    List<NotificationModel> scheduledNotifications =
        await awesomeNotifications.listScheduledNotifications();
    return scheduledNotifications;
  }
}
