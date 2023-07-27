import 'package:flutter/material.dart';
import 'package:show_list_beautify/screens/list_page.dart';
import 'package:show_list_beautify/themes/theme.dart';

import 'list_input.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController editingController = TextEditingController();

  final duplicateItems = List<String>.generate(20, (i) => "Item $i");
  List<String> items = [];

  @override
  void initState() {
    items = duplicateItems;
    super.initState();
  }

  void filterSearchResults(String query) {
    setState(() {
      items = duplicateItems
          .where((item) => item.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackground,
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              style: const TextStyle(color: Colors.white),
              onChanged: (value) {
                filterSearchResults(value);
              },
              controller: editingController,
              decoration: InputDecoration(
                labelText: "Search",
                labelStyle: const TextStyle(color: Colors.white60),
                hintText: "Search",
                hintStyle: const TextStyle(color: Colors.white60),
                prefixIcon: const Icon(Icons.search),
                prefixIconColor: Colors.white60,
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(25.0)),
                  borderSide: BorderSide(color: redSecondary),
                ),
                filled: true,
                fillColor: secondaryBackground,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: ListTile(
                      textColor: whiteText,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ListPage(listName: items[index]),
                          ),
                        );
                      },
                      title: Text(
                        items[index],
                        style: TextStyle(color: whiteText),
                      ),
                      tileColor: secondaryBackground,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: redPrimary,
                minimumSize: const Size.fromHeight(50), // NEW
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ListInput(),
                  ),
                );
              },
              child: const Text('Create New List'),
            ),
          ),
        ],
      ),
    );
  }
}
