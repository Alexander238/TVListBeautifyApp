import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:show_list_beautify/widgets/list_element.dart';

import '../themes/theme.dart';
import '../widgets/back_arrow_widget.dart';

import 'package:http/http.dart' as http;
import 'package:show_list_beautify/web_handling/showAPIHandler.dart';

class ListPage extends StatefulWidget {
  const ListPage({Key? key, required this.listName, required this.listContent})
      : super(key: key);

  final String listName;
  final List<String> listContent;

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
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
                      //on click navigate to home_page
                      onClick: () {
                        Navigator.pushReplacementNamed(context, '/home_page');
                      },
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
                      return FutureBuilder<Widget>(
                        future: fetchDataByName(widget.listContent[index]),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error loading data');
                          } else {
                            return snapshot.data!;
                          }
                        },
                      );
                    },
                    childCount: widget.listContent.length,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
