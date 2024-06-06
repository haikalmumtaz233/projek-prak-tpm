import 'dart:async';
import 'package:game_galaxy/models/game_model.dart';
import 'base_network.dart';

class ApiDataSource {
  static final ApiDataSource instance = ApiDataSource._internal();

  ApiDataSource._internal();

  List<Game> _allGames = [];
  bool _gamesLoaded = false;

  Future<List<Game>> loadGames() async {
    if (_gamesLoaded) return _allGames;

    final List<dynamic> response = await BaseNetwork.get('games');
    _allGames = response.map((json) => Game.fromJson(json)).toList();

    _gamesLoaded = true;

    return _allGames;
  }

  List<Game> searchGames(String pattern) {
    if (!_gamesLoaded) {
      throw Exception('Games are not loaded. Call loadGames() first.');
    }

    return _allGames.where((game) {
      return game.title!.toLowerCase().contains(pattern.toLowerCase()) ||
          game.genre!.toLowerCase().contains(pattern.toLowerCase()) ||
          game.platform!.toLowerCase().contains(pattern.toLowerCase());
    }).toList();
  }
}
