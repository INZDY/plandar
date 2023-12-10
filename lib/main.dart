import 'package:fitgap/src/common_widgets/snackbar.dart';
import 'package:fitgap/src/features/authentication/applications/auth_page.dart';
import 'package:fitgap/src/utils/notification/notification.dart';
import 'package:fitgap/theme.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fitgap/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await NotificationService().initNotifications();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  static final navigatorKey = GlobalKey<NavigatorState>();

  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: SnackbarUtil.messengerKey,
      navigatorKey: MyApp.navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      home: const AuthPage(),
    );
  }
}
