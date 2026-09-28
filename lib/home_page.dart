import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseFirestore? mFirestore;

  @override
  void initState() {
    super.initState();
    mFirestore = FirebaseFirestore.instance;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: StreamBuilder(
        stream: mFirestore!.collection("notes").snapshots(),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (snapshot.hasData) {
            var allNotes = snapshot.data!.docs;

            return allNotes.isNotEmpty
                ? ListView.builder(
              itemCount: allNotes.length,
                    itemBuilder: (_, index) {
                      return Card(
                        child: ListTile(
                          title: Text(allNotes[index].data()["title"]),
                          subtitle: Text(allNotes[index].data()["desc"]),
                        ),
                      );
                    },
                  )
                : Center(child: Text("No Notes yet!!"));
          }

          return Container();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var docRef = await mFirestore!.collection("notes").add({
            "title": "New Note",
            "desc": "This is my First note!!",
            "created_at": DateTime.now().millisecondsSinceEpoch,
          });
          print("Note added: ${docRef.id}");
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
