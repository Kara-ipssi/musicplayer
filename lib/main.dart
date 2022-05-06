import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:musicplayer/Controller/Connexion.dart';
import 'package:musicplayer/Controller/Inscription.dart';

import 'modelView/fondEcran.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if ((defaultTargetPlatform == TargetPlatform.iOS) ||
      (defaultTargetPlatform == TargetPlatform.android)) {
    await Firebase.initializeApp();
  } else {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyB3zphvnqXHBpu6HucH4g39kMqvM3GFhwI",
            appId: "1:94258907:web:441900fe7d14ea5fc1aefe",
            messagingSenderId: "94258907",
            projectId: "musicipssi",
            storageBucket: "musicipssi.appspot.com"));
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

bool selected = false;

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FondEcran(),
          Center(child: bodyPage()),
        ],
      ),

      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget bodyPage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Inscription"),
            Switch(
              value: selected,
              onChanged: (value) {
                setState(() {
                  selected = value;
                });
              },
            ),
            Text("Connexion"),
          ],
        ),
        (selected)
            ? Connexion()
            : Inscription(),
      ],
    );
  }
}
