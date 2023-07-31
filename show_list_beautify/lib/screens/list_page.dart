import 'package:flutter/material.dart';
import '../themes/theme.dart';
import '../widgets/back_arrow_widget.dart';
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
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
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
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
              SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Number of columns in the grid
                  crossAxisSpacing: 12.0, // Spacing between columns
                  mainAxisSpacing: 12.0, // Spacing between rows
                  childAspectRatio: 4 / 6,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return FutureBuilder<Widget>(
                      future:
                          fetchDataByName(widget.listContent[index], context),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return const Text('Error loading data');
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
    );
  }
}
