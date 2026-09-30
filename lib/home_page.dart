import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseFirestore? mFirestore;
  String uid = "";

  void getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    uid = prefs.getString("userId") ?? "";
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    mFirestore = FirebaseFirestore.instance;
    getUserId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: uid.isNotEmpty ? StreamBuilder(
        stream: mFirestore!.collection("users").doc(uid).collection("notes").snapshots(),
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
      ) : Center(child: CircularProgressIndicator()),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var docRef = await mFirestore!
              .collection("users")
              .doc(uid)
              .collection("notes")
              .add({
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
