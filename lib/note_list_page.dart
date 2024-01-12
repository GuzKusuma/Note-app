import 'package:flutter/material.dart';
import 'package:note_app_sqlite/db_provider.dart';
import 'package:note_app_sqlite/note_add_update_page.dart';

import 'package:provider/provider.dart';

class NoteListPage extends StatelessWidget {
  const NoteListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MyNotes',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Consumer<DbProvider>(
        builder: (context, provider, child) {
          final notes = provider.notes;

          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];
              return Dismissible(
                key: Key(note.id.toString()),
                background: Container(
                  color: Colors.red,
                  child: const Center(
                    child: Icon(Icons.delete),
                  ),
                ),
                onDismissed: (direction) {
                  provider.deleteNote(note.id!);
                },
                child: Card(
                  elevation: 8,
                  margin: const EdgeInsets.all(15),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(10),
                    title: Text(note.title),
                    subtitle: Text(note.description),
                    onTap: () async {
                      final navigator = Navigator.of(context);
                      final selectedNote = await provider.getNotebyId(note.id!);

                      navigator.push(MaterialPageRoute(builder: (context) {
                        return NoteAddUpdatePage(
                          note: selectedNote,
                        );
                      }));
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const NoteAddUpdatePage()));
        },
      ),
    );
  }
}
