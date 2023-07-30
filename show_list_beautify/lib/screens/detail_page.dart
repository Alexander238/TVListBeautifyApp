// page for display of details about a list item of the show

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:show_list_beautify/themes/theme.dart';

import '../widgets/back_arrow_widget.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key, required this.showNameID}) : super(key: key);

  final int showNameID;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: primaryBackground,
        body: SafeArea(
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const ArrowButton(
                      text: "Name of Show",
                      startIcon: Icons.arrow_back_rounded,
                    ),
                    const SizedBox(height: 32),
                  ],
                ))));
  }
}
