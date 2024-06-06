import 'package:flutter/material.dart';
import 'package:game_galaxy/views/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogoutPage extends StatefulWidget {
  const LogoutPage({Key? key}) : super(key: key);

  @override
  State<LogoutPage> createState() => _LogoutPageState();
}

class _LogoutPageState extends State<LogoutPage> {
  late SharedPreferences pref;

  void loadData() async {
    pref = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Clear session data
            pref.remove("logedIn");
            pref.remove("accIndex");

            // Navigate to LoginPage and remove the entire widget containing the tab viewer
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
              (route) => false,
            );
          },
          child: Text("Logout"),
        ),
      ),
    );
  }
}
