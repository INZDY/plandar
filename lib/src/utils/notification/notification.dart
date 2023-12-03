import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:fitgap/main.dart';
import 'package:fitgap/src/features/authentication/applications/auth_page.dart';
import 'package:fitgap/src/utils/notification/notification_application.dart';
import 'package:flutter/material.dart';

class NotificationService {
  //initialization
  Future<void> initNotifications() async {
    await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelGroupKey: 'high_importance_channel',
          // channelKey: 'high_importance_channel',
          channelKey: 'scheduled',
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic tests',
          // defaultColor: const Color(0xFF9D50DD),
          // ledColor: Colors.white,
          importance: NotificationImportance.Max,
          channelShowBadge: true,
          onlyAlertOnce: true,
          playSound: true,
          // criticalAlerts: true,
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

  /// Use this method to detect when the user taps on a notification or action button
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
  Future<void> scheduleNotifcation(int hours) async {
    debugPrint(await showEvent('event'));

    // String localTimezone =
    //     await AwesomeNotifications().getLocalTimeZoneIdentifier();
    // String utcTimezone =
    //     await AwesomeNotifications().getLocalTimeZoneIdentifier();

    //upcoming event
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 1,
        channelKey: 'scheduled',
        title: await showEvent('title'),
        body: await showEvent('event'),
        notificationLayout: NotificationLayout.BigText,
        largeIcon: await showEvent('weather'),
        wakeUpScreen: true,
        timeoutAfter: const Duration(hours: 12),
        showWhen: true,
        displayOnForeground: true,
        displayOnBackground: true,
      ),
      schedule: NotificationInterval(
        interval: 3600 * hours,
        repeats: true,
        allowWhileIdle: true,
      ),
    );
  }

  Future<void> daily() async {
    debugPrint(await showEvent('event'));

    // String localTimezone =
    //     await AwesomeNotifications().getLocalTimeZoneIdentifier();
    // String utcTimezone =
    //     await AwesomeNotifications().getLocalTimeZoneIdentifier();

    //daily reminder
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 0,
        channelKey: 'scheduled',
        title: await dailyReminder('title'),
        body: await dailyReminder('body'),
        notificationLayout: NotificationLayout.Default,
        largeIcon: 'asset://assets/icons/applogo.png',
        wakeUpScreen: true,
        timeoutAfter: const Duration(hours: 12),
        showWhen: true,
        displayOnForeground: true,
        displayOnBackground: true,
      ),
      schedule: NotificationCalendar(
        hour: 0,
        minute: 0,
        repeats: true,
        allowWhileIdle: true,
      ),
    );
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
