class ShowData {
  final String name;
  final double rating;
  final int rating_count;
  final int releaseYear;
  final List<String> genres;
  final String status;
  final String description;
  final List<String> pictureUrls;

  ShowData({
    required this.name,
    required this.rating,
    required this.rating_count,
    required this.releaseYear,
    required this.genres,
    required this.status,
    required this.description,
    required this.pictureUrls,
  });

  // Factory method to create ShowData object from JSON
  factory ShowData.fromJson(Map<String, dynamic> json) {
    double rating = double.parse(json['rating'].toString());
    double parsedRating = double.parse(rating.toStringAsFixed(1));

    int releaseYear;
    try {
      releaseYear = DateTime.parse(json['start_date']).year;
    } catch (e) {
      releaseYear = 0;
    }

    return ShowData(
      name: json['name'].toString(),
      rating: parsedRating,
      rating_count: int.parse(json['rating_count']),
      releaseYear: releaseYear,
      genres: List<String>.from(json['genres']),
      status: json['status'].toString(),
      description: json['description'].toString(),
      pictureUrls: List<String>.from([json['image_path']] + json['pictures']),
    );
  }
}
