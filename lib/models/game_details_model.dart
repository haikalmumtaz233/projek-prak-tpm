class GameDetails {
  final int? id;
  final String? title;
  final String? thumbnail;
  final String? status;
  final String? shortDescription;
  final String? description;
  final String? gameUrl;
  final String? genre;
  final String? platform;
  final String? publisher;
  final String? developer;
  final String? releaseDate;
  final String? freetogameProfileUrl;
  final MinimumSystemRequirements? minimumSystemRequirements;
  final List<Screenshots>? screenshots;

  GameDetails({
    this.id,
    this.title,
    this.thumbnail,
    this.status,
    this.shortDescription,
    this.description,
    this.gameUrl,
    this.genre,
    this.platform,
    this.publisher,
    this.developer,
    this.releaseDate,
    this.freetogameProfileUrl,
    this.minimumSystemRequirements,
    this.screenshots,
  });

  GameDetails.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        title = json['title'] as String?,
        thumbnail = json['thumbnail'] as String?,
        status = json['status'] as String?,
        shortDescription = json['short_description'] as String?,
        description = json['description'] as String?,
        gameUrl = json['game_url'] as String?,
        genre = json['genre'] as String?,
        platform = json['platform'] as String?,
        publisher = json['publisher'] as String?,
        developer = json['developer'] as String?,
        releaseDate = json['release_date'] as String?,
        freetogameProfileUrl = json['freetogame_profile_url'] as String?,
        minimumSystemRequirements =
            (json['minimum_system_requirements'] as Map<String, dynamic>?) !=
                    null
                ? MinimumSystemRequirements.fromJson(
                    json['minimum_system_requirements'] as Map<String, dynamic>)
                : null,
        screenshots = (json['screenshots'] as List?)
            ?.map(
                (dynamic e) => Screenshots.fromJson(e as Map<String, dynamic>))
            .toList();

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'thumbnail': thumbnail,
        'status': status,
        'short_description': shortDescription,
        'description': description,
        'game_url': gameUrl,
        'genre': genre,
        'platform': platform,
        'publisher': publisher,
        'developer': developer,
        'release_date': releaseDate,
        'freetogame_profile_url': freetogameProfileUrl,
        'minimum_system_requirements': minimumSystemRequirements?.toJson(),
        'screenshots': screenshots?.map((e) => e.toJson()).toList()
      };
}

class MinimumSystemRequirements {
  final String? os;
  final String? processor;
  final String? memory;
  final String? graphics;
  final String? storage;

  MinimumSystemRequirements({
    this.os,
    this.processor,
    this.memory,
    this.graphics,
    this.storage,
  });

  MinimumSystemRequirements.fromJson(Map<String, dynamic> json)
      : os = json['os'] as String?,
        processor = json['processor'] as String?,
        memory = json['memory'] as String?,
        graphics = json['graphics'] as String?,
        storage = json['storage'] as String?;

  Map<String, dynamic> toJson() => {
        'os': os,
        'processor': processor,
        'memory': memory,
        'graphics': graphics,
        'storage': storage
      };
}

class Screenshots {
  final int? id;
  final String? image;

  Screenshots({
    this.id,
    this.image,
  });

  Screenshots.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        image = json['image'] as String?;

  Map<String, dynamic> toJson() => {'id': id, 'image': image};
}
