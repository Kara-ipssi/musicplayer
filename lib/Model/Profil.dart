

import 'package:cloud_firestore/cloud_firestore.dart';

class Profil {
    // Attributes
    late String uid;
    late DateTime isInscription;
    late bool isConnected;
    late String prenom;
    late String nom;
    String? pseudo;
    String? image;
    List <String>? songs;
    late String mail;


    // Constructor
    Profil(DocumentSnapshot snapshot) {
        uid = snapshot.id;
        Map<String, dynamic> map = snapshot.data() as Map<String, dynamic>;
        Timestamp timestamp = map["ISINSCRIPTION"];
        isInscription = timestamp.toDate();
        isConnected = map["ISCONNECTED"];
        prenom = map["PRENOM"];
        nom = map["NOM"];
        pseudo = map["PSEUDO"];
        image = map["IMAGE"];
        songs = map["SONGS"];
        mail = map["MAIL"];
    }
}