import 'package:flutter/material.dart';
import 'package:game_galaxy/components/widget/tab_item.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:game_galaxy/models/game_model.dart';
import 'package:game_galaxy/db/local.dart';
import 'package:game_galaxy/api/api_data_source.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<String> _notifications = [];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    try {
      final List<int> favoriteIds = await SaveToLocalDb.getFavorites();
      final List<Game> allGames = await ApiDataSource.instance.loadGames();

      // Filter favorite games based on IDs
      final List<Game> favoriteGames =
          allGames.where((game) => favoriteIds.contains(game.id)).toList();

      for (var game in favoriteGames) {
        _addNotification('${game.title} is added to favorites');
      }
    } catch (error) {
      print('Error loading notifications: $error');
    }
  }

  void _addNotification(String notification) {
    setState(() {
      _notifications.insert(0, notification);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Notifications',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(40),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              child: Container(
                height: 40,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  color: Colors.red.shade100,
                ),
                child: TabBar(
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  indicator: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.black54,
                  tabs: [
                    TabItem(
                      title: 'Inbox',
                      count: _notifications.length,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: ListView.builder(
          itemCount: _notifications.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(_notifications[index]),
            );
          },
        ),
      ),
    );
  }
}
