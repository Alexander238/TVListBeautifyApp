import 'dart:convert';
import 'package:flutter/material.dart';
import '../screens/detail_page.dart';
import '../structs/show_data_struct.dart';
import '../widgets/list_element.dart';
import 'package:http/http.dart' as http;

const String errURL =
    "https://previews.123rf.com/images/ivanburchak/ivanburchak1906/ivanburchak190600253/125651894-404-page-not-found-design-template-big-red-404-numbers-on-the-shelf-404-error-page-concept-vector.jpg";

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

Future<Widget> fetchDataByName(String name, context) async {
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

  Map<String, dynamic> showArray = findShowMap(jsonData, name);

  String thumbnailUrl =
      executeShowSearchByKey(showArray, name, "image_thumbnail_path");

  return NamedPictureCard(
    name: name,
    onTap: () => {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailPage(
            showNameID: (executeShowSearchByKey(showArray, name, "id").isEmpty)
                ? 0
                : int.parse(executeShowSearchByKey(showArray, name, "id")),
          ),
        ),
      )
    },
    image: getImageUrl(thumbnailUrl),
  );
}

String executeShowSearchByKey(
    Map<String, dynamic> showArray, String name, String key) {
  if (showArray.isNotEmpty) {
    return showArray[key].toString();
  }
  return "";
}

Map<String, dynamic> findShowMap(Map<String, dynamic> jsonData, String name) {
  List<dynamic> tvShows = jsonData['tv_shows'];

  for (var tvShow in tvShows) {
    String showName = tvShow['name'];
    if (name.toLowerCase() == showName.toLowerCase()) {
      return tvShow;
    }
  }

  // If no exact match, return the first result (if available)
  if (tvShows.isNotEmpty) {
    return tvShows[0];
  }

  return {}; // Return an empty map if no TV shows found
}

Future<ShowData> fetchDataByID(int id, context) async {
  String url = "https://www.episodate.com/api/show-details?q=" + id.toString();
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

  // handle if no show found
  if (jsonData['tvShow'].isEmpty) {
    return ShowData(
      name: "Error",
      rating: 0,
      rating_count: 0,
      releaseYear: 0,
      genres: [],
      status: "Error",
      description: "Error",
      pictureUrls: [],
    );
  } else {
    ShowData showData = ShowData.fromJson(jsonData['tvShow']);
    return showData;
  }
}
