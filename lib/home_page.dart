import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoutapp/ListPage.dart';
import 'package:flutter/material.dart';
import 'package:scoutapp/auth.dart';
import 'auth.dart';

/*
        DocumentSnapshot shot = await Firestore.instance.document("r/ExiSWuLu4zJb8jETentK").get(); //type 1
        DocumentReference ref=Firestore.instance.document("players/ExiSWuLu4zJb8jETentK"); // type2
        DocumentSnapshot shot= await ref.get();
        print(shot.data);*/ //get directly one player information
/*
        CollectionReference collectionRef = Firestore.instance.collection("scouts");
        QuerySnapshot querySnapshot = await collectionRef.getDocuments();
        for(final doc in querySnapshot.documents){
          print("-----");
          print(doc.data);
        }*/ //print collections with all as players
/*
        DocumentReference ref=Firestore.instance.collection('players').document();
        ref.setData({
          "pID":ref.documentID,
          "name":"Mustafa",
          "surname":"Sarıgül",
          "age":"24",
        });
        ref.setData({
          "pID":ref.documentID,
          "name":"Cem",
          "surname":"Alıcı",
          "age":"21",
        });
*/ //change alan adı name surname
/*
        Firestore.instance
            .collection("players")
            .add({"pID":ref.documentID,"name":"Mustafa","surname":"Sarıgül"});
        CollectionReference collectionRef = Firestore.instance.collection("players");
        QuerySnapshot querySnapshot = await collectionRef.getDocuments();
        for(final doc in querySnapshot.documents){
          print("-----");
          print(doc.data);
        }*/ //teacher code
/*
        Firestore.instance.collection("players").document("Ec964GvQD9rthyyQulDO").delete();*/ // delete document
/*
        Firestore.instance.collection("players").getDocuments().then((snapshot){
          for(DocumentSnapshot ds in snapshot.documents){
            ds.reference.delete();
          }
        }
        );
*/ // delete all documents
/*
    Future getUser() async {
      String user = await this.auth.currentUser();
      print(user);
    }
    getUser();
*/ // get user idA

// FIXME: Needs to add or fix these:
// 1-)Every user changing same data.
//2-)List title will change.
// 3-)Apply SingleScrollChild method to avoid oversize problem
//4-)Add delete functionality with user control.
//5-)Search functionality




class HomePage extends StatelessWidget {
  HomePage({this.auth, this.onSignedOut});

  final BaseAuth auth;
  final VoidCallback onSignedOut;

  void _signOut() async {
    try {
      await auth.signOut();
      onSignedOut();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Scout App"),
          centerTitle: true,
          actions: <Widget>[
            new FlatButton(
              child: new Text("Logout",
                  style: new TextStyle(
                    fontSize: 17.0,
                    color: Colors.white,
                  )),
              onPressed: _signOut,
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Center(
            child: new Container(
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Text("HELLO MANAGER", style: new TextStyle(fontSize: 32.0)),
           /*       RaisedButton(
                      child: Text("Try Button", style: TextStyle(fontSize: 20.0)),
                      onPressed: () {
                        //todo try some thing
                      }),*/
                  RaisedButton(
                      child:
                          Text("List Players", style: TextStyle(fontSize: 20.0)),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    MyHomePage(title: "Player List Page")));
                      }),
                  RaisedButton(
                      child: Text("Add with user", style: new TextStyle(fontSize: 20.0)),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => AddPlayer()));
                      }),
                  DeleteAllStuff()
                ],
              ),
            ),
          ),
        ));
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

/*class AddStuff extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
   *//*     RaisedButton(
          child: Text(
            "Add Test Data Mustafa",
            style: new TextStyle(fontSize: 20.0),
          ),
          onPressed: () async {
            DocumentReference ref =
                await Firestore.instance.collection("players").add({
              "pID": "",
              "name": "Mustafa",
              "surname": "Sarıgül",
              "age": "24",
            });
            String tempDocID = ref.documentID;
            ref.setData({
              "pID": tempDocID,
              "name": "Mustafa",
              "surname": "Sarıgül",
              "age": "24",
            });
          },
        ), // mustafa
        RaisedButton(
          child: Text(
            "Add Test Data Cem",
            style: new TextStyle(fontSize: 20.0),
          ),
          onPressed: () async {
            DocumentReference ref =
                await Firestore.instance.collection("players").add({
              "pID": "",
              "name": "Cem",
              "surname": "Alıcı",
              "age": "21",
            });
            String tempDocID = ref.documentID;
            ref.setData({
              "pID": tempDocID,
              "name": "Cem",
              "surname": "Alıcı",
              "age": "21",
            });
          },
        ), // cem*//* // adding test data buttons
      ],
    );
  }
}*/

class AddPlayer extends StatefulWidget {
  @override
  _AddPlayerState createState() => _AddPlayerState();
}

class _AddPlayerState extends State<AddPlayer> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Adding Page"),
      ),
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
                onPressed: () async {
                  // to get id of owner(pID)
                  DocumentReference ref = await Firestore.instance
                      .collection("players")
                      .add({"pID": "", "name": "", "surname": "", "age": ""});
                  String tempDocID = ref.documentID;
                  ref.setData({
                    "pID": tempDocID,
                    "name": myNameController.text,
                    "surname": mySurnameController.text,
                    "age": myAgeController.text,
                  });
                  Navigator.pop(context);
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
