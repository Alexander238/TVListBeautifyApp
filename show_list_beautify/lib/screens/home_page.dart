import 'package:flutter/material.dart';
import 'package:show_list_beautify/screens/list_page.dart';
import 'package:show_list_beautify/themes/theme.dart';
import '../file_management/file_manager.dart';
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
  ListManager listManager = ListManager();
  List<String> filteredListNames = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackground,
      body: FutureBuilder<void>(
        future: loadLists(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return buildList();
          }
        },
      ),
    );
  }

  // Function to load the lists locally
  Future<void> loadLists() async {
    print("Loading lists...");
    await listManager.loadListsLocally();
    filteredListNames = listManager.loadLists().keys.toList();
    print("Lists loaded: ${filteredListNames.length}");
  }

  Widget buildList() {
    return Column(
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
            itemCount: filteredListNames.length,
            itemBuilder: (context, index) {
              String listName = filteredListNames[index];
              print("hi _ " + listName);
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: ListTile(
                    textColor: whiteText,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ListPage(
                            listName: listName,
                            listContent: listManager.getListItems(listName),
                          ),
                        ),
                      );
                    },
                    title: Text(
                      listName,
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
                  builder: (context) => ListInput(
                    listManager: listManager,
                  ),
                ),
              );
            },
            child: const Text('Create New List'),
          ),
        ),
      ],
    );
  }

  void filterSearchResults(String query) {
    setState(() {
      // Use listManager to get all the list names and filter them based on the query
      filteredListNames = listManager
          .loadLists()
          .keys
          .where(
            (listName) => listName.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    });
  }
}
