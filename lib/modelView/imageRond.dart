import 'package:flutter/cupertino.dart';
import 'package:musicplayer/library/constant.dart';

class ImageRond extends StatefulWidget {
    @override
    State<StatefulWidget> createState() {
        // TODO: implement createState
        return ImageRondState();
    }
}

class ImageRondState extends State<ImageRond>{
    @override
    Widget build(BuildContext context) {
        // TODO: implement build
        return Center(
            child: bodyPage(),
        );
    }

    Widget bodyPage() {
        return Container(
            height: 120,
            width: 120,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: (MonUser.image == null) ? const NetworkImage("https://firebasestorage.googleapis.com/v0/b/karazzic.appspot.com/o/saitama_ok.png?alt=media&token=3fc6b675-c56e-43cf-8c80-9f57902d93f0") : NetworkImage(MonUser.image!),
                    fit: BoxFit.fill,

                )
            ),
        );
    }
}