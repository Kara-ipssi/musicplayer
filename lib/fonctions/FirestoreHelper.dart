import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:firebase_storage/firebase_storage.dart";
import 'package:musicplayer/Model/Profil.dart';

class FirestoreHelper {
    final auth = FirebaseAuth.instance;
    final storage = FirebaseStorage.instance;
    final fireUser = FirebaseFirestore.instance.collection("Utilisateurs");
    final fireMusic = FirebaseFirestore.instance.collection("Musiques");

    // Inscription d'un utilisateur
    Future <Profil> register(String prenom, String nom, String mail, String password) async {
        UserCredential result = await auth.createUserWithEmailAndPassword(email: mail, password: password);
        String uid = result.user!.uid;
        Map<String, dynamic> map = {
            "PRENOM": prenom,
            "NOM": nom,
            "MAIL": mail,
            "ISINSCRIPTION": DateTime.now(),
            "ISCONNECTED": true,
        };
        addUser(uid, map);
        return getProfil(uid);
    }

    // Connexion d'un utilisateur
    Future <Profil> connect(String mail, String password) async {
        UserCredential result = await auth.signInWithEmailAndPassword(email: mail, password: password);
        return getProfil(result.user!.uid);
    }

    // obtenir l'utilisateur connecté
    String getCurrentUserId() {
        return auth.currentUser!.uid;
    }


    Future <Profil> getProfil(String uid) async {
        DocumentSnapshot snapshot = await fireUser.doc(uid).get();
        return Profil(snapshot);
    }

    // ajout d'un utilisateur dans la base de données
    addUser(String uid, Map<String, dynamic> map) {
        fireUser.doc(uid).set(map);
    }

    updateUser(String uid, Map<String, dynamic> map) {
        fireUser.doc(uid).update(map);
    }

    addMusic(String uid, Map<String, dynamic> map) {
        fireMusic.doc(uid).set(map);
    }

    updateMusic(String uid, Map<String, dynamic> map) {
        fireMusic.doc(uid).update(map);
    }

    // Stockager de fichier dans la base de données
    Future <String> stockageFile(String nameFile, Uint8List datas, bool imageSelected) async {
        String pathFile = "";
        late TaskSnapshot snap;
        if (imageSelected) {
            snap = await storage.ref("pictures/$nameFile").putData(datas);
        }
        else {
            snap = await storage.ref("songs/$nameFile").putData(datas);
        }
        pathFile = await snap.ref.getDownloadURL();
        return pathFile;
    }

}