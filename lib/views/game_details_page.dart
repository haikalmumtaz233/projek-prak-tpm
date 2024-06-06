import 'package:flutter/material.dart';
import 'package:game_galaxy/db/local.dart';
import 'package:game_galaxy/models/game_model.dart';
import 'package:url_launcher/url_launcher.dart';

class GameDetailsPage extends StatefulWidget {
  final Game game;

  const GameDetailsPage({Key? key, required this.game}) : super(key: key);

  @override
  _GameDetailsPageState createState() => _GameDetailsPageState();
}

class _GameDetailsPageState extends State<GameDetailsPage> {
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkFavoriteStatus();
  }

  Future<void> _checkFavoriteStatus() async {
    final List<int> favorites = await SaveToLocalDb.getFavorites();
    setState(() {
      _isFavorite = favorites.contains(widget.game.id);
    });
  }

  Future<void> _toggleFavorite() async {
    final List<int> favorites = await SaveToLocalDb.getFavorites();

    setState(() {
      if (_isFavorite) {
        favorites.remove(widget.game.id);
      } else {
        favorites.add(widget.game.id!);
      }
      _isFavorite = !_isFavorite;
    });

    await SaveToLocalDb.saveFavorites(favorites);
  }

  Future<void> _launchedUrl(String url) async {
    final Uri _url = Uri.parse(url);
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                widget.game.title ?? "",
                style: TextStyle(color: Colors.white),
              ),
              background: Image.network(
                widget.game.thumbnail!,
                fit: BoxFit.cover,
              ),
            ),
            backgroundColor: Colors.red,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context, _isFavorite);
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () async {
                  await _toggleFavorite();
                  ScaffoldMessenger.of(context).showMaterialBanner(
                    MaterialBanner(
                      content: Text(
                        _isFavorite
                            ? 'Added to Favorites'
                            : 'Removed from Favorites',
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: _isFavorite ? Colors.green : Colors.red,
                      actions: [
                        TextButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context)
                                .hideCurrentMaterialBanner();
                          },
                          child: Text(
                            'Dismiss',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                icon: Icon(
                  Icons.favorite,
                  color: _isFavorite ? Colors.green : Colors.white,
                ),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ExpansionTile(
                    title: Text(
                      'Genre',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    children: [
                      ListTile(
                        title: Text(
                          widget.game.genre ?? "N/A",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  ExpansionTile(
                    title: Text(
                      'Developer',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    children: [
                      ListTile(
                        title: Text(
                          widget.game.developer ?? "N/A",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  ExpansionTile(
                    title: Text(
                      'Publisher',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    children: [
                      ListTile(
                        title: Text(
                          widget.game.publisher ?? "N/A",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  ExpansionTile(
                    title: Text(
                      'Platform',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    children: [
                      ListTile(
                        title: Text(
                          widget.game.platform ?? "N/A",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  ExpansionTile(
                    title: Text(
                      'Release Date',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    children: [
                      ListTile(
                        title: Text(
                          widget.game.releaseDate ?? "N/A",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  ExpansionTile(
                    title: Text(
                      'Description',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    children: [
                      ListTile(
                        title: Text(
                          widget.game.shortDescription ?? "N/A",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _launchedUrl(widget.game.freetogameProfileUrl ?? "");
        },
        child: Icon(
          Icons.web_asset,
          color: Colors.white,
        ),
        backgroundColor: Colors.red,
      ),
    );
  }
}
