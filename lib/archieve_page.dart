import 'package:flutter/material.dart';
import 'database_helper.dart';

class ArchieveScreen extends StatefulWidget {
  ArchieveScreen({Key? key}) : super(key: key);

  @override
  State<ArchieveScreen> createState() => ArchieveScreenState();
}

class ArchieveScreenState extends State<ArchieveScreen> {
  List<Map<String, dynamic>> archivedNotes = [];

  @override
  void initState() {
    super.initState();
    fetchArchivedNotes();
  }

  Future<void> fetchArchivedNotes() async {
    final notes = await DBHelper.getArchivedNotes();
    setState(() {
      archivedNotes = notes ?? [];
    });
  }

  Future<void> unarchiveNote(int id) async {
    try {
      await DBHelper.updateArchiveStatus(id, 0);
      setState(() {
        archivedNotes.removeWhere((note) => note['id'] == id);
      });
    } catch (e) {
      print("Error unarchiving note: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Archived Notes"),
      ),
      body: archivedNotes.isEmpty
          ? Center(
              child: Text(
                "No archived notes.",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: archivedNotes.length,
              itemBuilder: (context, index) {
                final note = archivedNotes[index];
                return Dismissible(
                  key: Key(note['id'].toString()),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    unarchiveNote(note['id']);
                  },
                  background: Container(
                    color: Colors.green,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Icon(
                      Icons.unarchive,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  child: Card(
                    margin: EdgeInsets.all(10),
                    child: ListTile(
                      title: Text(
                        note['Title'],
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(note['Note']),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
