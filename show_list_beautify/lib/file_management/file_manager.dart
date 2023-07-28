import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class ListManager {
  Map<String, List<String>> lists = {};

  // Funktion zum Hinzufügen einer neuen Liste
  void addList(String listName, List<String> items) {
    lists[listName] = items;

    print(lists);

    print(listName);
    print(items);
    saveListsLocally();
  }

  // Funktion zum Laden aller Listen
  Map<String, List<String>> loadLists() {
    return lists;
  }

  // Funktion zum Speichern der Listen in einer JSON-Datei
  Future<void> saveListsLocally() async {
    try {
      final file = await getLocalFile();
      final jsonData = json.encode(lists);
      await file.writeAsString(jsonData);

      print("Lists saved to file successfully.");
    } catch (e) {
      print("Error while saving lists: $e");
    }
  }

  // Funktion zum Laden der Listen aus der JSON-Datei
  Future<void> loadListsLocally() async {
    try {
      final file = await getLocalFile();
      final jsonData = await file.readAsString();
      final decodedData = json.decode(jsonData);

      if (decodedData != null && decodedData is Map<String, dynamic>) {
        lists = Map<String, List<String>>.from(
          decodedData
              .map((key, value) => MapEntry(key, List<String>.from(value))),
        );
      } else {
        lists = {};
      }
    } catch (e) {
      print("Error while loading lists: $e");
      lists = {};
    }
  }

  // Funktion zum Zugriff auf die Elemente einer spezifischen Liste
  List<String> getListItems(String listName) {
    return lists[listName] ?? [];
  }

  // Hilfsfunktion zur Verwaltung der lokalen JSON-Datei
  Future<File> getLocalFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = path.join(directory.path, 'lists.json');
    print("File path: $filePath"); // Print the file path
    final file = File(filePath);
    return file;
  }
}
