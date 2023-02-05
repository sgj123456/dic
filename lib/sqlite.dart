import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

class WordData {
  final int id;
  final String word;
  final String attribute;
  final String? note;

  const WordData(
      {required this.id,
      required this.word,
      required this.attribute,
      required this.note});

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'word': word,
      'attribute': attribute,
      'note': note,
    };
  }

  @override
  String toString() {
    return 'WordData{id: $id, word: $word, attribute: $attribute,note: $note}';
  }
}

class DbIO {
  Future<Database> dataBase;

  DbIO()
      : dataBase = Future.sync(() async {
          WidgetsFlutterBinding.ensureInitialized();
          return openDatabase(
            path.join(await getDatabasesPath(), 'data.db'),
            onCreate: (db, version) {
              return db.execute(
                'CREATE TABLE collect(id INTEGER PRIMARY KEY, word TEXT, attribute TEXT, note TEXT)',
              );
            },
            version: 1,
          );
        });

  Future<void> insertCollectWord(WordData wordData) async {
    final db = await dataBase;
    await db.insert(
      'collect',
      wordData.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<WordData>> getCollectWord() async {
    final db = await dataBase;
    final List<Map<String, dynamic>> maps = await db.query('collect');
    return List.generate(maps.length, (i) {
      return WordData(
        id: maps[i]['id'],
        word: maps[i]['word'],
        attribute: maps[i]['attribute'],
        note: maps[i]['note'],
      );
    });
  }

  Future<void> updateCollectWord(WordData wordData) async {
    final db = await dataBase;
    await db.update(
      'collect',
      wordData.toMap(),
      where: 'id = ?',
      whereArgs: [wordData.id],
    );
  }

  Future<void> deleteCollectWord(int id) async {
    final db = await dataBase;
    await db.delete(
      'collect',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
