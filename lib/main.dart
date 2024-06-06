import 'package:flutter/material.dart';
import 'package:game_galaxy/components/onboarding/onboarding_view.dart';
import 'package:game_galaxy/db/local.dart';
import 'package:game_galaxy/models/users.dart';
import 'package:game_galaxy/views/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(UsersAdapter());
  final prefs = await SharedPreferences.getInstance();
  final onboarding = prefs.getBool("onboarding") ?? false;
  await SaveToLocalDb.init();

  runApp(MyApp(onboarding: onboarding));
}

class MyApp extends StatelessWidget {
  final bool onboarding;
  const MyApp({super.key, this.onboarding = false});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Game Galaxy',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: onboarding ? const LoginPage() : const OnboardingView(),
    );
  }
}
