import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:word_king/sqlite.dart';

class CollectWords extends StatefulWidget {
  CollectWords({super.key, required this.dbIO});

  late DbIO dbIO;

  @override
  State<StatefulWidget> createState() => _CollectWords();
}

class _CollectWords extends State<CollectWords> {
  List<WordData> result = [];

  @override
  void initState() {
    super.initState();
    widget.dbIO.getCollectWord().then((value) {
      result = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    widget.dbIO.getCollectWord().then((value) {
      setState(() {
        result = value;
      });
    });
    List<Widget> list = result.map((e) {
      return ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
          onLongPress: () async {
            await widget.dbIO.deleteCollectWord(e.id);
            setState(() {
              widget.dbIO.getCollectWord().then((value) {
                result = value;
              });
            });
          },
          onPressed: () {
            FocusScope.of(context).requestFocus(FocusNode());
            setState(() {
              showDialog(
                  context: context,
                  builder: (ctx) {
                    return SimpleDialog(
                      title: Text(e.word),
                      titlePadding: const EdgeInsets.all(10),
                      backgroundColor: Colors.white,
                      elevation: 5,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      children: (() {
                        List<Widget> widgetList = [];
                        json.decode(e.attribute)?.forEach((key, value) {
                          widgetList.add(ListTile(
                            title: Text("$key $value"),
                          ));
                        });
                        return widgetList;
                      })(),
                    );
                  });
            });
          },
          child: Text(
            e.word,
            overflow: TextOverflow.ellipsis,
          ));
    }).toList();

    return GridView.count(
      crossAxisCount: 4,
      children: list,
    );
  }
}
