import 'package:flutter/material.dart';
import 'package:musicplayer/fonctions/FirestoreHelper.dart';
import '../View/Dashboard.dart';
import '../library/lib.dart';

class Inscription extends StatefulWidget {
    @override
    State<StatefulWidget> createState() {
        // TODO: implement createState
        return InscriptionState();
    }
}

class InscriptionState extends State<Inscription> {
    @override

    String prenom = "";
    String nom = "";
    String mail = "";
    String password = "";

    // Fonctions
    Dialogue(){
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context){
                return AlertDialog(
                    title: const Text("Erreur"),
                    content: const Text("Votre compte n'a pas été créé"),
                    actions: [
                        ElevatedButton(
                            onPressed: (){
                                Navigator.pop(context);
                            },
                            child: const Text("OK"),
                        ),
                    ],
                );
            }
        );
    }

    Widget build(BuildContext context) {
        // TODO: implement build
        return bodyPage();
    }

    Widget bodyPage(){
        return Column(
            children: [
                TextField(
                    decoration: const InputDecoration(
                        hintText: "Entrer votre prénom",
                    ),
                    onChanged: (value){
                        setState(() {
                            prenom = value;
                        });
                    },
                ),
                TextField(
                    decoration: const InputDecoration(
                        hintText: "Entrer votre nom",
                    ),
                    onChanged: (value){
                        setState(() {
                            nom = value;
                        });
                    },
                ),
                TextField(
                    decoration: const InputDecoration(
                        hintText: "Entrer votre email",
                    ),
                    onChanged: (value){
                        setState(() {
                            mail = value;
                        });
                    },
                ),
                TextField(
                    decoration: const InputDecoration(
                        hintText: "Entrer votre mot de passe",
                    ),
                    onChanged: (value){
                        setState(() {
                            password = value;
                        });
                    },
                ),

                SizedBox(height: 10),

                ElevatedButton(
                    onPressed: (){
                        FirestoreHelper().register(prenom, nom, mail, password).then((value){
                            setState(() {
                                MonUser = value;
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context){
                                        return DashBoard();
                                    }
                                ));
                            });
                        }).catchError((error){
                            Dialogue();
                        });
                    },
                    child: Text("Inscription"),
                )
            ],
        );
    }
}