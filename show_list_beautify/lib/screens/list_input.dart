import 'package:flutter/material.dart';
import 'package:show_list_beautify/screens/list_page.dart';
import 'package:show_list_beautify/themes/theme.dart';
import 'package:show_list_beautify/widgets/back_arrow_widget.dart';

class ListInput extends StatefulWidget {
  const ListInput({Key? key}) : super(key: key);

  @override
  State<ListInput> createState() => _ListInputState();
}

class _ListInputState extends State<ListInput> {
  final firstTextController = TextEditingController();
  final secondTextFieldController = TextEditingController();
  bool isListNameEmpty = false;
  bool isListContentEmpty = false;

  void validateTextFields() {
  setState(() {
    isListNameEmpty = firstTextController.text.isEmpty;
    isListContentEmpty = secondTextFieldController.text.isEmpty;
  });
}


  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    firstTextController.dispose();
    secondTextFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget spacer = const SizedBox(height: 16);

    return Scaffold(
      backgroundColor: primaryBackground,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    const ArrowButton(
                      text: "Create New List",
                      startIcon: Icons.arrow_back_rounded,
                    ),
                    const SizedBox(height: 32),

                    TextField(
                      controller: firstTextController,
                      style: TextStyle(color: whiteText),
                      // Customize the TextField as needed
                      decoration: InputDecoration(
                        hintText: 'Name of List',
                        hintStyle: const TextStyle(color: Colors.white60),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: whiteText),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: whiteText),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: redSecondary),
                        ),
                      ),
                    ),

                    spacer,

                    TextField(
                      controller: secondTextFieldController,
                      maxLines:
                          null, // Allow the TextField to take multiple lines
                      style: TextStyle(color: whiteText),
                      // Customize the TextField as needed
                      decoration: InputDecoration(
                        hintText: 'List',
                        hintStyle: const TextStyle(color: Colors.white60),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: whiteText),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: whiteText),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: redSecondary),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 16, 8, 0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: redPrimary,
                    minimumSize: const Size.fromHeight(50), // NEW
                  ),
                  onPressed: () {
                    validateTextFields();
                    if (isListNameEmpty || isListContentEmpty) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Error'),
                            content: const Text('Please fill in all fields'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ListPage(
                            listName: firstTextController.text,
                            listContent: secondTextFieldController.text.split("\n").toList(),
                          ),
                        ),
                      );
                    }
                  },
                  child: const Text('Enter List'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
