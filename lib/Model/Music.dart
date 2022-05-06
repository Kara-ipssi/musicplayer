
import 'package:cloud_firestore/cloud_firestore.dart';

import '../library/lib.dart';

class Music {
    // Atributes
    late String _uid;
    late String _nameMusic;
    late String _lienMusic;
    late type category;
    late String value;
    String? artist;
    late DateTime sortie;
    String?  pochette;
    String? album;

    // Getters
    String get uid {
        return _uid;
    }

    String get nameMusic {
        return _nameMusic;
    }

    String get lienMusic {
        return _lienMusic;
    }

    // Setters
    set nameMusic(String value) {
        _nameMusic = value;
    }
    

    // Contructor
    Music(DocumentSnapshot snapshot) {
        _uid = snapshot.id;
        Map<String, dynamic> map = snapshot.data() as Map<String, dynamic>;
        _nameMusic = map["NAMEMUSIC"];
        _lienMusic = map["LIENMUSIC"];
        value = map["CATEGORY"];
        category = convertion(value);
        artist = map["ARTIST"];
        Timestamp timestamp = map["SORTIE"];
        sortie = timestamp.toDate();
        pochette = map["POCHETTE"];
        album = map["ALBUM"];
    }


    // Methods

    type convertion(String value){
        switch(value){
            case "type.rap": return type.rap;
            case "type.rock": return type.rock;
            case "type.pop": return type.pop;
            case "type.metal": return type.metal;
            case "type.jazz": return type.jazz;
            case "type.electro": return type.electro;
            case "type.reggae": return type.reggae;
            case "type.blues": return type.blues;
            case "type.hiphop": return type.hiphop;
            case "type.other": return type.other;
            case "type.zouk": return type.zouk;
            case "type.classique": return type.classique;
            default: return type.rap;
        }
    }
}