import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

void main() async {
  runApp(
    MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text("万词王"),
            leading: const Icon(Icons.abc),
            backgroundColor: const Color.fromARGB(0, 0, 0, 0),
          ),
          body: const Home()),
    ),
  );
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return const WordSystem();
  }
}

class WordSystem extends StatefulWidget {
  const WordSystem({super.key});

  @override
  State<StatefulWidget> createState() {
    return _WordSystem();
  }
}

class _WordSystem extends State<WordSystem> {
  final _controller = TextEditingController();
  List<List<String>> list = [];
  late List<List<String>> dictionary;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    AssetBundle bundle = DefaultAssetBundle.of(context);
    bundle.loadString("json/dictionary.json").then((value) {
      List dynamic = json.decode(value).toList();
      var temp = dynamic
          .map<List<String>>((e) => e.map<String>((v) => v.toString()).toList())
          .toList();
      dictionary = temp;
    });
  }

  void debounce(Function function) {
    setState(() {
      timer?.cancel();
      timer = Timer(const Duration(milliseconds: 200), () {
        function();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            margin: const EdgeInsets.all(15),
            child: TextField(
              onChanged: (input) {
                debounce(() {
                  setState(() {
                    if (input.isEmpty) {
                      list = [];
                    } else {
                      list = dictionary
                          .where(
                              (element) => RegExp(input).hasMatch(element[0]))
                          .toList();
                    }
                  });
                });
              },
              controller: _controller,
              style: Theme.of(context).textTheme.headlineSmall,
              decoration: const InputDecoration(
                  labelText: "支持输入正则表达式",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)))),
            )),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(5),
            child: Words(list: list),
          ),
        )
      ],
    );
  }
}

class Words extends StatefulWidget {
  const Words({super.key, required this.list});

  final List<List<String>> list;

  @override
  State<StatefulWidget> createState() => _Words();
}

class _Words extends State<Words> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.all(0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, childAspectRatio: 2.5),
        itemCount: widget.list.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            margin: const EdgeInsets.all(2),
            child: ElevatedButton(
                style:
                    ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
                onPressed: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  setState(() {
                    showDialog(
                        context: context,
                        builder: (ctx) {
                          return SimpleDialog(
                            title: Text(widget.list[index][0]),
                            titlePadding: const EdgeInsets.all(10),
                            backgroundColor: Colors.white,
                            elevation: 5,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            children: (() {
                              List<Widget> widgetList = [];
                              for (int i = 1;
                                  i < widget.list[index].length - 1;
                                  i += 2) {
                                widgetList.add(ListTile(
                                  title: Center(
                                    child: Text(
                                      "${widget.list[index][i]} ${widget.list[index][i + 1]}",
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ));
                              }
                              return widgetList;
                            })(),
                          );
                        });
                  });
                },
                child: Text(
                  widget.list[index][0],
                  overflow: TextOverflow.ellipsis,
                )),
          );
        });
  }
}
