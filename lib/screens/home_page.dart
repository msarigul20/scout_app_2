import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scoutapp/ListPage.dart';
import 'package:flutter/material.dart';
import 'auth.dart';

import 'auth.dart';

// FIXME: Needs to add or fix these:
//1-)Add delete functionality with user control.
//2-)Search functionality

class HomePage extends StatefulWidget {
  HomePage({this.auth, this.onSignedOut});

  Future getUser() async {
    String user = await this.auth.currentUser();
    return;
  }

  Future getUserUID() async {
    FirebaseUser tempUser = await FirebaseAuth.instance.currentUser();
    final uid = tempUser.uid;
    return uid;
  }

  final BaseAuth auth;
  final VoidCallback onSignedOut;

  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future getUser() async {
    String user = await this.widget.auth.currentUser();
  }

  Future getUserID() async {
    FirebaseUser tempUser = await FirebaseAuth.instance.currentUser();

    return Text(tempUser.uid);
  }

  void _signOut() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print(e);
    }
  }

  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  String _currentUserUID;

  @override
  Widget build(BuildContext context) {
    FirebaseAuth.instance.currentUser().then((user) {
      _currentUserUID = user.uid;
    });

    final List<Map<String, Object>> _pages = [
      {'page': AddPlayerPage(), 'title': 'Scout App'},
      {'page': ListPage(_currentUserUID), 'title': 'List of Player'},
      {'page': AddPlayerPage(), 'title': 'New Player'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: new Text(_pages[_selectedPageIndex]['title']),
        centerTitle: true,
        actions: <Widget>[
          FlatButton(
            child: Text(
              "Logout",
              style: TextStyle(fontSize: 17.0, color: Colors.white),
            ),
            onPressed: _signOut,
          )
        ],
      ),
      body: _pages[_selectedPageIndex]['page'],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        backgroundColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.black,
        selectedItemColor: Colors.white,
        currentIndex: _selectedPageIndex,
        type: BottomNavigationBarType.shifting,
        items: [
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.list),
            title: Text('Players List'),
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.person_add),
            title: Text('Add Player'),
          ),
        ],
      ),
    );
  }
}

class DeleteAllStuff extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new RaisedButton(
        child: Text(
          "Delete All Data",
          style: new TextStyle(fontSize: 20.0),
        ),
        onPressed: () async {
          Firestore.instance
              .collection("players")
              .getDocuments()
              .then((snapshot) {
            for (DocumentSnapshot ds in snapshot.documents) {
              ds.reference.delete();
            }
          });
        });
  }
}

class AddPlayerPage extends StatefulWidget {
  @override
  _AddPlayerPageState createState() => _AddPlayerPageState();
}

class _AddPlayerPageState extends State<AddPlayerPage> {
  final myNameController = TextEditingController();
  final mySurnameController = TextEditingController();
  final myAgeController = TextEditingController();

  @override
  void dispose() {
    myNameController.dispose();
    mySurnameController.dispose();
    myAgeController.dispose();
    super.dispose();
  }

  String _currentUserUID;

  @override
  Widget build(BuildContext context) {
    FirebaseAuth.instance.currentUser().then((user) {
      _currentUserUID = user.uid;
    });
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(), hintText: "Name"),
                  controller: myNameController,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(), hintText: "Surname"),
                  controller: mySurnameController,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(), hintText: "Age"),
                  controller: myAgeController,
                ),
              ),
              new RaisedButton(
                onPressed: () {
                  // to get id of owner(pID)
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: Text("Adding New Player"),
                      content: Text("Are you sure?"),
                      actions: <Widget>[
                        FlatButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('NO'),
                        ),
                        FlatButton(
                            onPressed: () async {
                              int fixInteger = 0;
                              DocumentReference ref = await Firestore.instance
                                  .collection("players")
                                  .add({
                                "uID": "",
                                "pID": "",
                                "name": "",
                                "surname": "",
                                "age": fixInteger
                              });
                              String tempDocID = ref.documentID;
                              FirebaseUser tempUser =
                                  await FirebaseAuth.instance.currentUser();
                              ref.setData({
                                "uID": tempUser.uid,
                                "pID": tempDocID,
                                "name": myNameController.text,
                                "surname": mySurnameController.text,
                                "age": int.parse(myAgeController.text),
                              });
                              myNameController.clear();
                              mySurnameController.clear();
                              myAgeController.clear();
                              Navigator.of(context).pop();
                              FocusScope.of(context).requestFocus(FocusNode());
                            },
                            child: Text('Yes'))
                      ],
                    ),
                    barrierDismissible: false,
                  );
                },
                child: Text('Add Player'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
