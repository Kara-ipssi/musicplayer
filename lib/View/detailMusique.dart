import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:musicplayer/Model/Music.dart';
import 'package:musicplayer/library/lib.dart';
import '../modelView/fondEcran.dart';
import 'package:audioplayers/audioplayers.dart';

class detailMusique extends StatefulWidget {
    Music musique;
    detailMusique({required Music this.musique});
    @override
    State<StatefulWidget> createState() {
        // TODO: implement createState
        return detailMusiqueState();
    }
}

class detailMusiqueState extends State<detailMusique> {
    // variables
    statut lecture = statut.stopped;
    AudioPlayer audioPlayer = AudioPlayer();
    Duration positionement = Duration(seconds: 0);
    late StreamSubscription positionStream;
    late StreamSubscription stateStream;
    Duration dureeTotal = Duration(seconds: 0);
    double volumeSound = 1;
    bool isPlaying = false;

    // Fonctions 
    configurationPlayer() async {
        await audioPlayer.setUrl(widget.musique.lienMusic);
        positionStream = audioPlayer.onAudioPositionChanged.listen((Duration event){
            setState(() {
                positionement = event;
            });
        });

        audioPlayer.onDurationChanged.listen((Duration event){
            setState(() async {
                dureeTotal = event;
            });
        });
        
        stateStream = audioPlayer.onPlayerStateChanged.listen((event){
            if(event == statut.playing){
                setState(() {
                    lecture = statut.playing;
                });
            }
            else if(event == statut.paused){
                setState(() {
                    lecture = statut.paused;
                });
            }
            else if(event == statut.stopped){
                setState(() {
                    lecture = statut.stopped;
                });
            }
        },
        onError: (error){
            print("Erreur : $error");
            setState(() {
                lecture = statut.stopped;
                positionement = Duration(seconds: 0);
                dureeTotal = Duration(seconds: 0);
            });
        });
    }

    // Fonction pour le bouton play
    Future play() async {
        await audioPlayer.play(widget.musique.lienMusic, position: positionement, volume: volumeSound);
        setState(() {
            isPlaying = true;
        });
    }

    // Fonction pour le bouton pause
    Future pause() async {
        await audioPlayer.pause();
        setState(() {
            isPlaying = false;
        });
    }

    // Fonction pour le bouton stop
    Future stop() async {
        await audioPlayer.stop();
        audioPlayer.seek(Duration(seconds: 0));
        setState(() {
            isPlaying = false;
            positionement = Duration(seconds: 0);
        });
    }

    // Fonction pour le bouton rewind
    Future rewind() async {
        if(positionement >= Duration(seconds: 10)){
            setState(() {
                pause();
                positionement = Duration(seconds: positionement.inSeconds.toInt() - 10);
                play();
            });
        }
        else{
            setState(() {
                stop();
                audioPlayer.play(widget.musique.lienMusic, position: positionement, volume: volumeSound);
                play();
            });
        }
    }

    // Fonction pour le bouton forward
    Future forward() async {
        if(positionement.inSeconds +10 <= dureeTotal.inSeconds){
            setState(() {
                positionement = Duration(seconds: positionement.inSeconds.toInt() + 10);
                pause();
                audioPlayer.play(widget.musique.lienMusic, position: positionement, volume: volumeSound);
            });
        }
        else{
            setState(() {
                stop();
                audioPlayer.play(widget.musique.lienMusic, position: positionement, volume: volumeSound);
                play();
            });
        }
    }

    @override
    void initState() {
        // TODO: implement initState
        super.initState();
        configurationPlayer();
    }


    @override
    Widget build(BuildContext context) {
        // TODO: implement build
        return Scaffold(
            appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0.0,
                actions: [
                    IconButton(
                        onPressed: () {
                            Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_back, color: Colors.amber),
                    )
                ],
            ),
            extendBodyBehindAppBar: true,
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
        // afficher le detail de la musique 
        return Column(
            children: [
                // Pochettte de la musique
                Container(
                    // ajouter de la paddind au dessus de la pochette
                    padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.3),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height/2,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(widget.musique.pochette != null ? widget.musique.pochette! : ""),
                            fit: BoxFit.cover
                        )
                    ),
                ),

                // Titre de la musique
                Text(widget.musique.nameMusic,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                    ),
                ),

                // artist
                Text(widget.musique.artist!,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                    ),
                ),

                // categorie
                Text(widget.musique.category.toString().substring(5),
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                    ),
                ),

                // Icon de lecture, de pause, de stop, de rewind, de forward
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                        // icon reculer
                        IconButton(
                            onPressed: () {
                                rewind();
                            },
                            icon: const Icon(Icons.fast_rewind, color: Colors.amber),
                        ),
                        // si la musique est en lecture on affiche le bouton pause sino on affiche le bouton play
                        IconButton(
                            icon: isPlaying ? const Icon(Icons.pause) : const Icon(Icons.play_arrow),
                            onPressed: (){
                                setState(() {
                                    isPlaying = !isPlaying;
                                });
                                if(isPlaying){
                                    play();
                                }
                                else{
                                    pause();
                                }
                            },
                        ),
                        
                        // icon stop lorsque la musique est en lecture
                        IconButton(
                            onPressed: () {
                                stop();
                            },
                            icon: const Icon(Icons.stop, color: Colors.amber),
                        ),
                        // icon avance rapide de 10 secondes
                        IconButton(
                            onPressed: () {
                                forward();
                            },
                            icon: const Icon(Icons.fast_forward, color: Colors.amber),
                        ),
                    ],
                ),

                // Slider pour le lecteur
                Slider(
                    min: 0.0,
                    max: dureeTotal.inSeconds.toDouble(),
                    value: positionement.inSeconds.toDouble(),
                    onChanged: (double newValue) {
                        setState(() {
                            Duration time = Duration(seconds: newValue.toInt());
                            positionement = time;
                            audioPlayer.seek(positionement);
                        });
                    },
                ),
            ],
        );
    }
}
