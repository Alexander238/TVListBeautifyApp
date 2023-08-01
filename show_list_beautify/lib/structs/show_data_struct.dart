class ShowData {
  final String name;
  final double rating;
  final int ratingCount;
  final int releaseYear;
  final List<String> genres;
  final String status;
  final String description;
  final List<String> pictureUrls;

  ShowData({
    required this.name,
    required this.rating,
    required this.ratingCount,
    required this.releaseYear,
    required this.genres,
    required this.status,
    required this.description,
    required this.pictureUrls,
  });

  factory ShowData.fromJson(Map<String, dynamic> jsonData) {
    List<dynamic> genreList = jsonData['genres'] ?? [];
    List<String> genres =
        genreList.map((genre) => genre['name'].toString()).toList();

    List<String> pictureUrls = [];
    String tempName = "";
    String firstAirDate = "";

    if (jsonData.containsKey('seasons')) {
      List<dynamic> elements = jsonData['seasons'] ?? [];
      List<String> pictureUrls = elements
          // maybe the contains is a bad idea, maybe must be changed later
          .where((season) => season['name'] != "Specials")
          .map((season) =>
              "https://image.tmdb.org/t/p/w500${season['poster_path']}")
          .toList();

      List<String> specialUrls = elements
          // maybe the contains is a bad idea, maybe must be changed later
          .where((season) => season['name'] == "Specials")
          .map((season) =>
              "https://image.tmdb.org/t/p/w500${season['poster_path']}")
          .toList();

      pictureUrls.addAll(specialUrls);

      //name
      tempName = jsonData['name'] ?? "Error";

      //date
      firstAirDate = jsonData['first_air_date'] ?? "";
    } else {
      String thumbnailUrl = "";
      if (jsonData['poster_path'] != null) {
        String modifiedURL = jsonData['poster_path'];
        thumbnailUrl = "https://image.tmdb.org/t/p/w500$modifiedURL";
      }
      pictureUrls.add(thumbnailUrl);

      //name
      tempName = jsonData['original_title'] ?? "Error";
      
      //date
      firstAirDate = jsonData['release_date'] ?? "";
    }

    double newRating = jsonData['vote_average'] ?? 0.0;
    newRating = (newRating * 10).round() / 10;

    int releaseYear = 0;
    if (firstAirDate.length >= 4) {
      String yearString = firstAirDate.substring(0, 4);
      releaseYear = int.tryParse(yearString) ?? 0;
    }

    return ShowData(
      name: tempName,
      rating: newRating,
      ratingCount: jsonData['vote_count'] ?? 0,
      releaseYear: releaseYear,
      genres: genres,
      status: jsonData['status'] ?? "Error",
      description: jsonData['overview'] ?? "Error",
      pictureUrls: pictureUrls,
    );
  }
}
