import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'constant.dart';

class Notes extends StatefulWidget {
  const Notes({Key? key}) : super(key: key);

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  final _noteTitle = TextEditingController();
  final _noteName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Column(
                  children: [
                    Text(
                      'ADD NOTES',
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.w900),
                    ),
                    TextFormField(
                      controller: _noteTitle,
                      decoration: InputDecoration(hintText: 'Enter Your Notes'),
                    ),
                    TextFormField(
                      controller: _noteName,
                      decoration: InputDecoration(hintText: 'Enter Your Name'),
                    ),
                  ],
                ),
                actions: [
                  MaterialButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    color: Colors.pink,
                    child: Text('Cancel'),
                  ),
                  MaterialButton(
                    onPressed: () {
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc("${kFirebaseAuth.currentUser!.uid}")
                          .collection("notes")
                          .add({
                        "NotesTitle": _noteTitle.text,
                        "NotesName": _noteName.text,
                      });
                      Navigator.pop(context);
                      _noteTitle.clear();
                      _noteName.clear();
                    },
                    color: Colors.green,
                    child: Text('Add'),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(kFirebaseAuth.currentUser!.uid)
            .collection("notes")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<DocumentSnapshot> info = snapshot.data!.docs;
            return ListView.builder(
              itemCount: info.length,
              itemBuilder: (context, index) {
                return ListTile(
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Column(
                                  children: [
                                    Text(
                                      'UPDATES NOTES',
                                      style: TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.w900),
                                    ),
                                    TextFormField(
                                      controller: _noteTitle,
                                      decoration: InputDecoration(
                                          hintText: 'Enter Your Notes'),
                                    ),
                                    TextFormField(
                                      controller: _noteName,
                                      decoration: InputDecoration(
                                          hintText: 'Enter Your Name'),
                                    ),
                                  ],
                                ),
                                actions: [
                                  MaterialButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    color: Colors.pink,
                                    child: Text('Cancel'),
                                  ),
                                  MaterialButton(
                                    onPressed: () {
                                      FirebaseFirestore.instance
                                          .collection('Notes')
                                          .doc(info[index].id)
                                          .update({
                                        "NotesTitle": _noteTitle.text,
                                        "NotesName": _noteName.text,
                                      });
                                      Navigator.pop(context);
                                      _noteTitle.clear();
                                      _noteName.clear();
                                    },
                                    color: Colors.green,
                                    child: Text('Add'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        icon: Icon(Icons.edit),
                      ),
                      IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text(
                                      'Do you Want to delete this notes ?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {},
                                      child: Text('NO'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        FirebaseFirestore.instance
                                            .collection('Notes')
                                            .doc(info[index].id)
                                            .delete();
                                        Navigator.pop(context);
                                        _noteName.clear();
                                        _noteTitle.clear();
                                      },
                                      child: Text('YES'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          icon: Icon(Icons.delete))
                    ],
                  ),
                  subtitle: Text('${info[index].get('NotesTitle')}'),
                  title: Text('${info[index].get('NotesName')}'),
                );
              },
            );
          } else {
            return SizedBox();
          }
        },
      ),
    );
  }
}
