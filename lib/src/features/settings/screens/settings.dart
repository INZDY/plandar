import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:fitgap/src/common_widgets/snackbar.dart';
import 'package:fitgap/src/features/authentication/models/auth_button_withtext.dart';
import 'package:fitgap/src/features/profile/screens/profile.dart';
import 'package:fitgap/src/utils/auth/auth.dart';
import 'package:fitgap/src/utils/notification/notification.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  //get notification status
  late bool isDailyNoti = false;
  late bool isScheduledNoti = false;
  late int notificationInterval = 1;

  void getNotificationStatus() async {
    final notificationList =
        await NotificationService().retrieveScheduledNotifications();
    setState(() {
      for (NotificationModel noti in notificationList) {
        if (noti.content?.id == 0) {
          isDailyNoti = true;
        } else if (noti.content?.id == 1) {
          isScheduledNoti = true;
        }
      }
    });
  }

  Future<void> _loadSavedSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      notificationInterval = prefs.getInt('notification_interval') ?? 1;
    });
  }

  Future<void> _saveSettings(int notificationInterval) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setInt('notification_interval', notificationInterval);

    SnackbarUtil.showSnackBar(
        'Notification interval set to $notificationInterval hours');
  }

  @override
  void initState() {
    super.initState();
    getNotificationStatus();
    _loadSavedSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        toolbarHeight: 90,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.chevron_left),
          color: Colors.white,
        ),
        title: const Text(
          'Settings',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Color.fromRGBO(7, 2, 58, 1)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(50),
            topRight: Radius.circular(50),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 40),
            color: const Color(0xFF2B1A6D),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                //Account section
                const Text(
                  'Account',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

                //profile
                ListTile(
                  leading: Text(
                    'Profile',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  trailing:
                      const Icon(Icons.chevron_right, color: Colors.white),
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const Profile(),
                  )),
                ),
                const Divider(
                  thickness: 1,
                  height: 50,
                  color: Colors.white,
                ),

                //Settings section
                const Text(
                  'Settings',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

                //daily notification
                ListTile(
                  leading: Text(
                    'Daily Notification',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  trailing: Switch(
                    value: isDailyNoti,
                    onChanged: (bool value) async {
                      setState(() {
                        isDailyNoti = value;
                      });
                      if (isDailyNoti) {
                        await NotificationService().daily();
                      } else {
                        await NotificationService().cancelNotification(0);
                        SnackbarUtil.showSnackBar('Daily Notification off');
                      }
                    },
                  ),
                ),

                //interval notification
                ListTile(
                  leading: Text(
                    'Event Notification',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  trailing: Switch(
                    value: isScheduledNoti,
                    onChanged: (bool value) async {
                      setState(() {
                        isScheduledNoti = value;
                      });
                      if (isScheduledNoti) {
                        await NotificationService()
                            .scheduleNotifcation(notificationInterval);
                      } else {
                        await NotificationService().cancelNotification(1);
                        SnackbarUtil.showSnackBar(
                            'Upcoming Event Notification off');
                      }
                    },
                  ),
                ),

                //time select
                ListTile(
                    leading: Text(
                      'Notify Interval',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    trailing: DropdownButton<int>(
                      dropdownColor: const Color.fromRGBO(7, 2, 58, 1),
                      value: notificationInterval,
                      onChanged: (value) async {
                        setState(() {
                          notificationInterval = value!;
                        });
                        _saveSettings(notificationInterval);

                        if (isScheduledNoti) {
                          //cancel and reschedule
                          await NotificationService().cancelNotification(1);
                          await NotificationService()
                              .scheduleNotifcation(notificationInterval);
                        }
                      },
                      items:
                          [1, 3, 5, 7].map<DropdownMenuItem<int>>((int value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Text(
                            '$value hours',
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      }).toList(),
                    )),

                const Divider(
                  thickness: 1,
                  height: 50,
                  color: Colors.white,
                ),

                const Spacer(),
                //Logout Section
                Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    gradient: LinearGradient(
                        colors: [Color(0xFF5936B4), Color(0xFF362A84)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter),
                  ),
                  height: 55,
                  child: AuthButtonIconText(
                    color: Colors.transparent,
                    icon: Icons.logout,
                    text: 'Log Out',
                    logMethod: AuthService().signOut,
                  ),
                ),

                //noti debug, remove when finish
                // ElevatedButton(
                //   onPressed: () async {
                //     List<NotificationModel> notilist =
                //         await NotificationService()
                //             .retrieveScheduledNotifications();
                //     debugPrint('${notilist.length}');
                //     for (NotificationModel noti in notilist) {
                //       debugPrint('${noti.content?.id}');
                //       debugPrint(noti.content?.title);
                //     }
                //   },
                //   child: const Text('Noti List'),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
