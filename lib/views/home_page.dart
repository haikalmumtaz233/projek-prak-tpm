import 'dart:math';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:game_galaxy/components/widget/new_games_widget.dart';
import 'package:game_galaxy/models/game_model.dart';
import 'package:game_galaxy/api/api_data_source.dart';
import 'package:game_galaxy/utils/border.dart';
import 'package:game_galaxy/utils/styles.dart';
import 'package:game_galaxy/utils/color.dart';
import 'package:game_galaxy/views/game_details_page.dart';
import 'package:game_galaxy/views/notification_page.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(
          'Game Galaxy',
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
      body: Container(
        width: width,
        height: height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              backGroundColor1,
              backGroundColor2,
            ],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: height * 0.02),
              Center(
                child: Container(
                  width: width * 0.9,
                  height: height * 0.06,
                  padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: getBorderRadiusWidget(context, 0.03),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: TypeAheadFormField<Game>(
                    textFieldConfiguration: TextFieldConfiguration(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Search games',
                        hintStyle: textStyle12.copyWith(color: Colors.grey),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.blueAccent,
                          size: width * 0.07,
                        ),
                      ),
                      style: textStyle12.copyWith(color: Colors.black),
                    ),
                    suggestionsCallback: (pattern) async {
                      return await ApiDataSource.instance.searchGames(pattern);
                    },
                    itemBuilder: (context, Game suggestion) {
                      return ListTile(
                        leading: suggestion.thumbnail != null
                            ? Image.network(
                                suggestion.thumbnail!,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              )
                            : Icon(Icons.videogame_asset),
                        title: Text(suggestion.title ?? ''),
                        subtitle: Text(suggestion.genre ?? ''),
                      );
                    },
                    onSuggestionSelected: (Game suggestion) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              GameDetailsPage(game: suggestion),
                        ),
                      );
                    },
                    noItemsFoundBuilder: (context) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'No games found',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: height * 0.01),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: width * 0.03,
                  vertical: height * 0.02,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Trending',
                      style: textStyle2,
                    ),
                  ],
                ),
              ),
              FutureBuilder<List<Game>>(
                future: ApiDataSource.instance.loadGames(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text("No games available"));
                  }

                  final games = snapshot.data!;
                  games.shuffle(Random());
                  final trendingGames = games.take(3).toList();

                  return CarouselSlider(
                    options: CarouselOptions(
                      height: height * 0.25,
                      autoPlay: true,
                      enlargeCenterPage: true,
                      aspectRatio: 16 / 9,
                      enableInfiniteScroll: true,
                      viewportFraction: 0.8,
                    ),
                    items: trendingGames.map((game) {
                      return Builder(
                        builder: (BuildContext context) {
                          return _buildGameItem(context, game);
                        },
                      );
                    }).toList(),
                  );
                },
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: width * 0.03,
                  vertical: height * 0.02,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'New Games',
                      style: textStyle2,
                    ),
                  ],
                ),
              ),
              Container(
                width: width,
                height: height,
                child: FutureBuilder<List<Game>>(
                  future: ApiDataSource.instance.loadGames(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text("No games available"));
                    }

                    final games = snapshot.data!;
                    games.shuffle(Random());
                    final limitedGames = games.take(15).toList();

                    return ListView.builder(
                      padding: EdgeInsets.all(width * 0.02),
                      itemCount: limitedGames.length,
                      itemBuilder: (context, index) {
                        final game = limitedGames[index];
                        return _buildGameItem(context, game);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGameItem(BuildContext context, Game game) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GameDetailsPage(game: game),
          ),
        );
      },
      child: NewGamesWidget(
        width: width,
        height: height,
        imageName: game.thumbnail!,
        name: game.title!,
        genre: game.genre!,
        platform: game.platform!,
      ),
    );
  }
}
