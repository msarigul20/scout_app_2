import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scoutapp/home_page.dart';

class ListHomePage extends StatefulWidget {
  ListHomePage({Key key, this.title, this.uID}) : super(key: key);
  final String title;
  final String uID;

  @override
  _ListHomePageState createState() => _ListHomePageState();
}

class _ListHomePageState extends State<ListHomePage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(widget.title),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: (){
                print("Search Tıklandı");
              },
            )
          ],
        ),
        body: ListPage(widget.uID));
  }
}

class ListPage extends StatefulWidget {
  String my_uID;

  ListPage(this.my_uID);

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
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

  Future myPlayers() async {
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore
        .collection("players")
        .where("uID", isEqualTo: this.widget.my_uID)
        .getDocuments();
    print("My_uID: " + this.widget.my_uID);
    return qn.documents;
  }

  Future getCurrentID() async {
    FirebaseUser tempUser = await FirebaseAuth.instance.currentUser();
    return tempUser.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Center(

        child: Container(

      child: FutureBuilder(
        future: myPlayers(),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Text(
                "Loading",
                style: TextStyle(fontSize: 32.0),
              ),
            );
          }
          else if (snapshot.data.length == 0) {
            return Card(

              child: InkWell(

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "There is no player on your list!",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text("Please add a new player in main menu.",
                          style:TextStyle(fontSize: 15,color: Colors.grey)),
                        RaisedButton(
                          child: Text("Add New"),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddPlayerPage()));
                          },
                        )
                      ],
                    )
                  ],
                ),
              ),
            );
          }
          else {
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (_, index) {
                  print(snapshot.data.length);
                  return Column(
                    children: <Widget>[
                      Card(
                        child: InkWell(
                          child: Row(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.symmetric(
                                  vertical: 35,
                                  horizontal: 15,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.lightGreenAccent,
                                    width: 2,
                                  ),
                                ),
                                padding: EdgeInsets.all(5),
                                child: Text(
                                  '${snapshot.data[index].data["name"].toString().trim().toUpperCase()[0]}' +
                                      '${snapshot.data[index].data["surname"].toString().trim().toUpperCase()[0]}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.lightBlueAccent,
                                  ),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        snapshot.data[index].data["name"].trim() +
                                            ' ' +
                                            snapshot.data[index].data["surname"].trim(),
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),

                                  Row(
                                    children: <Widget>[
                                      Text("Age: ",style: TextStyle(color: Colors.grey),),
                                      Text(snapshot.data[index].data["age"].trim()),
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                          onTap: () => navigateToDetail(snapshot.data[index]),
                          onLongPress: () => navigateToEdit(snapshot.data[index]),
                        ),
                      ),
                    ],
                  );
                });
          }
        },
      ),
    ));
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
        padding: EdgeInsets.fromLTRB(10, 30, 10, 10),
        height: 450,
        width: double.maxFinite,
        child: Card(
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.centerRight,
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.person_pin,
                            size: 55.0,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          CardNameTag(),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          SizedBox(
                            height: 30,
                          )
                        ],
                      ),
                      Row(
                        children: <Widget>[InfoPlayerDetail()],
                      ),
                      Row(
                        children: <Widget>[
                          SizedBox(
                            height: 30,
                          )
                        ],
                      ),
                      InfoPlayerDetail2(),
                      Row(
                        children: <Widget>[
                          SizedBox(
                            height: 30,
                          )
                        ],
                      ),
                      InfoPlayerDetail3()
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget CardNameTag() {
    return Align(
      alignment: Alignment.centerLeft,
      child: RichText(
        text: TextSpan(
          text:
              widget.player.data["name"] + " " + widget.player.data["surname"],
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20),
          children: <TextSpan>[
            TextSpan(
                text: "\n" + widget.player.data["pID"],
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget InfoPlayerDetail() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0),
        child: Row(
          children: <Widget>[
            RichText(
              textAlign: TextAlign.left,
              text: TextSpan(
                text: "Age: ",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                children: <TextSpan>[
                  TextSpan(
                      text: widget.player.data["age"],
                      style: TextStyle(
                          color: Colors.black,
                          fontStyle: FontStyle.italic,
                          fontSize: 22)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget InfoPlayerDetail2() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0),
        child: Row(
          children: <Widget>[
            RichText(
              textAlign: TextAlign.left,
              text: TextSpan(
                text: "User ID: ",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                children: <TextSpan>[
                  TextSpan(
                      text: "\n" + widget.player.data["uID"],
                      style: TextStyle(
                          color: Colors.black,
                          fontStyle: FontStyle.italic,
                          fontSize: 18)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget InfoPlayerDetail3() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0),
        child: Row(
          children: <Widget>[
            RichText(
              textAlign: TextAlign.left,
              text: TextSpan(
                text: "Player ID: ",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                children: <TextSpan>[
                  TextSpan(
                      text: "\n" + widget.player.data["pID"],
                      style: TextStyle(
                          color: Colors.black,
                          fontStyle: FontStyle.italic,
                          fontSize: 18)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/*ListTile(
title: Text(widget.player.data["name"] +
" " +
widget.player.data["surname"]),
subtitle: Text(widget.player.data["uID"]),
)*/

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
              "Edit"),
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
                      crossAxisAlignment: CrossAxisAlignment.center,
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

                              RaisedButton(

                                onPressed: () async {
                                  if (_formKey.currentState.validate()) {
                                    DocumentReference ref = Firestore.instance
                                        .collection("players")
                                        .document(widget.player.data["pID"]);
                                    FirebaseUser tempUser =
                                        await FirebaseAuth.instance.currentUser();
                                    ref.setData({
                                      "uID": tempUser.uid,
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
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
              ),
            ),
        );
  }
}
