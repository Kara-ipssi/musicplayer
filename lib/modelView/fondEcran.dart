import 'package:flutter/material.dart';

import 'customPath.dart';


class FondEcran extends StatefulWidget{
    @override
    State<StatefulWidget> createState() {
        // TODO: implement createState
        return FondEcranState();
    }
}

class FondEcranState extends State<FondEcran>{
    @override
    Widget build(BuildContext context) {

        return ClipPath(

            clipper: customPath(),

            child: Container(

                width: MediaQuery.of(context).size.width,

                height: MediaQuery.of(context).size.height,

                decoration: const BoxDecoration(

                    image: DecorationImage(

                        image: AssetImage("assets/images/saitama.jpg"),

                        fit: BoxFit.fill,

                    )

                ),

            )

        );
        
    }
}