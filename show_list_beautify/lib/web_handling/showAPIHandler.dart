import 'dart:convert';
import 'package:flutter/cupertino.dart';
import '../widgets/list_element.dart';
import 'package:http/http.dart' as http;


const String errURL = "https://previews.123rf.com/images/ivanburchak/ivanburchak1906/ivanburchak190600253/125651894-404-page-not-found-design-template-big-red-404-numbers-on-the-shelf-404-error-page-concept-vector.jpg";

String buildURL(String name) {
  String modifiedName = name.replaceAll(' ', '+').trim();
  return "https://www.episodate.com/api/search?q=" + modifiedName + "&page=1";
}

Future<String> getImageUrl(String url) async {
  if (url.isEmpty) {
    return Future.value(errURL);
  }

  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    return url;
  } else {
    return errURL;
    }
}

Future<Widget> fetchDataByName(String name) async {
  String url = buildURL(name);
  Map<String, dynamic> jsonData = {};
  try {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }

  

  String thumbnailUrl = findThumbnailUrl(jsonData, name);

  return NamedPictureCard(
    name: name,
    onTap: () => {},
    image: getImageUrl(thumbnailUrl),
  );
}

String findThumbnailUrl(Map<String, dynamic> jsonData, String name) {
  List<dynamic> tvShows = jsonData['tv_shows'];

  for (var tvShow in tvShows) {
    String showName = tvShow['name'];
    if (name.toLowerCase() == showName.toLowerCase()) {
      return tvShow['image_thumbnail_path'];
    }
  }

  // If no exact match, return the thumbnail URL of the first result (if available)
  if (tvShows.isNotEmpty) {
    return tvShows[0]['image_thumbnail_path'];
  }

  return ''; // Return empty string if no TV shows found
}

