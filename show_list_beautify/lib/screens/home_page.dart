import 'package:flutter/material.dart';
import 'package:show_list_beautify/themes/theme.dart';
import '../file_management/file_manager.dart';
import 'list_input.dart';
import 'list_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

ListManager listManager = ListManager();

class _HomePageState extends State<HomePage> {
  TextEditingController editingController = TextEditingController();
  List<String> allListNames = [];
  List<String> filteredListNames = [];
  List<bool> selectedItems = [];
  bool isDeleteButtonVisible = false;

  @override
  void initState() {
    super.initState();
    loadLists();
  }

  // Function to load the lists locally
  Future<void> loadLists() async {
    await listManager.loadListsLocally();
    allListNames = listManager.loadLists().keys.toList();
    filteredListNames = List.from(allListNames);
    selectedItems = List.generate(filteredListNames.length, (index) => false);

    //to initially show the lists
    filterListsLocally("");
  }

  // Function to filter the lists locally based on the query
  void filterListsLocally(String query) {
    setState(() {
      filteredListNames = allListNames
          .where(
            (listName) => listName.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackground,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SearchBar(
              editingController: editingController,
              filterSearchResults: filterListsLocally,
            ),
          ),
          Expanded(
            child: ListWidget(
              filteredListNames: filteredListNames,
              selectedItems: selectedItems,
              isDeleteButtonVisible: isDeleteButtonVisible,
              toggleDeleteButton: toggleDeleteButton,
            ),
          ),
          Visibility(
            visible: !isDeleteButtonVisible,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: redPrimary,
                  minimumSize: const Size.fromHeight(50),
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
          ),
          Visibility(
            visible: isDeleteButtonVisible,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade800,
                        minimumSize: const Size.fromHeight(50),
                      ),
                      onPressed: () {
                        setState(() {
                          // Cancel button logic here
                          selectedItems =
                              List.filled(filteredListNames.length, false);
                          isDeleteButtonVisible = false;
                        });
                      },
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(
                      width: 10), // Add some spacing between the buttons
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        minimumSize: const Size.fromHeight(50),
                      ),
                      onPressed: deleteSelectedItems,
                      child: const Text('Delete'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void toggleDeleteButton(bool value) {
    setState(() {
      isDeleteButtonVisible = value;
    });
  }

  void deleteSelectedItems() {
    setState(() {
      // iterate through the selectedItems list and use deleteList to delete the selected items
      for (int i = 0; i < selectedItems.length; i++) {
        if (selectedItems[i]) {
          listManager.removeList(filteredListNames[i]);
        }
      }

      // Reset the selectedItems list and hide the delete button
      allListNames = listManager.loadLists().keys.toList();
      print(filteredListNames.length);
      filteredListNames = allListNames.where((listName) => filteredListNames.contains(listName)).toList();
      print(filteredListNames.length);
      selectedItems = List.filled(filteredListNames.length, false);
      print(selectedItems.length);
      isDeleteButtonVisible = false;
    });
  }
}

class SearchBar extends StatelessWidget {
  const SearchBar({
    Key? key,
    required this.editingController,
    required this.filterSearchResults,
  }) : super(key: key);

  final TextEditingController editingController;
  final void Function(String) filterSearchResults;

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: const TextStyle(color: Colors.white),
      onChanged: filterSearchResults,
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
    );
  }
}

class ListWidget extends StatefulWidget {
  const ListWidget({
    Key? key,
    required this.filteredListNames,
    required this.selectedItems,
    required this.isDeleteButtonVisible,
    required this.toggleDeleteButton,
  }) : super(key: key);

  final List<String> filteredListNames;
  final List<bool> selectedItems;
  final bool isDeleteButtonVisible;
  final void Function(bool) toggleDeleteButton;

  @override
  _ListWidgetState createState() => _ListWidgetState();
}

class _ListWidgetState extends State<ListWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: widget.filteredListNames.length,
      itemBuilder: (context, index) {
        String listName = widget.filteredListNames[index];
        return GestureDetector(
          onLongPress: () {
            widget.toggleDeleteButton(true);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              trailing: widget.isDeleteButtonVisible
                  ? Checkbox(
                      value: widget.selectedItems[index],
                      onChanged: (value) {
                        setState(() {
                          widget.selectedItems[index] = value!;
                        });
                      },
                    )
                  : null,
              onLongPress: () {
                widget.toggleDeleteButton(!widget.isDeleteButtonVisible);
                widget.selectedItems[index] = !widget.selectedItems[index];
              },
              onTap: () {
                // navigate to the list page
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
              // bug with tileColor 
              //tileColor: widget.selectedItems[index]
              //    ? redSecondary.withOpacity(0.5) // Color for selected item
              //    : secondaryBackground,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
        );
      },
    );
  }
}
