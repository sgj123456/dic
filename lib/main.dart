import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:word_king/collect.dart';
import 'package:word_king/json.dart';
import 'sqlite.dart';

void main() {
  runApp(MaterialApp(
    home: DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            title: const Text("万词王"),
            leading: const Icon(Icons.abc),
            backgroundColor: const Color.fromARGB(0, 0, 0, 0),
            bottom: const TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.ice_skating),
                ),
                Tab(
                  icon: Icon(Icons.icecream),
                )
              ],
            ),
          ),
          body: TabBarView(
            children: [
              const Home(),
              CollectWords(
                dbIO: DbIO(),
              )
            ],
          )),
    ),
  ));
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
  List<WordAll> result = [];
  List<WordAll> dictionary = [];
  Timer? timer;

  @override
  void initState() {
    super.initState();
    AssetBundle bundle = DefaultAssetBundle.of(context);
    bundle.loadString("json/dictionary.json").then((value) {
      dictionary = json.decode(value).map<WordAll>((v) {
        return WordAll.fromJson(v);
      }).toList();
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
                      result = [];
                    } else {
                      result = dictionary.where((element) {
                        return RegExp(input).hasMatch(element.word!);
                      }).toList();
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
            child: Words(
              result: result,
              dictionary: dictionary,
            ),
          ),
        )
      ],
    );
  }
}

class Words extends StatefulWidget {
  const Words({super.key, required this.result, required this.dictionary});

  final List<WordAll> dictionary;
  final List<WordAll> result;

  @override
  State<StatefulWidget> createState() => _Words();
}

class _Words extends State<Words> {
  late DbIO dbIO;

  @override
  void initState() {
    super.initState();
    dbIO = DbIO();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.all(0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, childAspectRatio: 2.5),
        itemCount: widget.result.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            margin: const EdgeInsets.all(2),
            child: ElevatedButton(
                style:
                    ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
                onLongPress: () async {
                  await dbIO.insertCollectWord(WordData(
                      id: index,
                      word: widget.result[index].word!,
                      attribute: json.encode(widget.result[index].attribute),
                      note: "null"));
                  await dbIO.getCollectWord().then((value) {});
                },
                onPressed: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  setState(() {
                    showDialog(
                        context: context,
                        builder: (ctx) {
                          return SimpleDialog(
                            title: Text(widget.result[index].word!),
                            titlePadding: const EdgeInsets.all(10),
                            backgroundColor: Colors.white,
                            elevation: 5,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            children: (() {
                              List<Widget> widgetList = [];
                              widget.result[index].attribute
                                  ?.forEach((key, value) {
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
                  widget.result[index].word!,
                  overflow: TextOverflow.ellipsis,
                )),
          );
        });
  }
}
