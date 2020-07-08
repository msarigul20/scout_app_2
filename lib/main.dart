import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'screens/auth.dart';
import 'screens/auth.dart';
import 'root_page.dart';
void main(){
  runApp(new MyApp());
}

class MyApp extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title:  "Scout App",
      theme: new ThemeData(
          primarySwatch: Colors.green,
      ),
      home: new RootPage(auth: new Auth()),
    );
  }
}
