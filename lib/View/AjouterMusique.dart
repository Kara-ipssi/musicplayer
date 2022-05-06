// ignore: unnecessary_import
import 'dart:typed_data';

import 'package:awesome_icons/awesome_icons.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:musicplayer/fonctions/FirestoreHelper.dart';
import 'package:musicplayer/library/lib.dart';
import 'package:musicplayer/modelView/fondEcran.dart';
import 'package:random_string/random_string.dart';

class AjouterMusic extends StatefulWidget {
  const AjouterMusic({Key? key}) : super(key: key);

    @override
    State<StatefulWidget> createState() {
        // TODO: implement createState
        return AjouterMusicState();
    }
}

class AjouterMusicState extends State<AjouterMusic>{
    
    // Variables 
    String title = "";
    String lien = "";
    String? pochette;
    String? artist;
    String? album;
    DateTime sortie = DateTime.now();
    type myCategory = type.jazz;
    bool isImageselected = false;
    Uint8List? bytesData;
    String? nameFichier;

    recupererFichier () async {
        FilePickerResult? result = await FilePicker.platform.pickFiles(
            withData: true,
            type: (isImageselected)?FileType.image:FileType.audio
        );
        if (result != null) {
            setState(() {
                nameFichier = result.files.first.name;
                bytesData = result.files.first.bytes;
            });
            if(isImageselected){
                boiteDialogue();
            }
            else {
                // stocker directement le son dans la base de données
                FirestoreHelper().stockageFile(nameFichier!, bytesData!, isImageselected).then((value){
                    setState(() {
                        lien = value;
                    });
                });
            }
        }
    }

    boiteDialogue () {
        showDialog(
            context: context,
            builder: (context) {
                return AlertDialog(
                    title: const Text("Voulez vous ajouter cette image ?"),
                    content: Image.memory(bytesData!),
                    actions: [
                        ElevatedButton(
                            onPressed: (){
                                FirestoreHelper().stockageFile(nameFichier!, bytesData!, isImageselected).then((value){
                                    setState(() {
                                        pochette = value;
                                    });
                                });

                                Navigator.pop(context);
                            }, 
                            child: const Text("Valider")
                        )
                    ]
                );
            }
        );
    }

    @override
    Widget build(BuildContext context) {

        // TODO: implement build
        return Scaffold(

            body: Stack(

                children: [

                    FondEcran(),

                    Center(

                        child: bodyPage(),

                    )

                ],

            ),

        );
    }

    Widget bodyPage(){
        return Column(
            children: [
                // titre de la musique
                TextField(
                    decoration: const InputDecoration(
                        hintText: "Entrer le titre de la musique",
                    ),
                    onChanged: (value){
                        setState(() {
                            title = value;
                        });
                    },
                ),

                // Envoyer la musique dans la base de données
                ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.amber,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.all(10),
                    ),
                    onPressed: (){
                        setState(() {
                            isImageselected = false;
                        });
                        recupererFichier();
                    },
                    icon: const Icon(FontAwesomeIcons.music),
                    label: const Text("Ajouter la musique"),
                ),


                // album
                TextField(
                    decoration: const InputDecoration(
                        hintText: "Entrer le nom de l'album",
                    ),
                    onChanged: (value){
                        setState(() {
                            album = value;
                        });
                    },
                ),

                // Artiste
                TextField(
                    decoration: const InputDecoration(
                        hintText: "Le nom de l'artiste",
                    ),
                    onChanged: (value){
                        setState(() {
                            artist = value;
                        });
                    },
                ),

                ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.amber,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.all(10),
                    ),
                    onPressed: (){
                        setState(() {
                            isImageselected = true;
                        });
                        recupererFichier();
                    },
                    icon: const Icon(FontAwesomeIcons.image),
                    label: const Text("Ajouter la pochette"),
                ),

                // date de sortie


                // Catégorie
                DropdownButtonFormField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                        )
                    ),
                    value: myCategory,
                    items: type.values.map((value){
                        return DropdownMenuItem(
                            value: value,
                            child: Text(value.toString().substring(5))
                        );
                    }).toList(),
                    onChanged: (type? newValue){
                        setState(() {
                            myCategory = newValue!;
                        });
                    },
                ),


                // Button
                ElevatedButton(
                    onPressed: (){
                        Map<String, dynamic> map = {
                            "NAMEMUSIC": title,
                            "LIENMUSIC": lien,
                            "CATEGORY": myCategory.toString(),
                            "SORTIE": DateTime.now(),
                            "ARTIST": artist,
                            "POCHETTE": pochette,
                            "ALBUM": album,
                        };
                        String uid = randomAlphaNumeric(20);
                        FirestoreHelper().addMusic(uid, map);
                    },
                    child: const Text("Enregistrer"),
                )
            ]
        );
    }
}