import 'package:awesome_icons/awesome_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:musicplayer/View/AjouterMusique.dart';
import 'package:musicplayer/View/detailMusique.dart';
import 'package:musicplayer/modelView/fondEcran.dart';
import 'package:musicplayer/Model/Music.dart';
import 'package:musicplayer/fonctions/FirestoreHelper.dart';
import 'package:musicplayer/modelView/myDrawer.dart';


class DashBoard extends StatefulWidget {
  const DashBoard({Key? key}) : super(key: key);

    @override
    State<StatefulWidget> createState() {
        // TODO: implement createState
        return DashBoardState();
    }
}

class DashBoardState extends State<DashBoard>{
    @override
    Widget build(BuildContext context) {
        // TODO: implement build
        return Scaffold(
        //Burger
        drawer: Container(
            child:  myDrawer(),
            width: MediaQuery.of(context).size.width/4 * 3,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.only(bottomRight: Radius.circular(40))
            ),

        ),

        ////
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            actions: [
            IconButton(
                onPressed: (){
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context){
                        return AjouterMusic();

                        }
                    ));
                },
                icon: const Icon(FontAwesomeIcons.plusCircle,color: Colors.amber,)
            )
            ],
        ),
        extendBodyBehindAppBar: true,
        //extendBody: true,

        body: Stack(
            children: [

                FondEcran(),
                Center(
                    child: bodyPage(),
                ),

            ],
        ),


        );


    }
    Widget bodyPage(){
        return StreamBuilder<QuerySnapshot>(
            stream: FirestoreHelper().fireMusic.snapshots(),
            builder: (context,snapshot){
            print(snapshot.data?.docs);
            if(snapshot.data?.docs == null){

                return const Center(
                child: Text("Pas de musique existante ...."),
                );
            }
            else
                {
                List documents = snapshot.data!.docs;
                return GridView.builder(
                    itemCount: documents.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                    itemBuilder: (context,index){
                        Music morceau = Music(documents[index]);
                        return InkWell(
                            child: Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: (morceau.pochette == null)?const NetworkImage("https://firebasestorage.googleapis.com/v0/b/karazzic.appspot.com/o/cover.jpg?alt=media&token=12bfee98-e9f5-45b4-a91d-cbfaca72cf9d")
                                            :NetworkImage(morceau.pochette!),
                                        fit: BoxFit.fill
                                    )
                                ),
                            ),
                            onTap: (){
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context){
                                        return detailMusique(musique: morceau);
                                        // return const Text("detailMusique");
                                    },
                                ));
                            },
                        );
                    }
                );
                }
            }
        );
    }

}