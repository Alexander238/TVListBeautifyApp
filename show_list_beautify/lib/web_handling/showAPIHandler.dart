import 'dart:convert';
import 'package:flutter/material.dart';
import '../screens/detail_page.dart';
import '../structs/show_data_struct.dart';
import '../widgets/list_element.dart';
import 'package:http/http.dart' as http;

const String errURL =
    "https://previews.123rf.com/images/ivanburchak/ivanburchak1906/ivanburchak190600253/125651894-404-page-not-found-design-template-big-red-404-numbers-on-the-shelf-404-error-page-concept-vector.jpg";
const String apiKey = "4d9caa79700d612de9d461ffda9aeea0";

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

String buildURL(String name) {
  String modifiedName = name.replaceAll(' ', '+').trim();
  return "https://api.themoviedb.org/3/search/multi?api_key=$apiKey&query=$modifiedName";
}

String executeShowSearchByKey(
    Map<String, dynamic> showArray, String name, String key) {
  if (showArray.isNotEmpty) {
    return showArray[key].toString();
  }
  return "";
}

Map<String, dynamic> findShowMap(Map<String, dynamic> jsonData, String name) {
  List<dynamic> results = jsonData['results'];

  name = name.toLowerCase();
  for (var show in results) {
    //has to have key with either title or name
    if (show.containsKey('title')) {
      if (show['title'].toLowerCase() == name) return show;
    } else {
      if (show['name'].toLowerCase() == name) return show;
    }
  }
  if (results.isNotEmpty) {
    return results[0];
  }

  return {};
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

  // get thumbnail url
  String thumbnailUrl = "";
  if (showArray.isNotEmpty && showArray['poster_path'] != null) {
    String modifiedURL = showArray['poster_path'];
    thumbnailUrl = "https://image.tmdb.org/t/p/w500$modifiedURL";
  } else {
    thumbnailUrl = errURL;
  }

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