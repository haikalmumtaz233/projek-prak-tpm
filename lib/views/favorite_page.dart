import 'package:flutter/material.dart';
import 'dart:async';
import 'package:game_galaxy/db/local.dart';
import 'package:game_galaxy/models/game_model.dart';
import 'package:game_galaxy/api/api_data_source.dart';
import 'package:game_galaxy/views/notification_page.dart';
import 'package:game_galaxy/views/game_details_page.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  late StreamController<List<Game>> _favoriteGamesController;
  late List<Game> _favoriteGames;

  @override
  void initState() {
    super.initState();
    _favoriteGames = [];
    _favoriteGamesController = StreamController<List<Game>>.broadcast();
    _loadFavoriteGames();
  }

  Future<void> _loadFavoriteGames() async {
    try {
      final List<int> favoriteIds = await SaveToLocalDb.getFavorites();
      final List<Game> allGames = await ApiDataSource.instance.loadGames();

      final List<Game> favoriteGames =
          allGames.where((game) => favoriteIds.contains(game.id)).toList();

      setState(() {
        _favoriteGames = favoriteGames;
      });
      _favoriteGamesController.add(_favoriteGames);
    } catch (error) {
      print('Error loading favorite games: $error');
    }
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final Game game = _favoriteGames.removeAt(oldIndex);
      _favoriteGames.insert(newIndex, game);
    });
    _favoriteGamesController.add(_favoriteGames);
  }

  @override
  void dispose() {
    _favoriteGamesController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(
          'Favorites',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const NotificationPage()),
              );
            },
            icon: Icon(Icons.notifications, color: Colors.white),
          ),
        ],
      ),
      body: StreamBuilder<List<Game>>(
        stream: _favoriteGamesController.stream,
        initialData: _favoriteGames,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'No favorite games yet.',
                style: TextStyle(fontSize: 18, color: Colors.black54),
              ),
            );
          }

          final List<Game> favoriteGames = snapshot.data!;
          return ReorderableListView.builder(
            itemCount: favoriteGames.length,
            itemBuilder: (context, index) {
              final Game game = favoriteGames[index];
              return ListTile(
                key: ValueKey(game.id),
                title: Text(game.title ?? ""),
                subtitle: Text(game.genre ?? ""),
                leading: Image.network(
                  game.thumbnail ?? "",
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GameDetailsPage(game: game),
                    ),
                  );
                  if (result == true) {
                    _loadFavoriteGames(); // Reload favorite games when a change is made
                  }
                },
              );
            },
            onReorder: _onReorder,
          );
        },
      ),
    );
  }
}
