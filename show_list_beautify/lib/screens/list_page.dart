import 'package:flutter/material.dart';
import 'package:show_list_beautify/widgets/list_element.dart';

import '../themes/theme.dart';
import '../widgets/back_arrow_widget.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class ListPage extends StatefulWidget {
  const ListPage({Key? key, required this.listName, required this.listContent})
      : super(key: key);

  final String listName;
  final List<String> listContent;

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  Future<String> getImageUrl(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      // If the request is successful, return the image URL as a String
      return url;
    } else {
      // If there's an error, you can return a placeholder image URL or handle the error in another way
      return "https://user-images.githubusercontent.com/24848110/33519396-7e56363c-d79d-11e7-969b-09782f5ccbab.pngs";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackground,
      body: SafeArea(
        child: Center(
            child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                automaticallyImplyLeading: false,
                backgroundColor: primaryBackground,
                flexibleSpace: FlexibleSpaceBar(
                  background: ArrowButton(
                    text: widget.listName,
                    startIcon: Icons.arrow_back_rounded,
                  ),
                ),
              ),
              SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Number of columns in the grid
                  crossAxisSpacing: 8.0, // Spacing between columns
                  mainAxisSpacing: 8.0, // Spacing between rows
                  childAspectRatio: 4 / 6,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return NamedPictureCard(
                      name: "name",
                      onTap: () => {},
                      image: getImageUrl(
                          "https://static.episodate.com/images/tv-show/thumbnail/29560.jpg"),
                    );
                  },
                  childCount: widget.listContent.length,
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
