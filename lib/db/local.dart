import 'package:shared_preferences/shared_preferences.dart';

class SaveToLocalDb {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<List<int>> getFavorites() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? favoriteString = prefs.getString('favorite_games');
    if (favoriteString == null) {
      return [];
    }
    return List<int>.from(favoriteString
        .split(',')
        .map((e) => int.tryParse(e) ?? 0)
        .where((id) => id != 0));
  }

  static Future<void> saveFavorites(List<int> favoriteIds) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('favorite_games', favoriteIds.join(','));
  }

  static Future<void> addFavorite(int gameId) async {
    final List<int> favoriteIds = await getFavorites();
    if (!favoriteIds.contains(gameId)) {
      favoriteIds.add(gameId);
      await saveFavorites(favoriteIds);
    }
  }

  static Future<void> removeFavorite(int gameId) async {
    final List<int> favoriteIds = await getFavorites();
    favoriteIds.remove(gameId);
    await saveFavorites(favoriteIds);
  }
}
