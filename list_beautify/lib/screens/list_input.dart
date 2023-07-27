import 'package:flutter/material.dart';
import 'package:list_beautify/screens/list_page.dart';
import 'package:list_beautify/themes/theme.dart';
import 'package:list_beautify/widgets/back_arrow_widget.dart';

class ListInput extends StatefulWidget {
  const ListInput({Key? key}) : super(key: key);

  @override
  State<ListInput> createState() => _ListInputState();
}

class _ListInputState extends State<ListInput> {
  final textController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget spacer = SizedBox(height: 16);

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
                      controller: textController,
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ListPage(
                          listName: textController.text,
                        ),
                      ),
                    );
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
