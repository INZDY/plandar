import 'package:fitgap/src/common_widgets/snackbar.dart';
import 'package:fitgap/src/features/home/home.dart';
import 'package:fitgap/theme.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fitgap/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        scaffoldMessengerKey: SnackbarUtil.messengerKey,
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        theme: appTheme,
        home: const Home());
  }
}
