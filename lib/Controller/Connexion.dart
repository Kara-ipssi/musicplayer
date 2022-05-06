import 'package:flutter/material.dart';
import 'package:musicplayer/View/Dashboard.dart';
import 'package:musicplayer/fonctions/FirestoreHelper.dart';
import 'package:musicplayer/library/lib.dart';

class Connexion extends StatefulWidget {
    @override
    State<StatefulWidget> createState() {
        // TODO: implement createState
        return ConnexionState();
    }
}

class ConnexionState extends State<Connexion> {
    @override

    String mail = "";
    String password = "";

    // Fonctions
    Dialogue(){
        showDialog(
            context: context,
            builder: (context){
                return AlertDialog(
                    title: const Text("Erreur"),
                    content: const Text("Votre adresser email ou votre mot de passe est incorrect"),
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

                const SizedBox(height: 10),

                ElevatedButton(
                    onPressed: (){
                        FirestoreHelper().connect(mail, password).then((value){
                            setState(() {
                                MonUser = value;
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context){
                                        return DashBoard();
                                    }
                                ));
                            });
                        }).catchError((error){
                            // Boite de dialogue d'erreur
                            Dialogue();
                        });
                    }, 
                    child: const Text("Connexion"),
                ),
            ],
        );
    }
}