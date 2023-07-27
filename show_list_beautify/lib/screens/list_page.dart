import 'package:flutter/material.dart';

import '../themes/theme.dart';
import '../widgets/back_arrow_widget.dart';

class ListPage extends StatefulWidget {
  const ListPage({Key? key, required this.listName}) : super(key: key);

  final String listName;

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
          child: Column(
            children: [
              ArrowButton(
                text: widget.listName,
                startIcon: Icons.arrow_back_rounded,
              ),
              const SizedBox(height: 32),
              Text(widget.listName, style: TextStyle(fontSize: 20, color: whiteText)),
            ],
          ),
        ),
      ),
    );
  }
}
