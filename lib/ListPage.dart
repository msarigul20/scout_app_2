import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(widget.title),
        ),
        body: ListPage());
  }
}

class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  Future getPlayers() async {
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection("players").getDocuments();
    return qn.documents;
  }

  navigateToDetail(DocumentSnapshot player) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DetailedPage(
                  player: player,
                )));
  }

  navigateToEdit(DocumentSnapshot player) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditPage(
                  player: player,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
            child: FutureBuilder(
      future: getPlayers(),
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Text("Loading",style: TextStyle(fontSize: 32.0),),
          );
        } else {
          return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (_, index) {
                return ListTile(
                  title: Text(snapshot.data[index].data["name"] +
                      " " +
                      snapshot.data[index].data["surname"]),
                  onTap: () => navigateToDetail(snapshot.data[index]),
                  onLongPress: () => navigateToEdit(snapshot.data[index]),
                );
              });
        }
      },
    )));
  }
}

class DetailedPage extends StatefulWidget {
  final DocumentSnapshot player;

  DetailedPage({this.player});

  @override
  _DetailedPageState createState() => _DetailedPageState();
}

class _DetailedPageState extends State<DetailedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.player.data["name"] +
            " " +
            widget.player.data["surname"] +
            " " +
            "Info"),
      ),
      body: Container(
        child: Card(
          child: ListTile(
            title: Text(widget.player.data["name"] +
                " " +
                widget.player.data["surname"]),
            subtitle: Text(widget.player.data["age"]),
          ),
        ),
      ),
    );
  }
}

class EditPage extends StatefulWidget {
  final DocumentSnapshot player;

  EditPage({this.player});

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final myNameController =
        TextEditingController(text: this.widget.player["name"]);
    final mySurnameController =
        TextEditingController(text: this.widget.player["surname"]);
    final myAgeController =
        TextEditingController(text: this.widget.player["age"]);
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.player.data["name"] +
              " " +
              widget.player.data["surname"] +
              " " +
              "Info"),
        ),
        body: SingleChildScrollView(
          //fix oversize of keyboard first wrap widget and rename SingleChildScrollView
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: "Name",
                                labelText: "Name"),
                            controller: myNameController,
                            validator: (value) {
                              if (value.isEmpty) {
                                print("is not empty");
                                //todo give error to warn user about is can not empty
                                return 'Please enter some text';
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: "Surname",
                                labelText: "Surname"),
                            controller: mySurnameController,
                            validator: (value) {
                              if (value.isEmpty) {
                                print("is not empty");
                                //todo give error to warn user about is can not empty
                                return 'Please enter some text';
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: "Age",
                                labelText: "Age"),
                            //todo force user to enter number imput
                            controller: myAgeController,
                            validator: (value) {
                              if (value.isEmpty) {
                                print("is not empty");
                                //todo give error to warn user about is can not empty
                                return 'Please enter some text';
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: RaisedButton(
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                DocumentReference ref = Firestore.instance
                                    .collection("players")
                                    .document(widget.player.data["pID"]);
                                ref.setData({
                                  "pID": widget.player.data["pID"],
                                  "name": myNameController.text,
                                  "surname": mySurnameController.text,
                                  "age": myAgeController.text,
                                });
                                /*print(myNameController.text);
                                print(mySurnameController.text);
                                print(myAgeController.text);*/
                              }
                              Navigator.pop(context);
                            },
                            child: Text("Edit"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
